//
//  NSInvocation.m
//  MulleObjC
//
//  Copyright (c) 2011 Nat! - Mulle kybernetiK.
//  Copyright (c) 2011 Codeon GmbH.
//  All rights reserved.
//
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//
//  Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  Neither the name of Mulle kybernetiK nor the names of its contributors
//  may be used to endorse or promote products derived from this software
//  without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.
//
#import "NSInvocation.h"

#import "NSMethodSignature.h"
#import "NSMethodSignature-Private.h"
#import "MulleObjCAllocation.h"
#import "NSAutoreleasePool.h"
#import "NSCopying.h"
#import "MulleObjCException.h"
#import "MulleObjCExceptionHandler.h"
#import "MulleObjCExceptionHandler-Private.h"
#import "MulleObjCFunctions.h"

#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"

#ifdef DEBUG
//# define DEBUG_INVOCATION
#endif

//
// what is somewhat tricky in the MetaABI is, that we need to store the
// parameter block properly aligned. We'd like to index directly into
// the invocation to get the block. For this we ensure (or rather
// NSMethodSignature) that "self" + "_cmd" are both pointersize.
// So if we "long double" align the whole thing we assume we are fine.
//

@interface NSInvocation( Forward)

- (void) _performArgumentMemberOperation:(SEL) sel
                                    type:(char *) type
                                 atIndex:(NSUInteger) i;

- (void) _performReturnMemberOperation:(SEL) sel
                                  type:(char *) type;

@end


@implementation NSInvocation

//
// The invocation frame is stored in "extra" bytes behind the instance.
// Since invocations should be speedy, we don't usually want to allocate a
// new invocation for every call. Instead what we do is have a FIFO of
// release NSInvocations ready for reuse.
//
#define NSInvocationStandardSize  (sizeof( void *) * 16)

struct mulle_pointermultififo   reuseInvocations;


static int   pushStandardInvocation( NSInvocation *invocation)
{
   // if full will return != 0
   return( _mulle_pointermultififo_write( &reuseInvocations, invocation));
}


static NSInvocation   *popStandardInvocation( void)
{
   NSInvocation                      *invocation;
   size_t                            size;
   struct _mulle_objc_class          *cls;
   struct _mulle_objc_objectheader   *header;

   invocation = _mulle_pointermultififo_read_barrier( &reuseInvocations);
   if( ! invocation)
      return( invocation);

   // make a fresh new invocation from old, reset retainCount as well
   cls  = _mulle_objc_object_get_isa( invocation);
   size = _mulle_objc_class_get_instancesize( cls) + NSInvocationStandardSize;
   memset( invocation, 0, size);

   header = _mulle_objc_object_get_objectheader( invocation);
   _mulle_atomic_pointer_write_nonatomic( &header->_retaincount_1, 0);

   _mulle_objc_objectheader_set_thread( header, mulle_thread_self());
   return( invocation);
}


+ (void) initialize
{
   _mulle_pointermultififo_init( &reuseInvocations, 8, MulleObjCClassGetAllocator( self));
}


+ (void) deinitialize
{
   NSInvocation   *invocation;

   while( (invocation = _mulle_pointermultififo_read_barrier( &reuseInvocations)))
   {
#ifdef DEBUG_INVOCATION
      fprintf( stderr, "dealloc, no reuse %p\n", invocation);
#endif
      _MulleObjCInstanceFree( invocation);
   }
   _mulle_pointermultififo_done( &reuseInvocations);
}


static int   is_valid_frame_range( NSInvocation *self, char *adr, size_t size)
{
   return( (adr >= self->_storage) && (&adr[ size] <= self->_sentinel));
}



static inline void   pointerAndSizeOfArgumentValue( NSInvocation *self,
                                                    NSUInteger i,
                                                    void **p_adr,
                                                    size_t *p_size)
{
   MulleObjCMethodSignatureTypeInfo   *p;
   char                               *adr;
   size_t                             size;

   if( ! self->_methodSignature)
      MulleObjCThrowInternalInconsistencyExceptionUTF8String( "methodSignature not found on target");
   p    = [self->_methodSignature mulleSignatureTypeInfoAtIndex:i];
   adr  = &((char *) self->_storage)[ p->invocation_offset];
   size = p->natural_size;

   if( ! is_valid_frame_range( self, adr, size))
      MulleObjCThrowInvalidIndexException( i);

   *p_adr  = adr;
   *p_size = size;
}



+ (NSInvocation *) invocationWithMethodSignature:(NSMethodSignature *) signature
{
   NSUInteger                      size;
   NSInvocation                    *invocation;
   void                            *extraBytes;
   struct _mulle_objc_infraclass   *cls;

   if( ! signature)
   {
      __mulle_objc_universe_raise_invalidargument( _mulle_objc_object_get_universe( self),
                                                   "signature is nil");
      return( nil);
   }

//   frame_size  = [signature frameLength];
//   size        = mulle_metaabi_sizeof_union( frame_size);
//   size       += [signature methodReturnLength];
//   size       += alignof( long double);  // for alignment

   // if size is smaller than what we allocate as standard size adjust up
   // to standard size
   size       = [signature mulleInvocationSize];
   invocation = nil;
   if( size <= NSInvocationStandardSize)
   {
      cls = (struct _mulle_objc_infraclass *) self;
      if( _mulle_objc_infraclass_get_classid( cls) == @selector( NSInvocation))
      {
         size       = NSInvocationStandardSize;
         invocation = popStandardInvocation();
#ifdef DEBUG_INVOCATION
         if( invocation)
            fprintf( stderr, "popped for reuse %p\n", invocation);
#endif
      }
   }

   if( ! invocation)
      invocation = NSAllocateObject( self, size, NULL);

   extraBytes                   = MulleObjCInstanceGetExtraBytes( invocation);
   invocation->_storage         = mulle_pointer_align( extraBytes, alignof( long double));
   invocation->_sentinel        = &((char *) invocation->_storage)[ size];
   invocation->_methodSignature = [signature retain];

   return( [invocation autorelease]);
}


+ (NSInvocation *) mulleInvocationWithTarget:(id) target
                                    selector:(SEL) sel, ...

{
   char                               *adr;
   mulle_vararg_list                  arguments;
   MulleObjCMethodSignatureTypeInfo   *p;
   NSInvocation                       *invocation;
   NSMethodSignature                  *signature;
   NSUInteger                         i, n;
   unsigned int                       size;
   void                               *src;

   signature  = [target methodSignatureForSelector:sel];
   invocation = [self invocationWithMethodSignature:signature];
   [invocation setTarget:target];
   [invocation setSelector:sel];

   //
   // The incoming metaABI block is made up of mulle-vararg promoted values
   // so we can not just memcpy them into the invocation metaABI block
   //
   mulle_vararg_start( arguments, sel);
   {
      n = [signature numberOfArguments];
      for( i = 2; i < n; ++i)
      {
         // use internal index for mulleSignatureTypeInfoAtIndex!
         p    = [signature mulleSignatureTypeInfoAtIndex:i + 1];
         adr  = &((char *) invocation->_storage)[ p->invocation_offset];
         size = p->natural_size;

         if( ! is_valid_frame_range( invocation, adr, size))
            __mulle_objc_universe_raise_invalidindex( NULL, i);

         src = _mulle_vararg_aligned_struct( &arguments, size, p->natural_alignment);
         _mulle_objc_typeinfo_demote_value_to_natural( p, adr, src);
      }
   }
   mulle_vararg_end( arguments);

   return( invocation);
}


+ (NSInvocation *) mulleInvocationWithTarget:(id) target
                                    selector:(SEL) sel
                                      object:(id) object
{
   NSInvocation        *invocation;
   NSMethodSignature   *signature;

   signature = [target methodSignatureForSelector:sel];
   if( ! signature)
      MulleObjCThrowInternalInconsistencyExceptionUTF8String( "method not found on target");
   if( [signature numberOfArguments] != 3)
      MulleObjCThrowInternalInconsistencyExceptionUTF8String( "method must accept one argument");
   if( [signature isVariadic])
      MulleObjCThrowInternalInconsistencyExceptionUTF8String( "method must not be variadic");

   invocation = [self invocationWithMethodSignature:signature];
   [invocation setTarget:target];
   [invocation setSelector:sel];
   [invocation setArgument:&object
                   atIndex:2];

   return( invocation);
}


+ (NSInvocation *) mulleInvocationWithTarget:(id) target
                                    selector:(SEL) sel
                                metaABIFrame:(void *) param
{
   NSInvocation                       *invocation;
   NSMethodSignature                  *signature;
#if 0
   NSUInteger                         length;
   void                               *adr;
   MulleObjCMethodSignatureTypeInfo   *p;
#endif
   signature = [target methodSignatureForSelector:sel];
   if( ! signature)
      MulleObjCThrowInternalInconsistencyExceptionUTF8String( "method %x not found on target", sel);
   if( [signature isVariadic])
      MulleObjCThrowInternalInconsistencyExceptionUTF8String( "method must not be variadic");

   invocation = [self invocationWithMethodSignature:signature];
   [invocation setTarget:target];
   [invocation setSelector:sel];
   [invocation _setMetaABIFrame:param];

#if 0
   switch( [signature _methodMetaABIParameterType])
   {
   case MulleObjCMetaABITypeVoidPointer    :
      [invocation setArgument:&frame
                      atIndex:2];
      break;

   case MulleObjCMetaABITypeParameterBlock :
      length = [signature mulleMetaABIFrameLength];
      p      = [signature mulleSignatureTypeInfoAtIndex:2 + 1];
      adr    = &((char *) invocation->_storage)[ p->invocation_offset];
      memcpy( adr, frame, length);

   case MulleObjCMetaABITypeVoid           :
      break;
   }
#endif
   return( invocation);
}


static BOOL   _isStandardInvocation( NSInvocation *invocation)
{
   struct _mulle_objc_infraclass   *cls;

   // only push if it's not a subclass
   cls = (struct _mulle_objc_infraclass *) _mulle_objc_object_get_isa( invocation);
   if( _mulle_objc_infraclass_get_classid( cls) != @selector( NSInvocation))
      return( NO);

   return( invocation->_sentinel - invocation->_storage == NSInvocationStandardSize);
}


- (void) finalize
{
   // wird wohl seinen grund haben
}


- (void) dealloc
{
   if( _argumentsRetained)
      [self _releaseArguments];
   if( _returnValueRetained)
      [self _releaseReturnValue];
   [_methodSignature release];

   if( _isStandardInvocation( self))
   {
      if( ! pushStandardInvocation( self))
      {
#ifdef DEBUG_INVOCATION
         fprintf( stderr, "push invocation %p for reuse \n", self);
#endif
         return;
      }
   }
   _MulleObjCInstanceFree( self);
}


- (void) _releaseArguments
{
   NSInteger                          i, n;
   id                                 obj;
   char                               *s;
   MulleObjCMethodSignatureTypeInfo   *info;

   n = [_methodSignature numberOfArguments];
   for( i = 0; i < n; ++i)
   {
      // this indexes with 0: rval
      info = [_methodSignature mulleSignatureTypeInfoAtIndex:i + 1];
      switch( *info->type)
      {
      case _C_ARY_B     :
      case _C_STRUCT_B  :
      case _C_UNION_B   :
         if( info->has_retainable_type)
            [self _performArgumentMemberOperation:@selector( release)
                                signatureTypeInfo:info
                                          atIndex:i];
         break;

      case _C_COPY_ID   :
      case _C_RETAIN_ID :
         [self getArgument:&obj
                  atIndex:i];
         [obj release];
         break;

      case _C_CHARPTR :
         [self getArgument:&s
                  atIndex:i];
         mulle_allocator_free( MulleObjCInstanceGetAllocator( self), s);
         break;
      }
   }
}


- (void) _releaseReturnValue
{
   id                                 obj;
   char                               *s;
   MulleObjCMethodSignatureTypeInfo   *info;

   info = [_methodSignature mulleSignatureTypeInfoAtIndex:0];
   // can happen, if we just have an empty invocation
   if( ! info)
      return;

   switch( *info->type)
   {
   case _C_ARY_B     :
   case _C_STRUCT_B  :
   case _C_UNION_B   :
      if( info->has_retainable_type)
         [self _performReturnMemberOperation:@selector( release)
                           signatureTypeInfo:info];
      break;

   case _C_COPY_ID   :
   case _C_RETAIN_ID :
      [self getReturnValue:&obj];
      [obj release];
      break;

   case _C_CHARPTR :
      [self getReturnValue:&s];
      mulle_allocator_free( MulleObjCInstanceGetAllocator( self), s);
      break;
   }
}


static void   NSInvocationMakeObjectArgumentsPerformSelector( NSInvocation *self,
                                                              SEL sel)
{
   NSInteger                          i, n;
   id                                 obj;
   MulleObjCMethodSignatureTypeInfo   *info;

   // first do return value
   info = [self->_methodSignature mulleSignatureTypeInfoAtIndex:0];
   // can happen, if we just have an empty invocation
   if( ! info)
      return;

   switch( *info->type)
   {
   case _C_ARY_B     :
   case _C_STRUCT_B  :
   case _C_UNION_B   :
      if( info->has_retainable_type)
         [self _performReturnMemberOperation:sel
                           signatureTypeInfo:info];
      break;

   case _C_CLASS     :
   case _C_ASSIGN_ID :
   case _C_RETAIN_ID :
   case _C_COPY_ID   :
      [self getReturnValue:&obj];
      [obj performSelector:sel];
   }

   //  now do arguments value
   n = [self->_methodSignature numberOfArguments];
   for( i = 0; i < n; ++i)
   {
      info = [self->_methodSignature mulleSignatureTypeInfoAtIndex:i + 1];
      switch( *info->type)
      {
      case _C_ARY_B     :
      case _C_STRUCT_B  :
      case _C_UNION_B   :
         if( info->has_retainable_type)
            [self _performArgumentMemberOperation:sel
                                signatureTypeInfo:info
                                          atIndex:i];
         break;
      case _C_CLASS     :
      case _C_ASSIGN_ID :
      case _C_COPY_ID   :
      case _C_RETAIN_ID :
         [self getArgument:&obj
                  atIndex:i];
         [obj performSelector:sel];
         break;
      }
   }
}


- (void) mulleGainAccess
{
   [super mulleGainAccess];
   NSInvocationMakeObjectArgumentsPerformSelector( self, _cmd);
}


- (void) mulleRelinquishAccess
{
   NSInvocationMakeObjectArgumentsPerformSelector( self, _cmd);
   [super mulleRelinquishAccess];
}


- (NSMethodSignature *) methodSignature
{
   return( _methodSignature);
}


- (void) getReturnValue:(void *) value_p
{
   void     *adr;
   size_t   size;

   assert( value_p);

   pointerAndSizeOfArgumentValue( self, 0, &adr, &size);
   memcpy( value_p, adr, size);
}


- (void) setReturnValue:(void *) value_p
{
   void     *adr;
   size_t   size;

   assert( value_p);

   pointerAndSizeOfArgumentValue( self, 0, &adr, &size);
   memcpy( adr, value_p, size);
}


- (void) getArgument:(void *) value_p
             atIndex:(NSUInteger) i
{
   void     *adr;
   size_t   size;

   assert( value_p);

   pointerAndSizeOfArgumentValue( self, i + 1, &adr, &size);
   memcpy( value_p, adr, size);
}


- (void) setArgument:(void *) value_p
             atIndex:(NSUInteger) i
{
   void     *adr;
   size_t   size;

   assert( value_p);

   pointerAndSizeOfArgumentValue( self, i + 1, &adr, &size);
   memcpy( adr, value_p, size);
}


//
// Apple: If a returnvalue has been set, this is also retained or copied.
//
- (void) retainArguments
{
   NSInteger                          i, n;
   id                                 obj;
   char                               *s;
   char                               *dup;
   MulleObjCMethodSignatureTypeInfo   *info;

   if( _argumentsRetained)
      return;

   if( [_methodSignature isVariadic])
      MulleObjCThrowInternalInconsistencyExceptionUTF8String( "NSInvocation can not \
retain the arguments of variadic methods");

   _argumentsRetained = YES;

   n = [_methodSignature numberOfArguments];
   for( i = 0; i < n; ++i)
   {
      info = [_methodSignature mulleSignatureTypeInfoAtIndex:i + 1];
      switch( *info->type)
      {
      case _C_ARY_B     :
      case _C_STRUCT_B  :
      case _C_UNION_B   :
         if( info->has_retainable_type)
            [self _performArgumentMemberOperation:@selector( retain)
                                signatureTypeInfo:info
                                          atIndex:i];
         break;

      case _C_RETAIN_ID :
         [self getArgument:&obj
                  atIndex:i];
         // assert( [obj mulleIsAccessible]);  // can't do this !
         [obj retain];
         break;

      case _C_COPY_ID :
         [self getArgument:&obj
                  atIndex:i];
         obj = [(id <NSCopying>) obj copy];
         [self setArgument:&obj
                   atIndex:i];
         break;

      case _C_CHARPTR :
         [self getArgument:&s
                  atIndex:i];
         dup  = mulle_allocator_strdup( MulleObjCInstanceGetAllocator( self), s);
         [self setArgument:&dup
                  atIndex:i];
         break;
      }
   }
}


- (BOOL) argumentsRetained
{
   return( _argumentsRetained);
}


- (void) mulleRetainReturnValue
{
   id                                 obj;
   char                               *s;
   char                               *dup;
   MulleObjCMethodSignatureTypeInfo   *info;

   if( _returnValueRetained)
   {
#if DEBUG
      abort();
#endif
      return;
   }

   _returnValueRetained = YES;

   info = [_methodSignature mulleSignatureTypeInfoAtIndex:0];
   if( ! info)
      return;

   switch( *info->type)
   {
   case _C_ARY_B     :
   case _C_STRUCT_B  :
   case _C_UNION_B   :
      if( info->has_retainable_type)
         [self _performReturnMemberOperation:@selector( retain)
                           signatureTypeInfo:info];
      break;

   case _C_RETAIN_ID :
      [self getReturnValue:&obj];
      [obj retain];
      break;

   case _C_COPY_ID :
      [self getReturnValue:&obj];
      obj = [(id <NSCopying>) obj copy];
      [self setReturnValue:&obj];
      break;

   case _C_CHARPTR :
      [self getReturnValue:&s];
      dup  = mulle_allocator_strdup( MulleObjCInstanceGetAllocator( self), s);
      [self setReturnValue:&dup];
      break;
   }
}


- (BOOL) mulleReturnValueRetained
{
   return( _returnValueRetained);
}


- (SEL) selector
{
   SEL   result;

   MULLE_C_ASSERT( sizeof( SEL) == sizeof( mulle_objc_methodid_t));

   [self getArgument:&result
             atIndex:1];

   return( result);
}


- (void) setSelector:(SEL) selector
{
   [self setArgument:&selector
             atIndex:1];
}


- (id) target
{
   id   result;

   [self getArgument:&result
             atIndex:0];

   return( result);
}


- (void) setTarget:target
{
   [self setArgument:&target
             atIndex:0];
}


- (void) invoke
{
   [self invokeWithTarget:[self target]];
}


#ifdef DEBUG
static void   invocation_with_nil_target_warning( NSInvocation *self)
{
   static BOOL   once;

   if( ! once)
   {
      fprintf( stderr, "Invocation %p with nil target does nothing\n", self);
      once = YES;
   }
}
#endif


- (void) invokeWithTarget:(id) target
{
   MulleObjCMetaABIType               pType;
   MulleObjCMetaABIType               rType;
   MulleObjCMethodSignatureTypeInfo   *info;
   SEL                                sel;
   void                               *param;
   void                               *rval;

   if( ! target)
   {
#ifdef DEBUG
      invocation_with_nil_target_warning( self);
#endif
      return;
   }

   sel = [self selector];
   if( ! sel)
      MulleObjCThrowInternalInconsistencyExceptionUTF8String( "NSInvocation: selector has not been set yet");
   if( ! _methodSignature)
      MulleObjCThrowInternalInconsistencyExceptionUTF8String( "NSInvocation: methodSignature has not been set yet");

   pType = [_methodSignature _methodMetaABIParameterType];
   rType = [_methodSignature _methodMetaABIReturnType];

   param = NULL;
   switch( pType)
   {
   case MulleObjCMetaABITypeVoid           :
      if( rType == MulleObjCMetaABITypeParameterBlock)
      {
         info  = [self->_methodSignature mulleSignatureTypeInfoAtIndex:0];
         param = &self->_storage[ info->invocation_offset];
         rval  = mulle_objc_object_call_variable_inline( target, sel, param);
         break;
      }

      rval = mulle_objc_object_call_variable_inline( target, sel, target);
      break;

   case MulleObjCMetaABITypeVoidPointer    :
      info  = [self->_methodSignature mulleSignatureTypeInfoAtIndex:3];
      param = &self->_storage[ info->invocation_offset];
      rval  = mulle_objc_object_call_variable_inline( target, sel, *(void **) param);
      break;

   case MulleObjCMetaABITypeParameterBlock :
      info  = [self->_methodSignature mulleSignatureTypeInfoAtIndex:3];
      param = &self->_storage[ info->invocation_offset];
      rval  = mulle_objc_object_call_variable_inline( target, sel, param);
      break;
   }

   switch( rType)
   {
   case MulleObjCMetaABITypeVoid           :
      break;

   case MulleObjCMetaABITypeVoidPointer    :
      [self setReturnValue:&rval];
      break;

   case MulleObjCMetaABITypeParameterBlock :
      [self setReturnValue:param];
      break;
   }
}


- (void) _setMetaABIFrame:(void *) frame
{
   MulleObjCMethodSignatureTypeInfo   *info;
   void                               *param;
   size_t                             size;
   size_t                             frame_size;
   MulleObjCMetaABIType               pType;

   pType = [_methodSignature _methodMetaABIParameterType];
   switch( pType)
   {
   case MulleObjCMetaABITypeVoid :
      break;

   case MulleObjCMetaABITypeVoidPointer :
      // rval, self, _cmd, _param (3)
      info  = [self->_methodSignature mulleSignatureTypeInfoAtIndex:3];
      param = &((char *) self->_storage)[ info->invocation_offset];
      assert( is_valid_frame_range( self, param, sizeof( void *)));

      *((void **) param) = frame;
      break;

   case MulleObjCMetaABITypeParameterBlock :
      // rval, self, _cmd, _param (3)
      info  = [self->_methodSignature mulleSignatureTypeInfoAtIndex:3];
      param = &((char *) self->_storage)[ info->invocation_offset];

      // calculate amount we have to copy (how can frame be NULL ?)
      assert( frame);

      frame_size = [_methodSignature frameLength];
      size       = mulle_metaabi_sizeof_union( frame_size);
      size      -= sizeof( id) + sizeof( SEL); // _cmd is a pointer

      // blow up to metaABI size
      assert( is_valid_frame_range( self, param, size));

      memcpy( param, frame, size);
      break;
   }
}


- (int) mulleIntReturnValue
{
   char   *type;
   int    value;

   type = [_methodSignature methodReturnType];
   if( type)
      switch( *type)
      {
      case _C_INT       :
         [self getReturnValue:&value];
         return( value);
      }

   return( 0);
}


//
// When you have by value parameters like: struct { id x; id y }, then we
// would like to retain the id and strdup the char *. For that though we have
// to actually parse the encoding and build up the metaabi frame, so we can
// know where the information is.
//
// The perform_context is already written for the case that the type _C_PTR
// sends callbacks for the pointed to type. THIS IS (0.24) NOT THE CASE.
// If it doesn't send callbacks but swallows the pointed to type, then we
// don't need a stack, and everything becomes much easier.
//

#ifndef _C_PTR_PARSE_SENDS_CALLBACKS
# define _C_PTR_PARSE_SENDS_CALLBACKS  0
#endif


struct perform_context
{
   SEL                      operation;
   void                     *start;
   void                     *sentinel;
   struct mulle_allocator   *allocator;

   ptrdiff_t                offset;

   unsigned int             skip;
#if _C_PTR_PARSE_SENDS_CALLBACKS
   char                     space[ 32];
   struct mulle__buffer     stack;
#endif
};


static inline void   _perform_context_init( struct perform_context *ctxt,
                                            SEL operation,
                                            void *start,
                                            void *sentinel,
                                            struct mulle_allocator *allocator)
{
   assert( start);

   memset( ctxt, 0, sizeof( *ctxt));

   ctxt->operation = operation;
   ctxt->start     = start;
   ctxt->sentinel  = sentinel;
   ctxt->allocator = allocator;
#if _C_PTR_PARSE_SENDS_CALLBACKS
   _mulle__buffer_init_with_static_bytes( &ctxt->stack, ctxt->space, sizeof( ctxt->space));
#endif
}


static inline void   _perform_context_done( struct perform_context *ctxt)
{
#if _C_PTR_PARSE_SENDS_CALLBACKS
   _mulle__buffer_done( &ctxt->stack, ctxt->allocator);
#endif
}


static void   perform_context_operation( struct perform_context *ctxt, int type_c)
{
   id    *obj_p;
   char  **s_p;

   switch( type_c)
   {
   case _C_RETAIN_ID :
      obj_p = (id *) &((char *) ctxt->start)[ ctxt->offset];
      [*obj_p performSelector:ctxt->operation];
      break;

   case _C_COPY_ID :
      obj_p = (id *) &((char *) ctxt->start)[ ctxt->offset];
      if( @selector( retain) == ctxt->operation)
         *obj_p = [(id <NSCopying>) *obj_p copy];
      else
         [*obj_p performSelector:ctxt->operation];
      break;

   case _C_CHARPTR :
      s_p = (char **) &((char *) ctxt->start)[ ctxt->offset];
      if( @selector( retain) == ctxt->operation)
         *s_p = mulle_allocator_strdup( ctxt->allocator, *s_p);
      else
         if( @selector( release) == ctxt->operation)
            mulle_allocator_free( ctxt->allocator, *s_p);
      break;
   }
}



static inline void   _perform_context_push( struct perform_context *ctxt, int c)
{
#if _C_PTR_PARSE_SENDS_CALLBACKS
   _mulle__buffer_add_byte( &ctxt->stack, c, ctxt->allocator);
#endif
}


static inline void   _perform_context_pop( struct perform_context *ctxt, int expect)
{
#if _C_PTR_PARSE_SENDS_CALLBACKS
   int  c;

   c = _mulle__buffer_pop_byte( &ctxt->stack, ctxt->allocator);
   assert( c == expect);

   // remove pointers
   while( _mulle__buffer_get_last_byte( &ctxt->stack) == _C_PTR)
   {
      --ctxt->skip;
      _mulle__buffer_pop_byte( &ctxt->stack, ctxt->allocator);
   }
#endif
}


static void   perform_context_callback( char *type,
                                        struct mulle_objc_typeinfo *info,
                                        void *userinfo)
{
   struct perform_context   *ctxt = userinfo;
   struct perform_context   inferior;
   uint32_t                 i;
   uint32_t                 n_members;
   char                     *inferior_type;
   int                      c;

   assert( type);

   c = *type;
   switch( c)
   {
   case _C_STRUCT_B :
      // need to remember this (for _C_PTR)
      _perform_context_push( ctxt, c);
      return;

   case _C_STRUCT_E :
      _perform_context_pop( ctxt, _C_STRUCT_B);
      return;

   case _C_UNION_B  :
      if( info->has_retainable_type)
         MulleObjCThrowInternalInconsistencyExceptionUTF8String( "You can't retain invocations with union arguments containing id or char *");
      // start union
      _perform_context_push( ctxt, c);
      ++ctxt->skip;
      break;

   case _C_UNION_E  :
      _perform_context_pop( ctxt, _C_UNION_B);
      ctxt->skip--;
      break;

   case _C_ARY_B    :
      // start array
      _perform_context_push( ctxt, c);
      ++ctxt->skip;
      break;

   case _C_ARY_E    :
      _perform_context_pop( ctxt, _C_ARY_B);

      if( ! --ctxt->skip && info->has_retainable_type)
      {
         // do something clever
         //
         // now, we loop over the member again, and do the callbacks for real
         //
         n_members     = info->n_members;
         inferior_type = info->member_type_start;

         _perform_context_init( &inferior,
                                ctxt->operation,
                                ctxt->start,
                                ctxt->sentinel,
                                ctxt->allocator);
         inferior.offset = ctxt->offset;

         // we do the calculation now so we can reuse info in the loop
         ctxt->offset = (int32_t) mulle_address_align( ctxt->offset, info->bits_struct_alignment / 8);
         ctxt->offset += info->natural_size;

         for( i = 0; i < n_members; i++)
         {
            // just do the same type over and over again
            _mulle_objc_type_parse( inferior_type,
                                    0,
                                    info,
                                    _mulle_objc_signature_supply_scalar_typeinfo,
                                    perform_context_callback,
                                    &inferior);
         }
         _perform_context_done( &inferior);
      }
      return;

#if _C_PTR_PARSE_SENDS_CALLBACKS
   case _C_PTR :
      // we ignore the next type wholesale
      _perform_context_push( ctxt, c);
      ++ctxt->skip;
      return;

   default :
      if( _mulle__buffer_get_last_byte( &ctxt->stack) == _C_PTR)
      {
         _perform_context_pop( ctxt, _C_PTR);
         --ctxt->skip;
      }
      break;
#endif
   }

   if( ! ctxt->skip)
   {
      ctxt->offset = (int32_t) mulle_address_align( ctxt->offset, info->bits_struct_alignment / 8);

      if( info->has_retainable_type)
      {
         perform_context_operation( ctxt, c);
      }

      ctxt->offset += info->natural_size;
   }
}


- (void) _performArgumentMemberOperation:(SEL) sel
                       signatureTypeInfo:(MulleObjCMethodSignatureTypeInfo *) info
                                   bytes:(void *) start
                                  length:(size_t) length
{
   struct perform_context       ctxt;
   struct mulle_objc_typeinfo   type_info;

   assert( start);

   _perform_context_init( &ctxt,
                          sel,
                          start,
                          &((char *) start)[ length],
                          MulleObjCInstanceGetAllocator( self));

   //
   // this function will walk through the complete type and issue callbacks
   // for arrays we will have to run inferior type parsers...
   //
   _mulle_objc_type_parse( info->type,
                           0,
                           &type_info,
                           _mulle_objc_signature_supply_scalar_typeinfo,
                           perform_context_callback,
                           &ctxt);

   _perform_context_done( &ctxt);
}


- (void) _performArgumentMemberOperation:(SEL) sel
                       signatureTypeInfo:(MulleObjCMethodSignatureTypeInfo *) info
                                 atIndex:(NSUInteger) i
{
   void     *adr;
   size_t   size;

   pointerAndSizeOfArgumentValue( self, i + 1, &adr, &size);
   [self _performArgumentMemberOperation:sel
                       signatureTypeInfo:info
                                   bytes:adr
                                  length:size];

}


- (void) _performReturnMemberOperation:(SEL) sel
                     signatureTypeInfo:(MulleObjCMethodSignatureTypeInfo *) info
{
   void     *adr;
   size_t   size;

   pointerAndSizeOfArgumentValue( self, 0, &adr, &size);
   [self _performArgumentMemberOperation:sel
                       signatureTypeInfo:info
                                   bytes:adr
                                  length:size];
}

@end

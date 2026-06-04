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


@interface NSMethodSignature( NSInvocation)
@end


@implementation NSMethodSignature( NSInvocation)

static void  NSInvocationSetReturnValue( NSInvocation *self, void *value_p);   // forward

// changes order of arguments to "effortlessly" use this in NSInvocation
MULLE_C_ALWAYS_INLINE
MULLE_C_NONNULL_FIRST_THIRD_FOURTH
void  __NSInvocationInvokeWithTargetAndMessageSignature( NSInvocation *invocation,
                                                         SEL sel,
                                                         id target,
                                                         NSMethodSignature *self,
                                                         char *storage)
{
   MulleObjCMethodSignatureTypeInfo   *infos;
   void                               *param;
   void                               *rval;
   unsigned int                        callType;

   infos    = self->_infos;
   callType = _mulle_objc_method_bits_get_metaabi_calltype( self->_bits);

   switch( callType)
   {
   case MulleObjCMetaABICallVoidPtrVoidPtr:   // -(id)foo:(id)
      rval = mulle_objc_object_call_inline_variable( target, sel,
                                                     *(void **) &storage[ infos[ 3].invocation_offset]);
      NSInvocationSetReturnValue( invocation, &rval);
      break;

   case MulleObjCMetaABICallVoidPtrVoid:      // -(void)foo:(id)
      mulle_objc_object_call_inline_variable( target, sel,
                                              *(void **) &storage[ infos[ 3].invocation_offset]);
      break;

   case MulleObjCMetaABICallVoidVoidPtr:      // -(id)foo
      rval = mulle_objc_object_call_inline_variable( target, sel, target);
      NSInvocationSetReturnValue( invocation, &rval);
      break;

   case MulleObjCMetaABICallVoidVoid:         // -(void)foo
      mulle_objc_object_call_inline_variable( target, sel, target);
      break;

   default:   // ParameterBlock pType — use _infos for correct offsets
      switch( callType)
      {
      case MulleObjCMetaABICallBlockVoidPtr:  // -(id)foo:(int)x ...
         param = &storage[ infos[ 3].invocation_offset];
         rval  = mulle_objc_object_call_inline_variable( target, sel, param);
         NSInvocationSetReturnValue( invocation, &rval);
         break;
      case MulleObjCMetaABICallBlockVoid:     // -(void)foo:(int)x ...
         param = &storage[ infos[ 3].invocation_offset];
         mulle_objc_object_call_inline_variable( target, sel, param);
         break;
      case MulleObjCMetaABICallVoidPtrBlock:  // -(struct S)foo:(id)
         param = &storage[ infos[ 3].invocation_offset];
         rval  = mulle_objc_object_call_inline_variable( target, sel, param);
         NSInvocationSetReturnValue( invocation, param);
         break;
      case MulleObjCMetaABICallVoidBlock:     // -(struct S)foo
         param = storage;
         mulle_objc_object_call_inline_variable( target, sel, param);
         NSInvocationSetReturnValue( invocation, param);
         break;
      case MulleObjCMetaABICallBlockBlock:    // -(struct S)foo:(int)x ...
         param = &storage[ infos[ 3].invocation_offset];
         mulle_objc_object_call_inline_variable( target, sel, param);
         NSInvocationSetReturnValue( invocation, param);
         break;
      }
      break;
   }
}

static inline void
   _NSMethodSignatureSetMetaABIFrame( NSMethodSignature *sig,
                                      char *storage,
                                      void *frame)
{
   MulleObjCMethodSignatureTypeInfo   *infos;
   void                               *param;
   size_t                             size;
   unsigned int                        callType;

   infos    = sig->_infos;
   callType = _mulle_objc_method_bits_get_metaabi_calltype( sig->_bits);

   switch( callType)
   {
   case MulleObjCMetaABICallVoidPtrVoidPtr:  // -(id)foo:(id)
   case MulleObjCMetaABICallVoidPtrVoid:     // -(void)foo:(id)
      // frame is the single pointer argument itself
      param = &storage[ infos[ 3].invocation_offset];
      *((void **) param) = frame;
      break;

   case MulleObjCMetaABICallVoidVoidPtr:     // -(id)foo
   case MulleObjCMetaABICallVoidVoid:        // -(void)foo
      // no parameters to copy
      break;

   case MulleObjCMetaABICallVoidPtrBlock:    // -(struct S)foo:(id)
   case MulleObjCMetaABICallVoidBlock:       // -(struct S)foo
      // frame points to the rval/param union; for VoidPtrBlock the single
      // pointer arg is at frame[0].
      if( callType == MulleObjCMetaABICallVoidPtrBlock)
      {
         param = &storage[ infos[ 3].invocation_offset];
         *((void **) param) = *(void **) frame;
      }
      break;

   case MulleObjCMetaABICallBlockVoidPtr:    // -(id)foo:(int)x ...
   case MulleObjCMetaABICallBlockVoid:       // -(void)foo:(int)x ...
   case MulleObjCMetaABICallBlockBlock:      // -(struct S)foo:(int)x ...
      // frame points to the parameter block
      assert( frame);
      param = &storage[ infos[ 3].invocation_offset];
      size  = mulle_metaabi_sizeof_union( infos[ sig->_count - 1].invocation_offset
                                        + infos[ sig->_count - 1].natural_size);
      size -= sizeof( id) + sizeof( SEL);
      memcpy( param, frame, size);
      break;
   }
}


static inline void
   __NSInvocationCallIMP( NSInvocation *invocation,
                          IMP imp,
                          SEL sel,
                          id target,
                          NSMethodSignature *self,
                          char *storage)
{
   MulleObjCMethodSignatureTypeInfo   *infos;
   void                               *param;
   void                               *rval;
   unsigned int                        callType;

   infos    = self->_infos;
   callType = _mulle_objc_method_bits_get_metaabi_calltype( self->_bits);

   switch( callType)
   {
   case MulleObjCMetaABICallVoidPtrVoidPtr:
   case MulleObjCMetaABICallVoidPtrVoid:
      param = *(void **) &storage[ infos[ 3].invocation_offset];
      break;
   case MulleObjCMetaABICallVoidVoidPtr:
   case MulleObjCMetaABICallVoidVoid:
      param = target;
      break;
   default:
      param = &storage[ infos[ 3].invocation_offset];
      break;
   }

   rval = (*imp)( target, sel, param);

   switch( callType)
   {
   case MulleObjCMetaABICallVoidPtrVoidPtr:
   case MulleObjCMetaABICallVoidVoidPtr:
   case MulleObjCMetaABICallBlockVoidPtr:
      NSInvocationSetReturnValue( invocation, &rval);
      break;
   case MulleObjCMetaABICallVoidPtrBlock:
   case MulleObjCMetaABICallVoidBlock:
   case MulleObjCMetaABICallBlockBlock:
      NSInvocationSetReturnValue( invocation, param);
      break;
   default:
      break;  // void return — nothing to store
   }
}


@end
//
// what is somewhat tricky in the MetaABI is, that we need to store the
// parameter block properly aligned. We'd like to index directly into
// the invocation to get the block. For this we ensure (or rather
// NSMethodSignature) that "self" + "_cmd" are both pointersize.
// So if we "long double" align the whole thing we assume we are fine.
//

@interface NSInvocation( Forward)

- (void) _performArgumentMemberOperation:(SEL) sel
                            withArgument:(void *) argument
                       signatureTypeInfo:(MulleObjCMethodSignatureTypeInfo *) info
                                 atIndex:(NSUInteger) i;

- (void) _performReturnMemberOperation:(SEL) sel
                          withArgument:(void *) argument
                     signatureTypeInfo:(MulleObjCMethodSignatureTypeInfo *) info;

@end


@implementation NSInvocation( MulleBasicAccessors)


static int   is_valid_frame_range( NSInvocation *self, char *adr, size_t size)
{
   return( (adr >= self->_storage) && (&adr[ size] <= self->_sentinel));
}


void   NSMethodSignatureCopyDemotedValuesToNatural( NSMethodSignature *self,
                                                    NSInvocation *invocation,
                                                    mulle_vararg_list arguments)
{
   char                               *adr;
   char                               *sig_types;
   void                               *src;
   MulleObjCMethodSignatureTypeInfo   *info;
   NSUInteger                         i, n;
   NSUInteger                         size;
   char                               *storage;

   //
   // The incoming metaABI block is made up of mulle-vararg promoted values
   // so we can not just memcpy them into the invocation metaABI block
   //
   storage   = invocation->_storage;
   sig_types = [self _objCTypes];
   n         = [self numberOfArguments];
   for( i = 2; i < n; ++i)
   {
      // use internal index for mulleSignatureTypeInfoAtIndex!
      info = [self mulleSignatureTypeInfoAtIndex:i + 1];
      adr  = &storage[ info->invocation_offset];
      size = info->natural_size;

      if( ! is_valid_frame_range( invocation, adr, size))
         __mulle_objc_universe_raise_invalidindex( NULL, i);

      src = _mulle_vararg_aligned_struct( &arguments, size, info->natural_alignment);
      _mulle_methodsignature_arginfo_demote_value_to_natural( info, sig_types, adr, src);
   }
}


static void   _pointerAndSizeOfArgumentValue( NSInvocation *self,
                                              NSUInteger i,
                                              void **p_adr,
                                              size_t *p_size,
                                              MulleObjCMethodSignatureTypeInfo *info)
{
   char     *adr;
   size_t   size;

   adr  = &((char *) self->_storage)[ info->invocation_offset];
   size = info->natural_size;

   if( ! is_valid_frame_range( self, adr, size))
      MulleObjCThrowInvalidIndexException( i);

   *p_adr  = adr;
   *p_size = size;
}


static void   pointerAndSizeOfArgumentValue( NSInvocation *self,
                                             NSUInteger i,
                                             void **p_adr,
                                             size_t *p_size)
{
   MulleObjCMethodSignatureTypeInfo   *info;

   if( ! self->_methodSignature)
      MulleObjCThrowInternalInconsistencyExceptionUTF8String( "methodSignature not found on target");
   info = [self->_methodSignature mulleSignatureTypeInfoAtIndex:i];
   _pointerAndSizeOfArgumentValue( self, i, p_adr, p_size, info);
}


static void   NSInvocationGetReturnValueWithInfo( NSInvocation *self,
                                                  void *value_p,
                                                  MulleObjCMethodSignatureTypeInfo *info)
{
   void     *adr;
   size_t   size;

   assert( value_p);

   _pointerAndSizeOfArgumentValue( self, 0, &adr, &size, info);
   memcpy( value_p, adr, size);
}


static void   NSInvocationGetReturnValue( NSInvocation *self, void *value_p)
{
   void     *adr;
   size_t   size;

   assert( value_p);

   pointerAndSizeOfArgumentValue( self, 0, &adr, &size);
   memcpy( value_p, adr, size);
}


- (void) getReturnValue:(void *) value_p
{
   NSInvocationGetReturnValue( self, value_p);
}


static void   NSInvocationSetReturnValueWithInfo( NSInvocation *self,
                                                  void *value_p,
                                                  MulleObjCMethodSignatureTypeInfo *info)
{
   void     *adr;
   size_t   size;

   assert( value_p);

   _pointerAndSizeOfArgumentValue( self, 0, &adr, &size, info);
   memcpy( adr, value_p, size);
}


static void   NSInvocationSetReturnValue( NSInvocation *self, void *value_p)
{
   void     *adr;
   size_t   size;

   assert( value_p);

   pointerAndSizeOfArgumentValue( self, 0, &adr, &size);
   memcpy( adr, value_p, size);
}



- (void) setReturnValue:(void *) value_p
{
   NSInvocationSetReturnValue( self, value_p);
}


static void   NSInvocationGetArgumentAtIndexWithInfo( NSInvocation *self,
                                                      void *value_p,
                                                      NSUInteger i,
                                                      MulleObjCMethodSignatureTypeInfo *info)
{
   void     *adr;
   size_t   size;

   assert( value_p);

   _pointerAndSizeOfArgumentValue( self, i + 1, &adr, &size, info);
   memcpy( value_p, adr, size);
}


static void   NSInvocationGetArgumentAtIndex( NSInvocation *self,
                                              void *value_p,
                                              NSUInteger i)
{
   void     *adr;
   size_t   size;

   assert( value_p);

   pointerAndSizeOfArgumentValue( self, i + 1, &adr, &size);
   memcpy( value_p, adr, size);
}


- (void) getArgument:(void *) value_p
             atIndex:(NSUInteger) i
{
   NSInvocationGetArgumentAtIndex( self, value_p, i);
}


static void   NSInvocationSetArgumentAtIndexWithInfo( NSInvocation *self,
                                                      void *value_p,
                                                      NSUInteger i,
                                                      MulleObjCMethodSignatureTypeInfo *info)
{
   void     *adr;
   size_t   size;

   assert( value_p);

   _pointerAndSizeOfArgumentValue( self, i + 1, &adr, &size, info);
   memcpy( adr, value_p, size);
}


static void   NSInvocationSetArgumentAtIndex( NSInvocation *self,
                                              void *value_p,
                                              NSUInteger i)
{
   void     *adr;
   size_t   size;

   assert( value_p);

   pointerAndSizeOfArgumentValue( self, i + 1, &adr, &size);
   memcpy( adr, value_p, size);
}


- (void) setArgument:(void *) value_p
             atIndex:(NSUInteger) i
{
   NSInvocationSetArgumentAtIndex( self, value_p, i);
}


static inline void   NSInvocationSetTarget( NSInvocation *self, id target)
{
   NSInvocationSetArgumentAtIndex( self, &target, 0);
}


static inline id   NSInvocationGetTarget( NSInvocation *self)
{
   id   target;

   NSInvocationGetArgumentAtIndex( self, &target, 0);
   return( target);
}


static inline void   NSInvocationSetSelector( NSInvocation *self, SEL sel)
{
   NSInvocationSetArgumentAtIndex( self, &sel, 1);
}


static inline SEL   NSInvocationGetSelector( NSInvocation *self)
{
   SEL   sel;

   MULLE_C_ASSERT( sizeof( SEL) == sizeof( mulle_objc_methodid_t));

   NSInvocationGetArgumentAtIndex( self, &sel, 1);
   return( sel);
}



- (SEL) selector
{
   return( NSInvocationGetSelector( self));
}


- (void) setSelector:(SEL) selector
{
   NSInvocationSetArgumentAtIndex( self, &selector, 1);
}



- (id) target
{
   return( NSInvocationGetTarget( self));
}


- (void) setTarget:(id) target
{
   NSInvocationSetTarget( self, target);
}


static void   NSInvocationMakeObjectArgumentsPerformSelector( NSInvocation *self,
                                                              SEL sel,
                                                              void *argument)
{
   NSInteger                          i, n;
   id                                 obj;
   MulleObjCMethodSignatureTypeInfo   *info;
   char                               *sig_types;

   // first do return value
   info = [self->_methodSignature mulleSignatureTypeInfoAtIndex:0];
   // can happen, if we just have an empty invocation
   if( ! info)
      return;

   sig_types = [self->_methodSignature _objCTypes];
   switch( sig_types[ info->type_offset])
   {
   case _C_ARY_B     :
   case _C_STRUCT_B  :
   case _C_UNION_B   :
      if( info->has_retainable_type)
         [self _performReturnMemberOperation:sel
                                withArgument:argument
                           signatureTypeInfo:info];
      break;

   case _C_CLASS     :
   case _C_ASSIGN_ID :
   case _C_RETAIN_ID :
   case _C_COPY_ID   :
      NSInvocationGetReturnValue( self, &obj);
      [obj performSelector:sel
                withObject:(id) argument];
   }

   //  now do arguments value
   n = [self->_methodSignature numberOfArguments];
   for( i = 0; i < n; ++i)
   {
      info = [self->_methodSignature mulleSignatureTypeInfoAtIndex:i + 1];
      switch( sig_types[ info->type_offset])
      {
      case _C_ARY_B     :
      case _C_STRUCT_B  :
      case _C_UNION_B   :
         if( info->has_retainable_type)
            [self _performArgumentMemberOperation:sel
                                     withArgument:argument
                                signatureTypeInfo:info
                                          atIndex:i];
         break;
      case _C_CLASS     :
      case _C_ASSIGN_ID :
      case _C_COPY_ID   :
      case _C_RETAIN_ID :
         NSInvocationGetArgumentAtIndexWithInfo( self, &obj, i, info);
         [obj performSelector:sel
                   withObject:(id) argument];
         break;
      }
   }
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
   char                               *sig_types;

   if( _argumentsRetained)
      return;

   if( [_methodSignature isVariadic])
      MulleObjCThrowInternalInconsistencyExceptionUTF8String( "NSInvocation can not \
retain the arguments of variadic methods");

   _argumentsRetained = YES;

   sig_types = [_methodSignature _objCTypes];
   n = [_methodSignature numberOfArguments];
   for( i = 0; i < n; ++i)
   {
      info = [_methodSignature mulleSignatureTypeInfoAtIndex:i + 1];
      switch( sig_types[ info->type_offset])
      {
      case _C_ARY_B     :
      case _C_STRUCT_B  :
      case _C_UNION_B   :
         if( info->has_retainable_type)
            [self _performArgumentMemberOperation:@selector( retain)
                                     withArgument:self
                                signatureTypeInfo:info
                                          atIndex:i];
         break;

      case _C_RETAIN_ID :
         NSInvocationGetArgumentAtIndexWithInfo( self, &obj, i, info);
         // assert( [obj mulleIsAccessible]);  // can't do this !
         [obj retain];
         break;

      case _C_COPY_ID :
         NSInvocationGetArgumentAtIndexWithInfo( self, &obj, i, info);
         obj = [(id <NSCopying>) obj copy];
         NSInvocationSetArgumentAtIndexWithInfo( self, &obj, i, info);
         break;

      case _C_CHARPTR :
         NSInvocationGetArgumentAtIndexWithInfo( self, &s, i, info);
         dup  = mulle_allocator_strdup( MulleObjCInstanceGetAllocator( self), s);
         [self setArgument:&dup
                  atIndex:i];
         break;
      }
   }
}


- (void) mulleRetainReturnValue
{
   id                                 obj;
   char                               *s;
   char                               *dup;
   MulleObjCMethodSignatureTypeInfo   *info;
   char                               *sig_types;

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

   sig_types = [_methodSignature _objCTypes];
   switch( sig_types[ info->type_offset])
   {
   case _C_ARY_B     :
   case _C_STRUCT_B  :
   case _C_UNION_B   :
      if( info->has_retainable_type)
         [self _performReturnMemberOperation:@selector( retain)
                                withArgument:self
                           signatureTypeInfo:info];
      break;

   case _C_RETAIN_ID :
      NSInvocationGetReturnValueWithInfo( self, &obj, info);
      [obj retain];
      break;

   case _C_COPY_ID :
      NSInvocationGetReturnValueWithInfo( self, &obj, info);
      obj = [(id <NSCopying>) obj copy];
      NSInvocationSetReturnValueWithInfo( self, &obj, info);
      break;

   case _C_CHARPTR :
      NSInvocationGetReturnValueWithInfo( self, &s, info);
      dup  = mulle_allocator_strdup( MulleObjCInstanceGetAllocator( self), s);
      [self setReturnValue:&dup];
      break;
   }
}

@end


@implementation NSInvocation

- (IMP) implementation
{
   return( _implementation);
}


- (void) setImplementation:(IMP) imp
{
   _implementation = imp;
}


+ (NSInvocation *) mulleInvocationWithTarget:(id) target
                                    selector:(SEL) sel
                              implementation:(IMP) imp
                                      object:(id) object
{
   NSInvocation        *invocation;

   invocation = [self mulleInvocationWithTarget:target
                                       selector:sel
                                         object:object];
   if( ! invocation)
      return( nil);

   invocation->_implementation = imp;
   return( invocation);
}

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

   _mulle_objc_objectheader_set_thread_id( header, mulle_thread_id());
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


#ifdef DEBUG
- (void) release
{
   [super release];
}

- (instancetype) retain
{
   return( [super retain]);
}

- (instancetype) autorelease
{
   return( [super autorelease]);
}
#endif


/**
 **
 **/
+ (NSInvocation *) invocationWithMethodSignature:(NSMethodSignature *) signature
{
   NSUInteger                      size;
   NSInvocation                    *invocation;
   void                            *extraBytes;
   struct _mulle_objc_infraclass   *cls;

   // MEMO: do not raise during construction of objects
//   if( ! signature)
//      return( nil);

//   frame_size  = [signature frameLength];
//   size        = mulle_metaabi_sizeof_union( frame_size);
//   size       += [signature methodReturnLength];
//   size       += alignof( double);  // for alignment

   invocation = nil;
   size = [signature mulleInvocationSize];

   // if size is zero, this is a variadic method signature and we can't
   // do an invocation
   if( ! size)
      return( invocation);

   // if size is smaller than what we allocate as standard size adjust up
   // to standard size
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
   invocation->_storage         = mulle_pointer_align( extraBytes, alignof( double));
   invocation->_sentinel        = &((char *) invocation->_storage)[ size];
   invocation->_methodSignature = [signature retain];
   invocation->_implementation  = 0;

   return( [invocation autorelease]);
}



NSInvocation  *NSInvocationCreateV( NSMethodSignature *signature,
                                    id target,
                                    SEL sel,
                                    mulle_vararg_list arguments)
{
   NSInvocation   *invocation;

   invocation = [NSInvocation invocationWithMethodSignature:signature];
   if( ! invocation)
      return( nil);

   NSInvocationSetTarget( invocation, target);
   NSInvocationSetSelector( invocation, sel);

   //
   // The incoming metaABI block is made up of mulle-vararg promoted values
   // so we can not just memcpy them into the invocation metaABI block
   //
   NSMethodSignatureCopyDemotedValuesToNatural( signature, invocation, arguments);
   return( invocation);
}


NSInvocation  *NSInvocationCreate( id target,
                                   SEL sel,
                                   NSMethodSignature *signature,
                                   mulle_vararg_list arguments)
{
   return( NSInvocationCreateV( signature, target, sel, arguments));
}


// @mulle-objc@ @invocation >
// Called by compiler-generated @invocation expressions.
// sig is a precomputed @signature static instance (no runtime lookup needed).
// frame is the MetaABI frame built by the compiler on the stack (NULL for Void pType).
// No argument retention — caller is responsible.
NSInvocation  *NSInvocationCreateWithMetaABIFrame( NSMethodSignature *sig,
                                                   id target,
                                                   SEL sel,
                                                   void *frame,
                                                   IMP imp)
{
   NSInvocation   *invocation;

   invocation = [NSInvocation invocationWithMethodSignature:sig];
   if( ! invocation)
      return( nil);

   NSInvocationSetTarget( invocation, target);
   NSInvocationSetSelector( invocation, sel);
   if( frame)
      [invocation _setMetaABIFrame:frame];
   invocation->_implementation = imp;

   return( invocation);
}
// @mulle-objc@ @invocation <


+ (NSInvocation *) mulleInvocationWithTarget:(id) target
                                    selector:(SEL) sel, ...

{
   NSMethodSignature   *signature;
   mulle_vararg_list    arguments;
   NSInvocation        *inv;

   signature  = [target methodSignatureForSelector:sel];

   mulle_vararg_start( arguments, sel);
   inv = NSInvocationCreateV( signature, target, sel, arguments);
   mulle_vararg_end( arguments);
   return( inv);
}


// @mulle-objc@ @invocation >
+ (NSInvocation *) mulleInvocationWithTarget:(id) target
                                    selector:(SEL) sel
                             methodSignature:(NSMethodSignature *) sig, ...
{
   mulle_vararg_list   arguments;
   NSInvocation        *inv;

   if( ! sel)
      return( nil);

   if( ! sig)
      sig = [target methodSignatureForSelector:sel];

   mulle_vararg_start( arguments, sig);
   inv = NSInvocationCreateV( sig, target, sel, arguments);
   mulle_vararg_end( arguments);
   return( inv);
}
// @mulle-objc@ @invocation <


+ (NSInvocation *) mulleInvocationWithTarget:(id) target
                                    selector:(SEL) sel
                                      object:(id) object
{
   NSInvocation        *invocation;
   NSMethodSignature   *signature;

   signature  = [target methodSignatureForSelector:sel];

   invocation = [self invocationWithMethodSignature:signature];
   if( ! invocation)
      return( nil);

   NSInvocationSetTarget( invocation, target);
   NSInvocationSetSelector( invocation, sel);
   NSInvocationSetArgumentAtIndex( invocation, &object, 2);

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
   MulleObjCMethodSignatureTypeInfo   *info;
#endif
   signature  = [target methodSignatureForSelector:sel];

   invocation = [self invocationWithMethodSignature:signature];
   if( ! invocation)
      return( nil);

   NSInvocationSetTarget( invocation, target);
   NSInvocationSetSelector( invocation, sel);
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
      info   = [signature mulleSignatureTypeInfoAtIndex:2 + 1];
      adr    = &((char *) invocation->_storage)[ info->invocation_offset];
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
   // we dont have ivars we want to release now
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


- (NSMethodSignature *) methodSignature
{
   return( _methodSignature);
}


- (void) _releaseArguments
{
   NSInteger                          i, n;
   id                                 obj;
   char                               *s;
   MulleObjCMethodSignatureTypeInfo   *info;
   char                               *sig_types;

   sig_types = [_methodSignature _objCTypes];
   n = [_methodSignature numberOfArguments];
   for( i = 0; i < n; ++i)
   {
      // this indexes with 0: rval
      info = [_methodSignature mulleSignatureTypeInfoAtIndex:i + 1];
      switch( sig_types[ info->type_offset])
      {
      case _C_ARY_B     :
      case _C_STRUCT_B  :
      case _C_UNION_B   :
         if( info->has_retainable_type)
            [self _performArgumentMemberOperation:@selector( release)
                                     withArgument:self
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
   char                               *sig_types;

   info = [_methodSignature mulleSignatureTypeInfoAtIndex:0];
   // can happen, if we just have an empty invocation
   if( ! info)
      return;

   sig_types = [_methodSignature _objCTypes];
   switch( sig_types[ info->type_offset])
   {
   case _C_ARY_B     :
   case _C_STRUCT_B  :
   case _C_UNION_B   :
      if( info->has_retainable_type)
         [self _performReturnMemberOperation:@selector( release)
                                withArgument:self
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


- (void) mulleGainAccessWithUniquingSet:(struct mulle_pointerset *) uniquing
{
   MulleObjCTAOStrategy   strategy;

   assert( mulle_pointerset_get( uniquing, self) == self);

   strategy = [self mulleTAOStrategy];
   [self mulleGainAccessWithTAOStrategy:strategy];

   NSInvocationMakeObjectArgumentsPerformSelector( self,
                                                   @selector( mulleGainAccessWithUniquingSetIfAbsent:),
                                                   uniquing);
}


- (void) mulleRelinquishAccessWithUniquingSet:(struct mulle_pointerset *) uniquing
{
   MulleObjCTAOStrategy   strategy;

   assert( mulle_pointerset_get( uniquing, self) == self);

   NSInvocationMakeObjectArgumentsPerformSelector( self,
                                                   @selector( mulleRelinquishAccessWithUniquingSetIfAbsent:),
                                                   uniquing);

   strategy = [self mulleTAOStrategy];
   [self mulleRelinquishAccessWithTAOStrategy:strategy];
}


- (BOOL) argumentsRetained
{
   return( _argumentsRetained);
}


- (BOOL) mulleReturnValueRetained
{
   return( _returnValueRetained);
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


MULLE_C_NONNULL_FIRST
void  _NSInvocationInvokeWithTarget( NSInvocation *self, SEL _cmd, id target)
{
   SEL   sel;

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
   if( ! self->_methodSignature)
      MulleObjCThrowInternalInconsistencyExceptionUTF8String( "NSInvocation: methodSignature has not been set yet");

   if( self->_implementation)
   {
      __NSInvocationCallIMP( self, self->_implementation, sel, target, self->_methodSignature, self->_storage);
      return;
   }

   __NSInvocationInvokeWithTargetAndMessageSignature( self, sel, target, self->_methodSignature, self->_storage);
}


- (void) invokeWithTarget:(id) target
{
   _NSInvocationInvokeWithTarget( self, _cmd, target);
}



- (void) invoke
{
   id   target;

   target = [self target];
   _NSInvocationInvokeWithTarget( self, @selector( invokeWithTarget:), target);
}



- (void) _setMetaABIFrame:(void *) frame
{
   _NSMethodSignatureSetMetaABIFrame( _methodSignature, self->_storage, frame);
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
   void                     *argument;
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
                                            void *argument,
                                            void *start,
                                            void *sentinel,
                                            struct mulle_allocator *allocator)
{
   assert( start);

   memset( ctxt, 0, sizeof( *ctxt));

   ctxt->operation = operation;
   ctxt->argument  = argument;
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
      if( @selector( retain) == ctxt->operation)
         [*obj_p retain]; // optimizes nicely
      else
         [*obj_p performSelector:ctxt->operation
                      withObject:ctxt->argument];
      break;

   case _C_COPY_ID :
      obj_p = (id *) &((char *) ctxt->start)[ ctxt->offset];
      if( @selector( retain) == ctxt->operation)
         *obj_p = [(id <NSCopying>) *obj_p copy];
      else
         [*obj_p performSelector:ctxt->operation
                      withObject:ctxt->argument];
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
                                ctxt->argument,
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
                            withArgument:(void *) argument
                       signatureTypeInfo:(MulleObjCMethodSignatureTypeInfo *) info
                                   bytes:(void *) start
                                  length:(size_t) length
{
   struct perform_context       ctxt;
   struct mulle_objc_typeinfo   type_info;
   char                         *sig_types;

   assert( start);

   _perform_context_init( &ctxt,
                          sel,
                          argument,
                          start,
                          &((char *) start)[ length],
                          MulleObjCInstanceGetAllocator( self));

   //
   // this function will walk through the complete type and issue callbacks
   // for arrays we will have to run inferior type parsers...
   //
   sig_types = [self->_methodSignature _objCTypes];
   _mulle_objc_type_parse( &sig_types[ info->type_offset],
                           0,
                           &type_info,
                           _mulle_objc_signature_supply_scalar_typeinfo,
                           perform_context_callback,
                           &ctxt);

   _perform_context_done( &ctxt);
}


- (void) _performArgumentMemberOperation:(SEL) sel
                            withArgument:(void *) argument
                       signatureTypeInfo:(MulleObjCMethodSignatureTypeInfo *) info
                                 atIndex:(NSUInteger) i
{
   void     *adr;
   size_t   size;

   pointerAndSizeOfArgumentValue( self, i + 1, &adr, &size);
   [self _performArgumentMemberOperation:sel
                            withArgument:argument
                       signatureTypeInfo:info
                                   bytes:adr
                                  length:size];

}


- (void) _performReturnMemberOperation:(SEL) sel
                          withArgument:(void *) argument
                     signatureTypeInfo:(MulleObjCMethodSignatureTypeInfo *) info
{
   void     *adr;
   size_t   size;

   pointerAndSizeOfArgumentValue( self, 0, &adr, &size);
   [self _performArgumentMemberOperation:sel
                            withArgument:argument
                       signatureTypeInfo:info
                                   bytes:adr
                                  length:size];
}

@end


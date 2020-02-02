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
#import "MulleObjCExceptionHandler.h"
#import "MulleObjCExceptionHandler-Private.h"


#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"


@implementation NSInvocation

- (instancetype) initWithMethodSignature:(NSMethodSignature *) signature
{
   size_t                   size;
   struct mulle_allocator   *allocator;
   size_t                   s_voidptr5;
   size_t                   underflow;

   if( ! signature)
   {
      [self release];
      __mulle_objc_universe_raise_invalidargument( _mulle_objc_object_get_universe( self),
                                                 "signature is nil");
      return( nil);
   }

   size       = [signature frameLength];
   size      += [signature methodReturnLength];
   s_voidptr5 = sizeof( void *) * 5;
   underflow  = size % s_voidptr5;
   if( underflow)
      size  += s_voidptr5 - underflow;

   allocator = MulleObjCObjectGetAllocator( self);
   _storage  = mulle_allocator_calloc( allocator, 1, size);
   _sentinel = &((char *) _storage)[ size];

   _methodSignature = [signature retain];

   return( self);
}


- (void) _releaseArguments
{
   NSInteger   i, n;
   char        *type;
   id          obj;
   char        *s;

   n = [_methodSignature numberOfArguments];
   for( i = 0; i < n; ++i)
   {
      type = [_methodSignature getArgumentTypeAtIndex:i];
      switch( *type)
      {
      case _C_COPY_ID   :
      case _C_RETAIN_ID :
         [self getArgument:&obj
                  atIndex:i];
         [obj release];
         break;

      case _C_CHARPTR :
         [self getArgument:&s
                  atIndex:i];
         mulle_allocator_free( MulleObjCObjectGetAllocator( self), s);
         break;
      }
   }
}


- (void) finalize
{
}


- (void) dealloc
{
   struct mulle_allocator  *allocator;

   if( _argumentsRetained)
      [self _releaseArguments];

   allocator = MulleObjCObjectGetAllocator( self);
   mulle_allocator_free( allocator, _storage);
   [_methodSignature release];

   NSDeallocateObject( self);
}


+ (NSInvocation *) invocationWithMethodSignature:(NSMethodSignature *) signature
{
   return( [[[self alloc] initWithMethodSignature:signature] autorelease]);
}


- (NSMethodSignature *) methodSignature
{
   return( _methodSignature);
}


static int   NSInvocationIsFrameRangeValid( NSInvocation *self, char *adr, size_t size)
{
   return( (adr >= self->_storage) && (&adr[ size] <= self->_sentinel));
}


static inline void   pointerAndSizeOfArgumentValue( NSInvocation *self, NSUInteger i, void **p_adr, size_t *p_size)
{
   MulleObjCMethodSignatureTypeinfo   *p;
   char      *adr;
   size_t    size;

   p    = [self->_methodSignature _runtimeTypeInfoAtIndex:i];
   adr  = &((char *) self->_storage)[ p->offset];
   size = p->natural_size;

   if( ! NSInvocationIsFrameRangeValid( self, adr, size))
      __mulle_objc_universe_raise_invalidindex( NULL, i);

   *p_adr  = adr;
   *p_size = size;
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


- (void) retainArguments
{
   NSInteger   i, n;
   char        *type;
   id          obj;
   char        *s;
   char        *dup;

   if( _argumentsRetained)
   {
#if DEBUG
      abort();
#endif
      return;
   }

   if( [_methodSignature isVariadic])
      __mulle_objc_universe_raise_internalinconsistency( _mulle_objc_object_get_universe( self),
                                                       "NSInvocation can not retain the arguments of variadic methods");

   _argumentsRetained = YES;

   n = [_methodSignature numberOfArguments];
   for( i = 0; i < n; ++i)
   {
      type = [_methodSignature getArgumentTypeAtIndex:i];
      switch( *type)
      {
      case _C_RETAIN_ID :
         [self getArgument:&obj
                  atIndex:i];
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
         dup  = mulle_allocator_strdup( MulleObjCObjectGetAllocator( self), s);
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


- (SEL) selector
{
   SEL   result;

   assert( sizeof( SEL) == sizeof( mulle_objc_methodid_t));

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


- (void) invokeWithTarget:(id) target
{
   SEL                                sel;
   MulleObjCMethodSignatureTypeinfo   *info;
   void                               *param;
   void                               *rval;
   MulleObjCMetaABIType               pType;
   MulleObjCMetaABIType               rType;

   sel = [self selector];
   if( ! sel)
      __mulle_objc_universe_raise_internalinconsistency( _mulle_objc_object_get_universe( self),
                                                      "NSInvocation: selector has not been set yet");

   pType = [_methodSignature _methodMetaABIParameterType];
   rType = [_methodSignature _methodMetaABIReturnType];

   param = NULL;
   switch( pType)
   {
   case MulleObjCMetaABITypeVoid           :
      if( rType == MulleObjCMetaABITypeParameterBlock)
      {
         info  = [self->_methodSignature _runtimeTypeInfoAtIndex:0];
         param = &self->_storage[ info->offset];
         rval  = mulle_objc_object_inlinecall_variablemethodid( target, sel, param);
         break;
      }

      rval = mulle_objc_object_inlinecall_variablemethodid( target, sel, target);
      break;

   case MulleObjCMetaABITypeVoidPointer    :
      info  = [self->_methodSignature _runtimeTypeInfoAtIndex:3];
      param = &self->_storage[ info->offset];
      rval  = mulle_objc_object_inlinecall_variablemethodid( target, sel, *(void **) param);
      break;

   case MulleObjCMetaABITypeParameterBlock :
      info  = [self->_methodSignature _runtimeTypeInfoAtIndex:3];
      param = &self->_storage[ info->offset];
      rval  = mulle_objc_object_inlinecall_variablemethodid( target, sel, param);
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
   MulleObjCMethodSignatureTypeinfo   *info;
   void                               *param;
   size_t                             size;

   switch( [_methodSignature _methodMetaABIParameterType])
   {
   case MulleObjCMetaABITypeVoid           :
      break;

   case MulleObjCMetaABITypeVoidPointer    :
      // rval, self, _cmd, _param (3)
      info  = [self->_methodSignature _runtimeTypeInfoAtIndex:3];
      param = &((char *) self->_storage)[ info->offset];
      assert( NSInvocationIsFrameRangeValid( self, param, sizeof( void *)));

      *((void **) param) = frame;
      break;

   case MulleObjCMetaABITypeParameterBlock :
      // rval, self, _cmd, _param (3)
      info  = [self->_methodSignature _runtimeTypeInfoAtIndex:3];
      param = &((char *) self->_storage)[ info->offset];
      size  = info->natural_size;
      assert( NSInvocationIsFrameRangeValid( self, param, size));

      if( frame)
         memcpy( param, frame, size);
      break;
   }
}

@end

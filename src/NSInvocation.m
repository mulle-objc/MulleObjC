/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSInvocation.m is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSInvocation.h"

#import "NSMethodSignature.h"
#import "NSMethodSignature+Private.h"
#import "MulleObjCAllocation.h"
#import "NSAutoreleasePool.h"
#import "NSCopying.h"


@implementation NSInvocation

- (id) initWithMethodSignature:(NSMethodSignature *) signature
{
   size_t                   size;
   struct mulle_allocator   *allocator;
   
   if( ! signature)
   {
      [self release];
      mulle_objc_throw_invalid_argument_exception( "signature is nil");
      return( nil);
   }

   size             = [signature frameLength];
   size            += [signature methodReturnLength];
   
   allocator        = MulleObjCObjectGetAllocator( self);
   _storage         = mulle_allocator_calloc( allocator, 1, size);
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


static inline void   pointerAndSizeOfArgumentValue( NSInvocation *self, NSUInteger i, void **adr, size_t *size)
{
   MulleObjCMethodSignatureTypeinfo   *p;
   
   p     = [self->_methodSignature _runtimeTypeInfoAtIndex:i];
   *adr  = &((char *) self->_storage)[ p->offset];
   *size = p->natural_size;
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
      MulleObjCThrowInternalInconsistencyException( @"NSInvocation can not retain the arguments of variadic methods");
   
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
   void                               *storage;
   
   sel = [self selector];
   if( ! sel)
      MulleObjCThrowInternalInconsistencyException( @"selector has not been set yet");
   
   param = NULL;
   switch( [_methodSignature methodMetaABIParameterType])
   {
   case MulleObjCMetaABITypeVoid           :
      rval = mulle_objc_object_inline_variable_methodid_call( target, sel, target);
      break;
         
   case MulleObjCMetaABITypeVoidPointer    :
      info  = [self->_methodSignature _runtimeTypeInfoAtIndex:3];
      param = &((char *) self->_storage)[ info->offset];
      rval  = mulle_objc_object_inline_variable_methodid_call( target, sel, *(void **) param);
      break;
         
   case MulleObjCMetaABITypeParameterBlock :
      info  = [self->_methodSignature _runtimeTypeInfoAtIndex:3];
      param = &((char *) self->_storage)[ info->offset];
      rval  = mulle_objc_object_inline_variable_methodid_call( target, sel, param);
      break;
   }

   switch( [_methodSignature methodMetaABIReturnType])
   {
   case MulleObjCMetaABITypeVoid           :
      break;
      
   case MulleObjCMetaABITypeVoidPointer    :
      info    = [self->_methodSignature _runtimeTypeInfoAtIndex:0];
      storage = &((char *) self->_storage)[ info->offset];
      *(void **) storage = rval;
      break;
      
   case MulleObjCMetaABITypeParameterBlock :
      assert( param);
      info    = [self->_methodSignature _runtimeTypeInfoAtIndex:0];
      storage = &((char *) self->_storage)[ info->offset];
      memcpy( storage, param, [self->_methodSignature methodReturnLength]);
      break;
   }
}


- (void) _setMetaABIFrame:(void *) frame
{
   MulleObjCMethodSignatureTypeinfo   *info;
   void                               *param;
   
   switch( [_methodSignature methodMetaABIParameterType])
   {
   case MulleObjCMetaABITypeVoid           :
      break;
      
   case MulleObjCMetaABITypeVoidPointer    :
      info  = [self->_methodSignature _runtimeTypeInfoAtIndex:3];
      param = &((char *) self->_storage)[ info->offset];
      *((void **) param) = frame;
      break;
      
   case MulleObjCMetaABITypeParameterBlock :
      info  = [self->_methodSignature _runtimeTypeInfoAtIndex:3];
      param = &((char *) self->_storage)[ info->offset];
      memcpy( param, frame, [_methodSignature frameLength]);
      break;
   }
}

@end


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
#import "NSAllocation.h"
#import "NSAutoreleasePool.h"


@implementation NSInvocation

- (id) initWithMethodSignature:(NSMethodSignature *) signature
{
   size_t   size;
   
   if( ! signature)
   {
      [self release];
      __NSThrowInvalidArgumentException( signature, "is nil");
      return( nil);
   }

   size             = [signature frameLength];
   size            += [signature methodReturnLength];
   
   _storage         = _NSAllocateNonZeroedMemory( size);
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
         _NSDeallocateMemory( s);
         break;
      }
   }
}

- (void) finalize
{
   if( _argumentsRetained)
      [self _releaseArguments];
   _NSFinalizeObject( self);
}


- (void) dealloc
{
   _NSDeallocateMemory( _storage);
   NSDeallocateObject( self);
}


+ (NSInvocation *) invocationWithMethodSignature:(NSMethodSignature *) signature
{
   return( NSAutoreleaseObject( [[self allocWithZone:NULL] initWithMethodSignature:signature]));
}


- (NSMethodSignature *) methodSignature
{
   return( _methodSignature);
}


static inline void   pointerAndSizeOfArgumentValue( NSInvocation *self, NSUInteger i, void **adr, size_t *size)
{
   _NSMethodSignatureTypeinfo   *p;
   
   p     = [self->_methodSignature _runtimeTypeInfoAtIndex:i];
   *adr  = &((char *) self->_storage)[ p->offset];
   *size = p->info.natural_size;
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
   
   pointerAndSizeOfArgumentValue( self, i + 1,  &adr, &size);
   memcpy( value_p, adr, size);
}


- (void) setArgument:(void *) value_p 
             atIndex:(NSUInteger) i
{
   void     *adr;
   size_t   size;

   assert( value_p);
      
   pointerAndSizeOfArgumentValue( self, i + 1,  &adr, &size);
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
         [obj copy];
         break;
            
      case _C_CHARPTR :
         [self getArgument:&s 
                  atIndex:i];
         dup  = _NSDuplicateCString( s);
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
   SEL                          sel;
   _NSMethodSignatureTypeinfo   *info;
   void                         *param;
   void                         *rval;
   
   sel   = [self selector];
   param = NULL;
   switch( [_methodSignature methodMetaABIParameterType])
   {
   case _NSMetaABITypeVoid           :
      rval = mulle_objc_object_inline_call( target, sel, target);
      break;
         
   case _NSMetaABITypeVoidPointer    :
      info  = [self->_methodSignature _runtimeTypeInfoAtIndex:0];
      param = &((char *) self->_storage)[ info->offset];
      rval  = mulle_objc_object_inline_call( target, sel, *(void **) param);
      break;
         
   case _NSMetaABITypeParameterBlock :
      info  = [self->_methodSignature _runtimeTypeInfoAtIndex:0];
      param = &((char *) self->_storage)[ info->offset];
      rval  = mulle_objc_object_inline_call( target, sel, param);
      break;
   }

   switch( [_methodSignature methodMetaABIReturnType])
   {
   case _NSMetaABITypeVoid           :
      break;
      
   case _NSMetaABITypeVoidPointer    :
      *(void **) _storage = rval;
      break;
      
   case _NSMetaABITypeParameterBlock :
      memcpy( _storage, param, [self->_methodSignature methodReturnLength]);
      break;
   }
}


- (void) setMetaABIFrame:(void *) frame
{
   _NSMethodSignatureTypeinfo   *info;
   void                         *param;
   
   switch( [_methodSignature methodMetaABIParameterType])
   {
   case _NSMetaABITypeVoid           :
      break;
      
   case _NSMetaABITypeVoidPointer    :
      info  = [self->_methodSignature _runtimeTypeInfoAtIndex:0];
      param = &((char *) self->_storage)[ info->offset];
      *((void **) param) = frame;
      break;
      
   case _NSMetaABITypeParameterBlock :
      info  = [self->_methodSignature _runtimeTypeInfoAtIndex:0];
      param = &((char *) self->_storage)[ info->offset];
      memcpy( param, frame, [_methodSignature frameLength]);
      break;
   }
}

@end


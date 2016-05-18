/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSMethodSignature.h is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSMethodSignature.h"

#import "NSAutoreleasePool.h"
#import "MulleObjCAllocation.h"


@implementation NSMethodSignature

- (id) initWithObjCTypes:(char *) types
{
   _count = mulle_objc_signature_count_typeinfos( types);
   if( _count < 3)  // rval, self, _cmd
   {
      [self release];
      return( nil);
   }

   _types = mulle_allocator_strdup( MulleObjCObjectGetAllocator( self), types);
   _bits  = 0;

   return( self);
}


- (id) _initWithObjCTypes:(char *) types
     methodDescriptorBits:(NSUInteger) bits
{
   _count = mulle_objc_signature_count_typeinfos( types);
   if( _count < 3)  // rval, self, _cmd
   {
      [self release];
      return( nil);
   }

   _types = mulle_allocator_strdup( MulleObjCObjectGetAllocator( self), types);
   _bits  = (uint32_t) bits;
   
   return( self);
}



- (void) dealloc
{
   struct mulle_allocator   *allocator;

   allocator = MulleObjCObjectGetAllocator( self);
   mulle_allocator_free( allocator, _types);
   mulle_allocator_free( allocator, _prettyTypes);
   mulle_allocator_free( allocator, _infos);

   NSDeallocateObject( self);
}

#pragma mark -
#pragma mark convenience constructors

+ (NSMethodSignature *) signatureWithObjCTypes:(char *) types
{
   id   obj;
   
   obj = [[[NSMethodSignature alloc] initWithObjCTypes:types] autorelease];
   return( obj);
}


+ (NSMethodSignature *) _signatureWithObjCTypes:(char *) types
                           methodDescriptorBits:(NSUInteger) bits;

{
   id   obj;
   
   obj = [[[NSMethodSignature alloc] _initWithObjCTypes:types
                                   methodDescriptorBits:bits] autorelease];
   return( obj);
}

#pragma mark -
#pragma mark NSObject

//
// http://www.cse.yorku.ca/~oz/hash.html djb2
//
- (NSUInteger) hash
{
   NSUInteger      hash;
   int             c;
   unsigned char   *s;
   
   hash = 5381;
   s    = (unsigned char *) _types;
   
   while( c = *s++)
      hash = ((hash << 5) + hash) + c; /* hash * 33 + c */
   
   return( hash);
}


- (BOOL) isEqual:(id) other
{
   if( self == other)
      return( YES);

   if( ! [other isKindOfClass:[NSMethodSignature class]])
      return( NO);

   return( ! strcmp( _types, ((NSMethodSignature *) other)->_types));   //hmm
}



#pragma mark -
#pragma mark petty accessors

- (BOOL) isOneway
{
#ifdef _C_ONEWAY
   return( *[self methodReturnType] == _C_ONEWAY);
#else
   return( NO);
#endif   
}


- (BOOL) isVariadic
{
   return( (_bits & _mulle_objc_method_variadic) ? YES : NO);
}


- (NSUInteger) _methodDescriptorBits
{
   return( _bits);
}


- (char *) _objCTypes
{
   return( self->_types);
}


- (NSUInteger) numberOfArguments
{
   return( _count - 1);  // don't count "rval"
}


#pragma mark -
#pragma mark more accessors

- (NSUInteger) frameLength
{
   MulleObjCMethodSignatureTypeinfo  *info;
   size_t                      voidptr5;
   size_t                      overflow;
   size_t                      len;
   
   info     = &get_infos( self)[ _count - 1];
   voidptr5 = sizeof( void *) * 5;
   len      = info->offset + info->natural_size;
   
   overflow = len % voidptr5;
   if( ! overflow)
      return( len);
   return( len + voidptr5 - overflow);
}


//
// do _infos lazily, as they use a bit of memory
//
static MulleObjCMethodSignatureTypeinfo  *get_infos( NSMethodSignature *self)
{
   char                              *types;
   MulleObjCMethodSignatureTypeinfo  *p;
   MulleObjCMethodSignatureTypeinfo  *sentinel;
   struct mulle_allocator            *allocator;
   
   assert( self->_count);
   if( self->_infos)
      return( self->_infos);

   allocator          = MulleObjCObjectGetAllocator( self);
   self->_infos       = mulle_allocator_calloc( allocator, self->_count, sizeof( MulleObjCMethodSignatureTypeinfo));
   self->_prettyTypes = mulle_allocator_strdup( allocator, self->_types);
   
   p        = &self->_infos[ 0];
   sentinel = &p[ self->_count];
   
   types = self->_prettyTypes;
   
   while( types = mulle_objc_signature_supply_next_typeinfo( types, p))
   {
      assert( p < sentinel);
      assert( (p == &self->_infos[ 0] || p[ -1].type != p->pure_type_end) && "need fix for incompatible runtime");
      
      *p->pure_type_end = 0;  // cut off "offset"
      ++p;
   }

   assert( p == sentinel);
   return( self->_infos);
}



- (char *) getArgumentTypeAtIndex:(NSUInteger) i
{  
   if( i >= _count)
      MulleObjCThrowInvalidIndexException( i);

   // will have trailing garbage, but who cares ?
   return( get_infos( self)[ 1 + i].type);
}


- (char *) methodReturnType
{
   //
   // will have trailing garbage
   //
   return( get_infos( self)[ 0].type);
}


// internal usage!
- (MulleObjCMethodSignatureTypeinfo *) _runtimeTypeInfoAtIndex:(NSUInteger) i
{
   if( i >= _count + 1)
      MulleObjCThrowInvalidIndexException( i);
      
   return( &get_infos( self)[ i]);
}


- (NSUInteger) methodReturnLength
{
   MulleObjCMethodSignatureTypeinfo  *info;
   
   info = &get_infos( self)[ 0];
   return( info->natural_size);
}



- (MulleObjCMetaABIType) methodMetaABIParameterType
{
   MulleObjCMetaABIType               paramType;
   MulleObjCMethodSignatureTypeinfo  *info;
   char                              *type;

   if( _bits & _mulle_objc_method_variadic)
      return( MulleObjCMetaABITypeParameterBlock);

   info = &get_infos( self)[ 0];
   type = info->type;
   if( mulle_objc_signature_get_metaabireturntype( type) == MulleObjCMetaABITypeParameterBlock)
      return( MulleObjCMetaABITypeParameterBlock);
   
   paramType = mulle_objc_signature_get_metaabiparamtype( _types);
   return( paramType);
}


- (MulleObjCMetaABIType) methodMetaABIReturnType
{
   MulleObjCMetaABIType               rvalType;
   MulleObjCMethodSignatureTypeinfo   *info;
   char                               *type;
   
   info = &get_infos( self)[ 0];
   type = info->type;
   rvalType = mulle_objc_signature_get_metaabireturntype( type);
   return( rvalType);
}

@end


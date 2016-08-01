/*
 *  MulleFoundation - the mulle-objc class library
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

//  (#X#)
static inline void   *getExtraMemory( NSMethodSignature *self)
{
   return( (void *) &(&self->_infos)[ 1]);
}


static inline BOOL   hasExtraMemory( NSMethodSignature *self)
{
   return( self->_extra);
}


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

   fprintf( stderr, "%s: %p has %sextra memory\n", __PRETTY_FUNCTION__, self, hasExtraMemory( self) ? "" : "no ");
   fprintf( stderr, "%p\n", self->_types);
   fprintf( stderr, "%p\n", getExtraMemory( self));

   return( self);
}


- (void) dealloc
{
   struct mulle_allocator   *allocator;

   allocator = MulleObjCObjectGetAllocator( self);
   
   fprintf( stderr, "%s: %p has %sextra memory\n", __PRETTY_FUNCTION__, self, hasExtraMemory( self) ? "" : "no ");
   if( ! hasExtraMemory( self))
   {
      mulle_allocator_free( allocator, _types);
      mulle_allocator_free( allocator, _prettyTypes);
      mulle_allocator_free( allocator, _infos);
   }
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
                           methodDescriptorBits:(NSUInteger) bits

{
   NSMethodSignature   *obj;
   NSUInteger          extra;
   NSUInteger          size;
   NSUInteger          count;

   if( ! types)
      return( nil);

   count  = mulle_objc_signature_count_typeinfos( types);
   if( count < 3)
      return( nil);
   
   size   = strlen( types) + 1;
   extra  = size * 2;
   extra += count * sizeof( MulleObjCMethodSignatureTypeinfo);

   assert( extra < 0x10000);
   assert( count < 0x10000);
   
   obj               = NSAllocateObject( self, extra, NULL);
   obj->_count       = (uint16_t) count;
   obj->_extra       = (uint16_t) extra;
   obj->_bits        = (uint32_t) bits;
   obj->_types       = getExtraMemory( obj);
   obj->_prettyTypes = &((char *) obj->_types)[ size];
   obj->_infos       = (void *) &((char *) obj->_prettyTypes)[ size];
   
   memcpy( obj->_types, types, size);
   
   return( [obj autorelease]);
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
   
   // already run ?
   if( self->_prettyTypes && self->_prettyTypes[ 0])
      return( self->_infos);

   if( ! hasExtraMemory( self))
   {
      allocator    = MulleObjCObjectGetAllocator( self);
      self->_infos = mulle_allocator_calloc( allocator, self->_count, sizeof( MulleObjCMethodSignatureTypeinfo));
      self->_prettyTypes = mulle_allocator_strdup( allocator, self->_types);
   }
   else
      strcpy( self->_prettyTypes, self->_types);

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


- (MulleObjCMetaABIType) _methodMetaABIParameterType
{
   MulleObjCMetaABIType   paramType;

   if( _bits & _mulle_objc_method_variadic)
      return( MulleObjCMetaABITypeParameterBlock);

   if( self->_count == 3)
      return( MulleObjCMetaABITypeVoid);
   
   paramType = mulle_objc_signature_get_metaabiparamtype( _types);
   assert( paramType != (MulleObjCMetaABIType) -1);
   return( paramType);
}


- (MulleObjCMetaABIType) _methodMetaABIReturnType
{
   MulleObjCMetaABIType   rvalType;
   
   rvalType = _mulle_objc_signature_get_metaabireturntype( _types);
   assert( rvalType != (MulleObjCMetaABIType) -1);
   return( rvalType);
}


// this method does not round up for MetaABI
- (NSUInteger) frameLength
{
   MulleObjCMethodSignatureTypeinfo   *info;
   
   info = &get_infos( self)[ _count - 1];    // get last argument
   return( info->offset + info->natural_size);
}


// this method does not round up for MetaABI
- (NSUInteger) methodReturnLength
{
   MulleObjCMethodSignatureTypeinfo  *info;
   
   info = &get_infos( self)[ 0];
   return( info->natural_size);
}

@end


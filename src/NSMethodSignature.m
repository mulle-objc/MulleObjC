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
      [self autorelease];
      return( nil);
   }

   _types = MulleObjCDuplicateCString( types);
   return( self);
}


//
// do _infos lazily, as they use a bit of memory
//
static MulleObjCMethodSignatureTypeinfo  *get_infos( NSMethodSignature *self)
{
   char                              *types;
   MulleObjCMethodSignatureTypeinfo  *p;
   MulleObjCMethodSignatureTypeinfo  *sentinel;
   
   assert( self->_count);
   if( self->_infos)
      return( self->_infos);

   self->_infos = MulleObjCAllocateMemory( self->_count * sizeof( MulleObjCMethodSignatureTypeinfo));
   
   p        = &self->_infos[ 0];
   sentinel = &p[ self->_count];
   
   types = self->_types;
   
   while( types = mulle_objc_signature_supply_next_typeinfo( types, p))
   {
      assert( p < sentinel);
      ++p;
   }

   assert( p == sentinel);
   return( self->_infos);
}


- (void) dealloc
{
   MulleObjCDeallocateMemory( _types);
   MulleObjCDeallocateMemory( _infos);

   NSDeallocateObject( self);
}


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


- (char *) _objCTypes
{
   return( self->_types);
}


- (char *) methodReturnType
{
   //
   // will have trailing garbage
   //
   return( get_infos( self)[ 0].type);
}


- (NSUInteger) numberOfArguments
{
   return( _count - 1);  // don't count "rval"
}


- (char *) getArgumentTypeAtIndex:(NSUInteger) i
{  
   if( i >= _count)
      MulleObjCThrowInvalidIndexException( i);

   // will have trailing garbage, but who cares ?
   return( get_infos( self)[ 1 + i].type);
}


// internal usage!
- (MulleObjCMethodSignatureTypeinfo *) _runtimeTypeInfoAtIndex:(NSUInteger) i
{
   if( i >= _count + 1)
      MulleObjCThrowInvalidIndexException( i);
      
   return( &get_infos( self)[ i]);
}


+ (NSMethodSignature *) signatureWithObjCTypes:(char *) types
{
   id   obj;
   
   obj = [[[NSMethodSignature alloc] initWithObjCTypes:types] autorelease];
   return( obj);
}


- (BOOL) isOneway
{
#ifdef _C_ONEWAY
   return( *[self methodReturnType] == _C_ONEWAY);
#else
   return( NO);
#endif   
}


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


- (NSUInteger) methodReturnLength
{
   MulleObjCMethodSignatureTypeinfo  *info;
   
   info = &get_infos( self)[ 0];
   return( info->natural_size);
}


- (MulleObjCMetaABIType) methodMetaABIReturnType
{
   MulleObjCMethodSignatureTypeinfo  *info;
   char                        *type;

   info = &get_infos( self)[ 0];
   type = info->type;
   return( mulle_objc_signature_get_metaabireturntype( type));
}


- (MulleObjCMetaABIType) methodMetaABIParameterType
{
   return( mulle_objc_signature_get_metaabiparamtype( _types));
}

@end


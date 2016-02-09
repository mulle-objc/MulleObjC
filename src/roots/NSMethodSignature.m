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
#import "NSAllocation.h"


@implementation NSMethodSignature

- (id) initWithObjCTypes:(char *) types
{
   _count = mulle_objc_signature_count_typeinfos( types);
   if( _count < 3)  // rval, self, _cmd
   {
      [self autorelease];
      return( nil);
   }

   _types = _NSDuplicateCString( types);
   return( self);
}


//
// do _infos lazily, as they use a bit of memory
//
static _NSMethodSignatureTypeinfo  *get_infos( NSMethodSignature *self)
{
   unsigned int   i;
   char           *types;
   uintptr_t      offset;
   
   assert( self->_count);
   if( ! self->_infos)
   {
      self->_infos = _NSAllocateMemory( self->_count * sizeof( _NSMethodSignatureTypeinfo));
      
      //
      // the offsets are kind of wrong, depending on call convention, as the
      // return value may share the space of the first parameter. But doing
      // it differently may be too surprising.
      //
      offset = 0;
      for( i = 0, types = self->_types; types = mulle_objc_signature_supply_next_typeinfo( types, &self->_infos[ i].info); i++)
      {
         self->_infos[ i].offset = mulle_objc_align( offset, self->_infos[ i].info.natural_alignment);
         offset                 += self->_infos[ i].info.natural_size;
      }
      assert( i == self->_count);
   }
   return( self->_infos);
}


- (void) dealloc
{
   _NSDeallocateMemory( _types);
   _NSDeallocateMemory( _infos);

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
   
   while( c = *_types++)
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
   return( get_infos( self)[ 0].info.type);
}


- (NSUInteger) numberOfArguments
{
   return( _count - 1);  // don't count "rval"
}


- (char *) getArgumentTypeAtIndex:(NSUInteger) i
{  
   if( i >= _count)
      __NSThrowInvalidIndexException( i);

   // will have trailing garbage, but who cares ?
   return( get_infos( self)[ 1 + i].info.type);
}


// internal usage!
- (_NSMethodSignatureTypeinfo *) _runtimeTypeInfoAtIndex:(NSUInteger) i
{
   if( i >= _count + 1)
      __NSThrowInvalidIndexException( i);
      
   return( &get_infos( self)[ i]);
}


+ (NSMethodSignature *) signatureWithObjCTypes:(char *) types
{
   id   obj;
   
   obj = [[NSMethodSignature allocWithZone:NULL] initWithObjCTypes:types];
   return( NSAutoreleaseObject( obj));
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
   _NSMethodSignatureTypeinfo  *info;
   size_t                      voidptr5;
   size_t                      overflow;
   
   info     = &get_infos( self)[ _count - 1];
   voidptr5 = sizeof( void *) * 5;
   
   overflow = info->offset % voidptr5;
   if( ! overflow)
      return( info->offset);
   return( info->offset + voidptr5 - overflow);
}


- (NSUInteger) methodReturnLength
{
   unsigned int   size;

   mulle_objc_signature_supply_size_and_alignment( [self methodReturnType], &size, NULL);
   return( size);
}


- (_NSMetaABIType) methodMetaABIReturnType
{
   char   *type;
   
   type = get_infos( self)[ 0].info.type;
   return( mulle_objc_signature_get_metaabireturntype( type));
}


- (_NSMetaABIType) methodMetaABIParameterType
{
   return( mulle_objc_signature_get_metaabiparamtype( _types));
}

@end


//
//  MulleObjCIvar.m
//  MulleObjC
//
//  Copyright (c) 2024 Nat! - Mulle kybernetiK.
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
#import "MulleObjCIvar.h"

#import "import-private.h"

// other files in this library
#import "mulle-objc-type.h"
#import "mulle-objc-classbit.h"
#import "MulleObjCException.h"
#import "MulleObjCExceptionHandler.h"
#import "MulleObjCExceptionHandler-Private.h"
#import "MulleObjCIntegralType.h"
#import "NSCopying.h"
#import "mulle-objc-exceptionhandlertable-private.h"
#import "mulle-objc-universefoundationinfo-private.h"


#pragma clang diagnostic ignored "-Wobjc-root-class"
#pragma clang diagnostic ignored "-Wparentheses"


static int   get_ivar_offset( struct _mulle_objc_infraclass *infra,
                              mulle_objc_ivarid_t ivarid,
                              void *buf,
                              size_t size)
{
   struct _mulle_objc_ivar   *ivar;

   ivar = _mulle_objc_infraclass_search_ivar( infra, ivarid);
   if( ! ivar)
      return( -2);

#ifndef NDEBUG
   {
      char           *signature;
      unsigned int   ivar_size;
      unsigned int   ivar_align;

      signature = _mulle_objc_ivar_get_signature( ivar);
      mulle_objc_signature_supply_size_and_alignment( signature, &ivar_size, &ivar_align);
      assert( ivar_size == size);
      assert( ((intptr_t) buf & (ivar_align - 1)) == 0);
   }
#endif

   return( _mulle_objc_ivar_get_offset( ivar));
}


int   _MulleObjCObjectSetIvar( id self, mulle_objc_ivarid_t ivarid, void *buf, size_t size)
{
   int                        offset;
   struct _mulle_objc_class   *cls;

   cls = _mulle_objc_object_get_isa( self);

   assert( _mulle_objc_class_is_infraclass( cls));
   assert( mulle_objc_ivarid_is_sane( ivarid));
   assert( buf);

   offset = get_ivar_offset( (Class) cls, ivarid, buf, size);
   switch( offset)
   {
   case -2 :
      return( -1);
   case -1 :
      // hashed offset not yet implemented
      return( -1);
   default :
      break;
   }

   memcpy( &((char *) self)[ offset], buf, size);
   return( 0);
}


int   _MulleObjCObjectGetIvar( id self, mulle_objc_ivarid_t ivarid, void *buf, size_t size)
{
   int                        offset;
   struct _mulle_objc_class   *cls;

   cls = _mulle_objc_object_get_isa( self);

   assert( _mulle_objc_class_is_infraclass( cls));
   assert( mulle_objc_ivarid_is_sane( ivarid));
   assert( buf);

   offset = get_ivar_offset( (Class) cls, ivarid, buf, size);
   switch( offset)
   {
      case -2 :
         return( -1);
      case -1 :
         // hashed offset not yet implemented
         return( -1);
      default :
         break;
   }

   memcpy( buf, &((char *) self)[ offset], size);
   return( 0);
}


static void   throw_unknown_ivarid( struct _mulle_objc_class *cls,
                                    mulle_objc_ivarid_t ivarid)
{
   __mulle_objc_universe_raise_invalidargument( _mulle_objc_class_get_universe( cls),
                                                "Class %08x \"%s\" has no ivar with id %08x found",
                                                _mulle_objc_class_get_classid( cls),
                                                _mulle_objc_class_get_name( cls),
                                                ivarid);
}


id   MulleObjCObjectGetObjectIvar( id self, mulle_objc_ivarid_t ivarid)
{
   id   obj;

   if( ! self)
      return( nil);

   if( _MulleObjCObjectGetIvar( self, ivarid, &obj, sizeof( obj)))
      throw_unknown_ivarid( _mulle_objc_object_get_isa( self), ivarid);

   return( obj);
}


void   MulleObjCObjectSetObjectIvar( id self, mulle_objc_ivarid_t ivarid, id value)
{

   id                         old;
   struct _mulle_objc_class   *cls;
   struct _mulle_objc_ivar    *ivar;
   char                       *signature;
   char                       *typeinfo;
   int                        offset;
   id                         *p;

   if( ! self)
      return;

   cls = _mulle_objc_object_get_isa( self);

   assert( _mulle_objc_class_is_infraclass( cls));
   assert( mulle_objc_ivarid_is_sane( ivarid));

   ivar = _mulle_objc_infraclass_search_ivar( (Class) cls, ivarid);
   if( ! ivar)
      throw_unknown_ivarid( cls, ivarid);

   offset = _mulle_objc_ivar_get_offset( ivar);
   if( offset == -1)
      __mulle_objc_universe_raise_internalinconsistency( _mulle_objc_object_get_universe( self),
                                                         "hashed access not yet implemented");

   p         = (id *) &((char *) self)[ offset];
   signature = _mulle_objc_ivar_get_signature( ivar);
   typeinfo  = _mulle_objc_signature_skip_extendedtypeinfo( signature);

   switch( *typeinfo)
   {
   case _C_COPY_ID   :
      old   = *p;
      [old autorelease];
      value = [(id <NSCopying>) value copy];
      break;

   case _C_RETAIN_ID :
      old   = *p;
      [old autorelease];
      value = [value retain];
      break;
   }

   *p = value;
}


void   MulleObjCObjectSetDuplicatedUTF8String( id self, char **ivar, char *s)
{
   struct mulle_allocator  *allocator;

   if( s == *ivar)
      return;

   allocator = MulleObjCInstanceGetAllocator( self);
   if( s)
      s = mulle_allocator_strdup( allocator, s);

   mulle_allocator_free( allocator, *ivar);
   *ivar = s;
}


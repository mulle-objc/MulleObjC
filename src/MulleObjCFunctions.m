//
//  MulleObjCFunctions.m
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
#include "MulleObjCFunctions.h"

// other files in this library
#import "NSObjectProtocol.h"

// std-c and dependencies
#include <mulle_objc/mulle_objc.h>
#include "ns_rootconfiguration.h"


Class   NSClassFromObject( id object)
{
   return( [object class]);
}


char   *NSGetSizeAndAlignment( char *type, NSUInteger *size, NSUInteger *alignment)
{
   struct mulle_objc_typeinfo   info;
   char                         *next;

   assert( type);

   if( ! type)
   {
      memset( &info, 0, sizeof( info));
      next = NULL;
   }
   else
   {
      if( ! size && ! alignment)
         return( mulle_objc_signature_supply_next_typeinfo( type, NULL));

      next = mulle_objc_signature_supply_next_typeinfo( type, &info);
   }

   if( size)
      *size      = info.bits_size >> 3;
   if( alignment)
      *alignment = info.natural_alignment;

   return( next);
}


void   MulleObjCMakeObjectsPerformRelease( id *objects, NSUInteger n)
{
   if( ! objects)
   {
      assert( ! n);
      return;
   }

   _mulle_objc_objects_call_release( (void **) objects, (unsigned int) n);
}


void   MulleObjCMakeObjectsPerformRetain( id *objects, NSUInteger n)
{
   if( ! objects)
   {
      assert( ! n);
      return;
   }

   _mulle_objc_objects_call_retain( (void **) objects, (unsigned int) n);
}


void   MulleObjCMakeObjectsPerformSelector2( id *objects, NSUInteger n, SEL sel, id argument, id argument2)
{
   mulle_objc_metaabi_param_block_void_return( struct { id a; id b;})  _param;

   _param.p.a = argument;
   _param.p.b = argument2;

   mulle_objc_objects_call( (void **) objects, (unsigned int) n, (mulle_objc_methodid_t) sel, &_param);
}


# pragma mark -
# pragma mark String Functions

char  *MulleObjCClassGetName( Class cls)
{
   if( ! cls)
      return( NULL);

   return( _mulle_objc_infraclass_get_name( cls));
}


char   *MulleObjCSelectorGetName( SEL sel)
{
   struct _mulle_objc_methoddescriptor   *desc;
   struct _mulle_objc_runtime            *runtime;

   runtime = mulle_objc_get_runtime();
   desc    = _mulle_objc_runtime_lookup_methoddescriptor( runtime, (mulle_objc_methodid_t) sel);
   return( desc ? _mulle_objc_methoddescriptor_get_name( desc) : NULL);
}


Class   MulleObjCLookupClassByName( char *name)
{
   struct _mulle_objc_runtime     *runtime;
   Class                          cls;
   mulle_objc_classid_t           classid;

   if( ! name)
      return( Nil);

   classid = mulle_objc_classid_from_string( name);

   runtime = mulle_objc_get_runtime();
   cls     = _mulle_objc_runtime_get_or_lookup_infraclass( runtime, classid);

   return( cls);
}


static char  *fake_signatures[ 16] =
{
   "@@:",
   "@@:@",
   "@@:@@",
   "@@:@@@",
   "@@:@@@@",
   "@@:@@@@@",
   "@@:@@@@@@",
   "@@:@@@@@@@",
   "@@:@@@@@@@@",
   "@@:@@@@@@@@@",
   "@@:@@@@@@@@@@",
   "@@:@@@@@@@@@@@",
   "@@:@@@@@@@@@@@@",
   "@@:@@@@@@@@@@@@@",
   "@@:@@@@@@@@@@@@@@",
   "@@:@@@@@@@@@@@@@@@"
};


static unsigned int   count_params( char *name)
{
   unsigned int   n;
   int            c;

   n = 0;
   while( c = *name++)
      n += c == ':';
   return( n);
}


SEL   MulleObjCCreateSelector( char *name)
{
   mulle_objc_methodid_t                methodid;
   struct _mulle_objc_runtime           *runtime;
   struct _mulle_objc_methoddescriptor  *desc;
   unsigned int                         n;

   if( ! name)
      return( (SEL) MULLE_OBJC_NO_METHODID);

   methodid = mulle_objc_uniqueid_from_string( name);
   // if method is not known register a descriptor
   // so that NSStringFromSelector can get something

   runtime = mulle_objc_get_runtime();
   desc    = _mulle_objc_runtime_lookup_methoddescriptor( runtime, methodid);
   if( ! desc)
   {
      desc = mulle_objc_runtime_calloc( runtime, 1, sizeof( struct _mulle_objc_methoddescriptor));

      desc->methodid  = methodid;
      desc->bits      = _mulle_objc_method_guessed_signature;
      desc->name      = mulle_objc_runtime_strdup( runtime, name);

      n = count_params( name);
      if( n < 16)
         desc->signature = fake_signatures[ n];  // could do better I guess
      else
      {
         n += 3;  // add "@@:"

         desc->signature = mulle_objc_runtime_calloc( runtime, 1, n + 1);
         memset( desc->signature, '@', n);
         desc->signature[ 2] = ':';
      }

      mulle_objc_runtime_unfailing_add_methoddescriptor( runtime, desc);
   }
   return( (SEL) (uintptr_t) methodid);
}


void    MulleObjCSetClass( id obj, Class cls)
{
   if( ! obj)
      mulle_objc_throw_invalid_argument_exception( "object can't be NULL");
   if( ! cls)
      mulle_objc_throw_invalid_argument_exception( "class can't be NULL");

   if( _mulle_objc_infraclass_is_taggedpointerclass( cls))
      mulle_objc_throw_invalid_argument_exception( "class \"%s\" is a tagged pointer class", _mulle_objc_infraclass_get_name( cls));

   _mulle_objc_object_set_isa( obj, _mulle_objc_infraclass_as_class( cls));
}


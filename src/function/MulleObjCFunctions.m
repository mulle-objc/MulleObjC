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
#import "import-private.h"

#import "MulleObjCFunctions.h"

// other files in this library
#import "mulle-objc-type.h"
#import "MulleObjCIntegralType.h"
#import "MulleObjCUniverse.h"
#import "MulleObjCExceptionHandler.h"
#import "MulleObjCExceptionHandler-Private.h"
#import "mulle-objc-exceptionhandlertable-private.h"
#import "mulle-objc-universefoundationinfo-private.h"

#import "NSObjectProtocol.h"

// std-c and dependencies


#pragma clang diagnostic ignored "-Wparentheses"


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

   _mulle_objc_objects_release( (void **) objects, (unsigned int) n);
}


void   MulleObjCMakeObjectsPerformRetain( id *objects, NSUInteger n)
{
   if( ! objects)
   {
      assert( ! n);
      return;
   }

   _mulle_objc_objects_retain( (void **) objects, (unsigned int) n);
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
   struct _mulle_objc_descriptor   *desc;
   struct _mulle_objc_universe     *universe;
   char                            *s;

   universe = MulleObjCGetUniverse();
   desc     = _mulle_objc_universe_lookup_descriptor( universe,
                                                      (mulle_objc_methodid_t) sel);

   //
   // due to forwarding, we also search through the hashstrings
   // e.g. [foo callForwardSomething], doesn't create a selector by the
   // compiler, but a hashstring
   //
   if( desc)
      return( _mulle_objc_descriptor_get_name( desc));

   s = _mulle_objc_universe_search_hashstring( universe, (mulle_objc_uniqueid_t) sel);
   return( s);
}


char   *MulleObjCProtocolGetName( PROTOCOL proto)
{
   struct _mulle_objc_protocol     *protocol;
   struct _mulle_objc_universe     *universe;

   universe = MulleObjCGetUniverse();
   protocol = _mulle_objc_universe_lookup_protocol( universe,
                                                    (mulle_objc_protocolid_t) proto);
   // do we need forwarding for protocols ? don't thinks so
   return( protocol ? _mulle_objc_protocol_get_name( protocol) : NULL);
}


Class   MulleObjCLookupClassByName( char *name)
{
   Class                         cls;
   mulle_objc_classid_t          classid;
   struct _mulle_objc_universe   *universe;

   if( ! name)
      return( Nil);

   classid  = mulle_objc_classid_from_string( name);
   universe = MulleObjCGetUniverse();
   cls      = _mulle_objc_universe_lookup_infraclass( universe, classid);

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
   mulle_objc_methodid_t          methodid;
   struct _mulle_objc_descriptor  *desc;
   struct _mulle_objc_universe    *universe;
   unsigned int                   n;

   if( ! name)
      return( (SEL) MULLE_OBJC_NO_METHODID);

   methodid = mulle_objc_uniqueid_from_string( name);
   // if method is not known register a descriptor
   // so that NSStringFromSelector can get something

   universe = MulleObjCGetUniverse();
   desc     = _mulle_objc_universe_lookup_descriptor( universe, methodid);
   if( desc)
      return( (SEL) (uintptr_t) methodid);

   desc = mulle_objc_universe_calloc( universe, 1, sizeof( struct _mulle_objc_descriptor));

   desc->methodid  = methodid;
   desc->bits      = _mulle_objc_method_guessed_signature;
   desc->name      = mulle_objc_universe_strdup( universe, name);

   n = count_params( name);
   if( n < 16)
      desc->signature = fake_signatures[ n];  // could do better I guess
   else
   {
      n += 3;  // add "@@:"

      desc->signature = mulle_objc_universe_calloc( universe, 1, n + 1);
      memset( desc->signature, '@', n);
      desc->signature[ 2] = ':';
   }

   mulle_objc_universe_register_descriptor_nofail( universe, desc);
   return( (SEL) (uintptr_t) methodid);
}


void    MulleObjCObjectSetClass( id obj, Class cls)
{
   if( ! obj)
      return;

   if( ! cls)
      __mulle_objc_universe_raise_invalidargument( _mulle_objc_object_get_universe( obj),
                                                   "class can't be NULL");
   if( _mulle_objc_infraclass_is_taggedpointerclass( cls))
      __mulle_objc_universe_raise_invalidargument( _mulle_objc_object_get_universe( obj),
                                                   "class \"%s\" is a tagged pointer class", _mulle_objc_infraclass_get_name( cls));

   _mulle_objc_object_set_isa( obj, _mulle_objc_infraclass_as_class( cls));
}


#pragma mark - search specific methods


IMP   MulleObjCObjectSearchSuperIMP( id obj,
                                     SEL sel,
                                     mulle_objc_classid_t classid)
{
   struct _mulle_objc_searcharguments   search;
   struct _mulle_objc_class             *cls;
   struct _mulle_objc_method            *method;
   mulle_objc_implementation_t    imp;

   if( ! obj)
      return( (IMP) 0);

   _mulle_objc_searcharguments_superinit( &search, sel, classid);

   cls    = _mulle_objc_object_get_isa( obj);
   method = mulle_objc_class_search_method( cls,
                                           &search,
                                           _mulle_objc_class_get_inheritance( cls) ,
                                           NULL);
   imp = 0;
   if( method)
      imp = _mulle_objc_method_get_implementation( method);

   return( (IMP) imp);
}



IMP   MulleObjCObjectSearchOverriddenIMP( id obj,
                                          SEL sel,
                                          mulle_objc_classid_t classid,
                                          mulle_objc_categoryid_t categoryid)
{
   struct _mulle_objc_searcharguments   search;
   struct _mulle_objc_class             *cls;
   struct _mulle_objc_method            *method;
   mulle_objc_implementation_t    imp;

   if( ! obj)
      return( (IMP) 0);

   _mulle_objc_searcharguments_overriddeninit( &search, sel, classid, categoryid);

   cls    = _mulle_objc_object_get_isa( obj);
   method = mulle_objc_class_search_method( cls,
                                           &search,
                                           _mulle_objc_class_get_inheritance( cls) ,
                                           NULL);
   imp = 0;
   if( method)
      imp = _mulle_objc_method_get_implementation( method);

   return( (IMP) imp);
}


// Find a specific implementation given class and category:
//
// call MulleObjCLookupSpecificIMP( self, _cmd, @selector( Foo), @selector( A))
//
IMP   MulleObjCObjectSearchSpecificIMP( id obj,
                                        SEL sel,
                                        mulle_objc_classid_t classid,
                                        mulle_objc_categoryid_t categoryid)
{
   struct _mulle_objc_searcharguments    search;
   struct _mulle_objc_class              *cls;
   struct _mulle_objc_method             *method;
   mulle_objc_implementation_t     imp;

   if( ! obj)
      return( (IMP) 0);

   _mulle_objc_searcharguments_specificinit( &search, sel, classid, categoryid);

   cls    = _mulle_objc_object_get_isa( obj);
   method = mulle_objc_class_search_method( cls,
                                            &search,
                                           _mulle_objc_class_get_inheritance( cls) ,
                                           NULL);
   imp = 0;
   if( method)
      imp = _mulle_objc_method_get_implementation( method);

   return( (IMP) imp);
}


NSUInteger   MulleObjCClassGetLoadAddress( Class cls)
{
   struct _mulle_objc_classpair   *pair;

   if( ! cls)
      return( 0);

   pair = _mulle_objc_infraclass_get_classpair( cls);
   return( (NSUInteger) _mulle_objc_classpair_get_loadclass( pair));
}

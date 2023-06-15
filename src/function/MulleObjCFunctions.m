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

#include <ctype.h>
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
         return( mulle_objc_signature_supply_typeinfo( type, NULL, NULL));

      next = mulle_objc_signature_supply_typeinfo( type,  NULL, &info);
   }

   if( size)
      *size = info.bits_size >> 3;
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


void   MulleObjCMakeObjectsPerformSelector2( id *objects,
                                             NSUInteger n,
                                             SEL sel,
                                             id argument,
                                             id argument2)
{
   mulle_metaabi_union_void_return( struct { id a; id b;})  _param;

   _param.p.a = argument;
   _param.p.b = argument2;

   mulle_objc_objects_call( (void **) objects,
                            (unsigned int) n,
                            (mulle_objc_methodid_t) sel,
                            &_param);
}

#undef MulleObjCIMPTraceCall
void   MulleObjCIMPTraceCall( IMP imp, id obj, SEL sel, void *param)
{
   struct _mulle_objc_universe   *universe;
   struct _mulle_objc_class      *cls;

   if( ! obj)
      return;

   cls      = _mulle_objc_object_get_isa( obj);
   universe = _mulle_objc_class_get_universe( cls);
   if( universe->debug.trace.method_call)
      mulle_objc_class_trace_call( cls,
                                   obj,
                                   (mulle_objc_methodid_t) sel,
                                   param,
                                   (mulle_objc_implementation_t) imp);
}


# pragma mark - String Functions

// should be CString something
char  *MulleObjCClassGetNameUTF8String( Class cls)
{
   if( ! cls)
      return( NULL); // return NULL to stay compatible with NSStringFromClass

   return( _mulle_objc_infraclass_get_name( cls));
}


char   *MulleObjCSelectorGetNameUTF8String( SEL sel)
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


char   *MulleObjCProtocolGetNameUTF8String( PROTOCOL proto)
{
   struct _mulle_objc_protocol     *protocol;
   struct _mulle_objc_universe     *universe;

   universe = MulleObjCGetUniverse();
   protocol = _mulle_objc_universe_lookup_protocol( universe,
                                                    (mulle_objc_protocolid_t) proto);
   // do we need forwarding for protocols ? don't thinks so
   return( protocol ? _mulle_objc_protocol_get_name( protocol) : NULL);
}


Class   MulleObjCLookupClassByNameUTF8String( char *name)
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


SEL   MulleObjCCreateSelectorUTF8String( char *name)
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


Class   MulleObjCLookupClassByClassID( SEL classid)
{
   struct _mulle_objc_universe    *universe;

   if( ! classid)
      return( Nil);

   universe = MulleObjCGetUniverse();
   return( (Class) _mulle_objc_universe_lookup_infraclass( universe, classid));
}


char  *MulleObjCInstanceGetClassNameUTF8String( id obj)
{
   return( MulleObjCClassGetNameUTF8String( [obj class]));
}


void    MulleObjCObjectSetClass( id obj, Class cls)
{
   struct _mulle_objc_class   *new_cls;

   if( ! obj)
      return;

   if( ! cls)
      __mulle_objc_universe_raise_invalidargument( _mulle_objc_object_get_universe( obj),
                                                   "class can't be NULL");
   if( _mulle_objc_infraclass_is_taggedpointerclass( cls))
      __mulle_objc_universe_raise_invalidargument( _mulle_objc_object_get_universe( obj),
                                                   "class \"%s\" is a tagged pointer class",
                                                   _mulle_objc_infraclass_get_name( cls));

   new_cls = _mulle_objc_infraclass_as_class( cls);

   // MEMO: we can't actually do this, as the incoming memory may not be 
   //       initialized yet, so the old class may be invalid or something else
   //       entirely
   //
   // not sure if we shouldn't also check allocation size, but we don't track
   // extra, so its hard to prove that it makes no sense. With the meta size
   // it's probably OK. Since we would fail on dealloc...
   //
   // #if DEBUG
   //    {
   //       struct _mulle_objc_class  *old_cls;
   // 
   //       old_cls = _mulle_objc_object_get_isa( obj);
   //       if( old_cls)
   //       {
   //          if( _mulle_objc_class_get_metaextrasize( old_cls) ||
   //              _mulle_objc_class_get_metaextrasize( new_cls))
   //          {
   //             if( _mulle_objc_class_get_metaextrasize( old_cls) != _mulle_objc_class_get_metaextrasize( new_cls))
   //                __mulle_objc_universe_raise_invalidargument( _mulle_objc_object_get_universe( obj),
   //                                                             "Differing meta information of class \"%s\" and class \"%s\"",
   //                                                             _mulle_objc_class_get_name( old_cls),
   //                                                             _mulle_objc_class_get_name( new_cls));
   //             // if new_cls inherits old_cls or vice versa its OK I guess
   //             if( ! _mulle_objc_class_has_direct_relation_to_class( new_cls, old_cls))
   //                __mulle_objc_universe_raise_invalidargument( _mulle_objc_object_get_universe( obj),
   //                                                             "class \"%s\" and class \"%s\" hold meta information \
   // but the classes have no direct relation",
   //                                                             _mulle_objc_class_get_name( old_cls),
   //                                                             _mulle_objc_class_get_name( new_cls));
   //          }
   //       }
   //    }
   // #endif

   _mulle_objc_object_set_isa( obj, new_cls);
}


#pragma mark - search specific methods


IMP   MulleObjCObjectSearchSuperIMP( id obj,
                                     SEL sel,
                                     mulle_objc_classid_t classid)
{
   struct _mulle_objc_searcharguments   search;
   struct _mulle_objc_class             *cls;
   struct _mulle_objc_method            *method;
   mulle_objc_implementation_t          imp;

   if( ! obj)
      return( (IMP) 0);

   _mulle_objc_searcharguments_init_super( &search, sel, classid);

   cls    = _mulle_objc_object_get_isa( obj);
   method = mulle_objc_class_search_method( cls,
                                           &search,
                                           _mulle_objc_class_get_inheritance( cls),
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
   mulle_objc_implementation_t          imp;
   unsigned int                         inheritance;

   if( ! obj)
      return( (IMP) 0);

   _mulle_objc_searcharguments_init_overridden( &search, sel, classid, categoryid);

   cls         = _mulle_objc_object_get_isa( obj);
   inheritance =  _mulle_objc_class_get_inheritance( cls);

   method = mulle_objc_class_search_method( cls, &search, inheritance, NULL);
   imp = 0;
   if( method)
      imp = _mulle_objc_method_get_implementation( method);

   return( (IMP) imp);
}



IMP   MulleObjCObjectSearchClobberedIMP( id obj,
                                         SEL sel,
                                         mulle_objc_classid_t classid,
                                         mulle_objc_categoryid_t categoryid)
{
   struct _mulle_objc_searcharguments   search;
   struct _mulle_objc_class             *cls;
   struct _mulle_objc_method            *method;
   mulle_objc_implementation_t          imp;
   unsigned int                         inheritance;

   if( ! obj)
      return( (IMP) 0);

   _mulle_objc_searcharguments_init_overridden( &search, sel, classid, categoryid);

   cls         = _mulle_objc_object_get_isa( obj);
   inheritance = _mulle_objc_class_get_inheritance( cls)
                 | MULLE_OBJC_CLASS_DONT_INHERIT_SUPERCLASS
                 | MULLE_OBJC_CLASS_DONT_INHERIT_PROTOCOLS
                 | MULLE_OBJC_CLASS_DONT_INHERIT_PROTOCOL_CATEGORIES;

   method = mulle_objc_class_search_method( cls, &search, inheritance, NULL);
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
   struct _mulle_objc_searcharguments   search;
   struct _mulle_objc_class             *cls;
   struct _mulle_objc_method            *method;
   mulle_objc_implementation_t          imp;
   unsigned int                         inheritance;

   if( ! obj)
      return( (IMP) 0);

   _mulle_objc_searcharguments_init_specific( &search, sel, classid, categoryid);

   cls         = _mulle_objc_object_get_isa( obj);
   inheritance = _mulle_objc_class_get_inheritance( cls);
   method      = mulle_objc_class_search_method( cls, &search, inheritance, NULL);
   imp = 0;
   if( method)
      imp = _mulle_objc_method_get_implementation( method);

   return( (IMP) imp);
}


unsigned int   _mulle_objc_class_search_clobber_chain( struct _mulle_objc_class *cls,
                                                       SEL sel,
                                                       IMP *array,
                                                       unsigned int n)
{
   IMP                                   *p;
   IMP                                   *sentinel;
   struct _mulle_objc_method             *method;
   struct _mulle_objc_searcharguments    args;
   struct _mulle_objc_searchresult       result;
   unsigned int                          inheritance;

   assert( cls);
   assert( array || ! n);

   p        = array;
   sentinel = &p[ n];

   _mulle_objc_searcharguments_init_default( &args, sel);
   inheritance = _mulle_objc_class_get_inheritance( cls)
                 | MULLE_OBJC_CLASS_DONT_INHERIT_SUPERCLASS
                 | MULLE_OBJC_CLASS_DONT_INHERIT_PROTOCOLS
                 | MULLE_OBJC_CLASS_DONT_INHERIT_PROTOCOL_CATEGORIES;

   for(;;)
   {
      method = mulle_objc_class_search_method( cls, &args, inheritance, &result);
      if( ! method)
         return( p - array);

      if( p < sentinel)
         *p = (IMP) _mulle_objc_method_get_implementation( method);
      ++p;

      _mulle_objc_searcharguments_init_overridden( &args,
                                                  sel,
                                                  mulle_objc_searchresult_get_classid( &result),
                                                  mulle_objc_searchresult_get_categoryid( &result));
   }
}


void   *MulleObjCClassGetLoadAddress( Class cls)
{
   struct _mulle_objc_classpair   *pair;

   if( ! cls)
      return( 0);

   pair = _mulle_objc_infraclass_get_classpair( cls);
   return( (void *) _mulle_objc_classpair_get_loadclass( pair));
}


#define get_scalarvalue( v, type, p, sentinel)     \
   do                                              \
   {                                               \
      type   *q;                                   \
                                                   \
      p = mulle_pointer_align( p, alignof( type)); \
      q = ((type *) p) + 1;                        \
      if( q > (type *) sentinel)                   \
         return( NULL);                            \
      v = *((type *) p);                           \
      p = (void *) q;                              \
   }                                               \
   while( 0)                                       


static void  *_MulleObjCDescribeMemory( struct mulle_buffer *buffer, 
                                        struct mulle_data data,
                                        char **p_type, 
                                        char *sep)
{
   char       *p;
   char       *sentinel;
   char       *type;
   char       *element_type;
   int        i, n;
   char       *s;
   union mulle_objc_scalarvalue
   {
      char                            *c_atom;
      intptr_t                        c_bool;
      char                            *c_charptr;
      char                            c_chr;
      struct _mulle_objc_infraclass   c_class;
      double                          c_dbl;
      float                           c_flt;
      id                              c_id;
      int                             c_int;
      long                            c_lng;
      long double                     c_lng_dbl;
      long long                       c_lng_lng;
      mulle_objc_methodid_t           c_sel;
      short                           c_sht;
      unsigned char                   c_uchr;
      unsigned int                    c_uint;
      unsigned long                   c_ulng;
      unsigned long long              c_ulng_lng;
      unsigned short                  c_usht;
      void                            *c_ptr;
   } v;

   type     = *p_type;
   p        = data.bytes;
   sentinel = &data.bytes[ data.length];

   switch( *type)
   {
   case _C_ID        :
   case _C_ASSIGN_ID :
   case _C_COPY_ID   :
   case _C_CLASS     :
      get_scalarvalue( v.c_id, id, p, sentinel);
      mulle_buffer_sprintf( buffer, "%s%@", sep, v.c_id);
      break;

   case _C_SEL     :
      get_scalarvalue( v.c_sel, SEL, p, sentinel);
      s = MulleObjCSelectorGetNameUTF8String( v.c_sel);
      mulle_buffer_sprintf( buffer, "%s@selector( %s)", sep, s);
      break;

   case _C_BOOL   :
      get_scalarvalue( v.c_bool, intptr_t, p, sentinel);
      mulle_buffer_sprintf( buffer, "%s%td", sep, v.c_bool);
      break;

   case _C_DBL   :
      get_scalarvalue( v.c_dbl, double, p, sentinel);
      mulle_buffer_sprintf( buffer, "%s%g", sep, v.c_dbl);
      break;

   case _C_FLT   :
      get_scalarvalue( v.c_flt, float, p, sentinel);
      mulle_buffer_sprintf( buffer, "%s%g", sep, v.c_flt);
      break;

   case _C_CHR   :
      get_scalarvalue( v.c_chr, char, p, sentinel);
      if( isprint( v.c_chr))
         mulle_buffer_sprintf( buffer, "%s'%c'", sep, v.c_chr);
      else
         mulle_buffer_sprintf( buffer, "%s'\\%03o'", sep, v.c_chr);
      break;

   case _C_INT   :
      get_scalarvalue( v.c_int, int, p, sentinel);
      mulle_buffer_sprintf( buffer, "%s%d", sep, v.c_int);
      break;

   case _C_LNG   :
      get_scalarvalue( v.c_lng, long, p, sentinel);
      mulle_buffer_sprintf( buffer, "%s%ld", sep, v.c_lng);
      break;

   case _C_LNG_LNG   :
      get_scalarvalue( v.c_lng_lng, long long, p, sentinel);
      mulle_buffer_sprintf( buffer, "%s%lld", sep, v.c_lng_lng);
      break;

   case _C_SHT   :
      get_scalarvalue( v.c_sht, short, p, sentinel);
      mulle_buffer_sprintf( buffer, "%s%d", sep, v.c_sht);
      break;

   case _C_UCHR   :
      get_scalarvalue( v.c_uchr, unsigned char, p, sentinel);
      mulle_buffer_sprintf( buffer, "%s%u", sep, v.c_uchr);
      break;

   case _C_UINT   :
      get_scalarvalue( v.c_uint, unsigned int, p, sentinel);
      mulle_buffer_sprintf( buffer, "%s%u", sep, v.c_uint);
      break;

   case _C_ULNG   :
      get_scalarvalue( v.c_ulng, unsigned long, p, sentinel);
      mulle_buffer_sprintf( buffer, "%s%lu", sep, v.c_ulng);
      break;

   case _C_ULNG_LNG   :
      get_scalarvalue( v.c_ulng_lng, unsigned long long, p, sentinel);
      mulle_buffer_sprintf( buffer, "%s%llu", sep, v.c_ulng_lng);
      break;

   case _C_USHT   :
      get_scalarvalue( v.c_usht, unsigned short, p, sentinel);
      mulle_buffer_sprintf( buffer, "%s%u", sep, v.c_usht);
      break;

   case _C_ATOM     :
   case _C_UNDEF    :
   case _C_VECTOR   :
   case _C_BFLD     :
   case _C_ARY_E    :
   case _C_STRUCT_E :   
   case _C_UNION_E  :   
      mulle_buffer_sprintf( buffer, "%s???", sep);
      return( NULL);

   case _C_VOID     :
      mulle_buffer_sprintf( buffer, "%s<void>", sep);
      break;

   case _C_PTR     :
      get_scalarvalue( v.c_ptr, void *, p, sentinel);
      mulle_buffer_sprintf( buffer, "%s%p", sep, v.c_ptr);
      break;

   case _C_CHARPTR :
      get_scalarvalue( v.c_charptr, char *, p, sentinel);
      mulle_buffer_sprintf( buffer, "%s%s", sep, v.c_charptr);
      break;

   case _C_STRUCT_B :
      do
         ++type;
      while( *type != '=');
      ++type; // skip =

      mulle_buffer_sprintf( buffer, "%s{", sep);
      sep = " ";
      n   = 0;
      while( *type != _C_STRUCT_E)
      {
         p = _MulleObjCDescribeMemory( buffer, 
                                       mulle_data_make( p, sentinel - p),
                                       &type, 
                                       sep);
         if( ! p)
            return( NULL);
         sep = ", ";
         n++;
      }

      mulle_buffer_add_string( buffer, n ? " }" : "}");
      break;

   case _C_UNION_B  :
      do
         ++type;
      while( *type != '=');
      ++type; // skip =

      mulle_buffer_sprintf( buffer, "%s(", sep);
      sep = " ";
      n   = 0;
      if( *type != _C_UNION_E)
      {
         p = _MulleObjCDescribeMemory( buffer, 
                                       mulle_data_make( p, sentinel - p),
                                       &type, 
                                       sep);
         if( ! p)
            return( NULL);
         sep = ", ";
         n   = 1;
      }

      while( *type != _C_UNION_E)
         ++type;
      mulle_buffer_add_string( buffer, n ? " )" : ")");
      break;

   case _C_ARY_B :
      ++type;
      n = atoi( type);
      while( *type >= '0' && *type <= '9')
         ++type;

      mulle_buffer_sprintf( buffer, "%s[", sep);
      for( sep = " ", i = 0; i < n; i++, sep = ", ")
      {
         element_type = type;
         p = _MulleObjCDescribeMemory( buffer, 
                                       mulle_data_make( p, sentinel - p),
                                       &element_type, 
                                       sep);
         if( ! p)
            return( NULL);
      }
      type = element_type;
      if( *type != _C_ARY_E)
      {
         mulle_buffer_sprintf( buffer, "%s???", sep);
         return( NULL);
      }
      mulle_buffer_add_string( buffer, n ? " ]" : "]");
      break;
   }

   *p_type = type + 1;
   return( p);
}


BOOL  MulleObjCDescribeMemory( struct mulle_buffer *buffer, 
                               struct mulle_data data,
                               char *type)
{
   size_t   memo;

   memo = mulle_buffer_get_length( buffer);
   if( _MulleObjCDescribeMemory( buffer, data, &type, ""))
      return( YES);

   mulle_buffer_set_length( buffer, memo);
   mulle_buffer_add_string( buffer, "<broken type>");
   return( NO);
}


/*
 *  MulleFoundation - the mulle-objc class library
 *
 *  NSObjectCArray.h is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
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

void   *MulleObjCClassGetName( Class cls)
{
   if( ! cls)
      return( NULL);

   return( _ns_string( _mulle_objc_class_get_name( cls)));
}


void   *MulleObjCSelectorGetName( SEL sel)
{
   char                                  *s;
   struct _mulle_objc_methoddescriptor   *desc;
   struct _mulle_objc_runtime            *runtime;
   
   runtime = mulle_objc_get_runtime();
   desc    = _mulle_objc_runtime_lookup_methoddescriptor( runtime, (mulle_objc_methodid_t) sel);
   s       = desc ? _mulle_objc_methoddescriptor_get_name( desc) : "<invalid selector>";
   
   return( _ns_string( s));
}


Class   MulleObjCLookupClassByName( id obj)
{
   char                         *s;
   struct _mulle_objc_runtime   *runtime;
   struct _mulle_objc_class     *cls;
   mulle_objc_classid_t         classid;
   
   if( ! obj)
      return( Nil);
   
   s       = _ns_characters( obj);
   classid = mulle_objc_classid_from_string( s);

   runtime = mulle_objc_get_runtime();
   cls     = _mulle_objc_runtime_lookup_class( runtime, classid);
   
   return( (Class) cls);
}


SEL   MulleObjCCreateSelector( id obj)
{
   char                    *s;
   mulle_objc_methodid_t   methodid;
   
   if( ! obj)
      return( 0);
   
   s        = _ns_characters( obj);
   methodid = mulle_objc_classid_from_string( s);
   
   return( (SEL) (uintptr_t) methodid);
}

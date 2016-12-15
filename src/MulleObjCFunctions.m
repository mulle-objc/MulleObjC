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

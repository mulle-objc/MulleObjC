//
//  NSDebug.m
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
#import "NSDebug.h"

// other files in this library
#include "ns_objc_type.h"
#include "ns_int_type.h"
#include "ns_rootconfiguration.h"

// std-c and dependencies


#pragma clang diagnostic ignored "-Wobjc-root-class"


char   *_NSPrintForDebugger( id a)
{
   IMP                         imp;
   char                        *aux;
   char                        *spacer;
   char                        buf[ 256];
   struct _mulle_objc_class    *cls;
   struct _mulle_objc_method   *m;

   if( ! a)
      return( mulle_allocator_strdup( &mulle_stdlib_allocator, "*nil*"));

   m   = 0;
   cls = _mulle_objc_object_get_isa( a);
   if( ! cls)
      return( mulle_allocator_strdup( &mulle_stdlib_allocator, "*not an object (anymore ?)*"));

   // typical "released" isa values
   if( cls == (void *) (intptr_t) 0xDEADDEADDEADDEAD || // our scribble
       cls == (void *) (intptr_t) 0xAAAAAAAAAAAAAAAA)   // malloc scribble
   {
      sprintf( buf, "<%p dealloced,(%p)>", a, cls);
      return( mulle_allocator_strdup( &mulle_stdlib_allocator, buf));  // hmm hmm, what's the interface here anyway ?
   }

   imp = (IMP) _mulle_objc_class_lookup_or_search_methodimplementation_no_forward( cls, @selector( debugDescription));
   if( imp)
   {
      void   *s;

      s = (*imp)( a, @selector( debugDescription), NULL);
      return( _ns_characters( s));
   }

   spacer = "";
   aux    = "";
   imp    = (IMP) _mulle_objc_class_lookup_or_search_methodimplementation_no_forward( cls, @selector( description));
   if( imp)
   {
      void   *s;

      s = (*imp)( a, @selector( description), NULL);
      if( s)
      {
         aux = _ns_characters( s);
         if( strlen( aux))
            spacer=" ";
      }
   }

   sprintf( buf, "<%p %.100s%s%.100s>", a, _mulle_objc_class_get_name( cls), spacer, aux);
   return( mulle_allocator_strdup( &mulle_stdlib_allocator, buf));  // hmm hmm, what's the interface here anyway ?
}


@interface _MulleObjCZombie
{
}
@end


@implementation _MulleObjCZombie

static char   zombie_format[] = "A deallocated object %p of %sclass \"%s\" was sent a \"%s\" message\n";

- (char *) _originalClassName
{
   return( _mulle_objc_class_get_name( _mulle_objc_object_get_isa( self)) + 11);
}


- (void) forward:(SEL) sel :(void *) _params
{
   int    isMeta;

   // possibly bullshit ;)
   isMeta = _mulle_objc_class_is_metaclass( _mulle_objc_object_get_isa( self));

   fprintf( stderr, zombie_format, self, isMeta ? "meta" : "", [self _originalClassName], mulle_objc_search_debughashname( (mulle_objc_methodid_t) sel));
   abort();
}


- (BOOL) respondsToSelector:(SEL) sel
{
   // for po basically
   return( sel == @selector( forward::));
}

@end



#define MULLE_ZOMBIE_HASH              0x057fc0af  // _MulleObjCZombie
#define MULLE_OBJC_LARGE_ZOMBIE_HASH   0xafb92130  // _MulleObjCLargeZombie


@interface _MulleObjCLargeZombie : _MulleObjCZombie
{
   Class   _originalClass;
}
@end



@implementation _MulleObjCLargeZombie

- (char *) _originalClassName
{
   return( _mulle_objc_infraclass_get_name( _originalClass));
}


static void   zombifyLargeObject( id obj)
{
   _MulleObjCLargeZombie   *zombie;
   Class                   cls;

   cls = mulle_objc_unfailing_lookup_infraclass( MULLE_OBJC_CLASSID( MULLE_OBJC_LARGE_ZOMBIE_HASH));
   assert( cls);

   zombie = obj;
   zombie->_originalClass = (Class) _mulle_objc_object_get_isa( obj);

   _mulle_objc_object_set_isa( obj, _mulle_objc_infraclass_as_class( cls));
}

@end


static void   zombifyObject( id obj)
{
   mulle_objc_classid_t           classid;
   static char                    buf[ 1024];
   struct _mulle_objc_classpair   *pair;
   struct _mulle_objc_infraclass  *cls;
   struct _mulle_objc_metaclass   *meta;
   struct _mulle_objc_infraclass  *infra;
   struct _mulle_objc_infraclass  *super_class;
   struct _mulle_objc_runtime     *runtime;

   if( ! obj)
      return;

   cls   = (struct _mulle_objc_infraclass *) _mulle_objc_object_get_isa( obj);
   if( _mulle_objc_class_is_metaclass( (void *) cls))
   {
      fprintf( stderr, "not zombiying class object %p\n", obj);
      abort();
   }
   
   runtime = _mulle_objc_infraclass_get_runtime( cls);

   sprintf( buf, "_MulleObjCZombieOf%.1000s", _mulle_objc_infraclass_get_name( cls));

   classid = mulle_objc_classid_from_string( buf);
   cls     = _mulle_objc_runtime_lookup_infraclass( runtime, classid);

   if( ! cls)
   {
      super_class = _mulle_objc_runtime_lookup_infraclass( runtime, MULLE_OBJC_CLASSID( MULLE_ZOMBIE_HASH));

      pair  = mulle_objc_unfailing_new_classpair( classid, buf, sizeof( id), super_class);
      infra = mulle_objc_classpair_get_infraclass( pair);
      meta  = mulle_objc_classpair_get_metaclass( pair);
      mulle_objc_infraclass_unfailing_add_methodlist( infra, NULL);
      mulle_objc_metaclass_unfailing_add_methodlist( meta, NULL);
      mulle_objc_runtime_unfailing_add_infraclass( runtime, infra);
   }
   
   _mulle_objc_object_set_isa( obj, _mulle_objc_infraclass_as_class( cls));
}


void   MulleObjCZombifyObject( id obj)
{
   struct _mulle_objc_class    *cls;
   size_t                      size;

   cls  = _mulle_objc_object_get_isa( obj);
   size = _mulle_objc_class_get_instancesize( cls);
   if( size >= sizeof( Class)) // sizeof( _MulleObjCLargeZombie)
   {
      zombifyLargeObject( obj);
      return;
   }

   zombifyObject( obj);
}

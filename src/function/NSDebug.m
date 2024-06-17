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
#define _GNU_SOURCE

#import "NSDebug.h"

#import "import-private.h"

// other files in this library
#include "mulle-objc-type.h"
#import "MulleObjCIntegralType.h"
#import "MulleObjCProtocol.h"
#import "MulleObjCUniverse.h"
#import "MulleObjCExceptionHandler.h"
#import "MulleObjCExceptionHandler-Private.h"
#import "mulle-objc-exceptionhandlertable-private.h"
#import "mulle-objc-universefoundationinfo-private.h"

#include <string.h>

// std-c and dependencies

//#define EPHEMERAL_SYMBOLIZER

#pragma clang diagnostic ignored "-Wobjc-root-class"



// unused symbols kept for compatibility
BOOL   NSKeepAllocationStatistics;


MULLE_C_CONST_RETURN
BOOL   MulleObjCIsDebugEnabled( void)
{
   struct _mulle_objc_universe   *universe;

   universe = mulle_objc_global_get_universe_inline( __MULLE_OBJC_UNIVERSEID__);
   return( _mulle_objc_universe_is_debugenabled( universe));
}


static char   *__MullePrintForDebugger( id a, char *buf)
{
   struct _mulle_objc_class   *cls;

   if( ! a)
      return( mulle_allocator_strdup( &mulle_stdlib_allocator, "*nil*"));

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

   cls = _mulle_objc_object_get_isa( a);
   if( ! cls)
      return( mulle_allocator_strdup( &mulle_stdlib_allocator, "*not an object (anymore ?)*"));

   return( NULL);
}


// this is useful, if you have a breakpoint in description
//
char   *_MullePrintForDebugger( id a)
{
   char                          buf[ 256];
   struct _mulle_objc_class      *cls;
   void                          *s;

   s = __MullePrintForDebugger( a, buf);
   if( s)
      return( s);

   cls = _mulle_objc_object_get_isa( a);
   sprintf( buf, "<%.200s %p>", _mulle_objc_class_get_name( cls), a);
   return( mulle_allocator_strdup( &mulle_stdlib_allocator, buf));  // hmm hmm, what's the interface here anyway ?
}


char   *_NSPrintForDebugger( id a)
{
   IMP                           imp;
   char                          *aux;
   char                          *spacer;
   char                          buf[ 256];
   struct _mulle_objc_class      *cls;
   struct _mulle_objc_universe   *universe;
   void                          *s;

   s = __MullePrintForDebugger( a, buf);
   if( s)
      return( s);

   cls      = _mulle_objc_object_get_isa( a);
   universe = _mulle_objc_class_get_universe( cls);

   imp = (IMP) _mulle_objc_class_lookup_implementation_noforward_nofill( cls, @selector( debugDescription));
   if( imp)
   {
      s = (*imp)( a, @selector( debugDescription), NULL);
      return( _mulle_objc_universe_characters( universe, s));
   }

   imp = (IMP) _mulle_objc_class_lookup_implementation_noforward_nofill( cls, @selector( UTF8String));
   if( imp)
   {
      s = (*imp)( a, @selector( UTF8String), NULL);
      return( s);
   }

   spacer = "";
   aux    = "";
   imp    = (IMP) _mulle_objc_class_lookup_implementation_noforward_nofill( cls, @selector( description));
   if( imp)
   {
      s = (*imp)( a, @selector( description), NULL);
      if( s)
      {
         aux      = _mulle_objc_universe_characters( universe, s);
         if( aux && strlen( aux))
            spacer=" ";
      }
   }

   sprintf( buf, "<%.100s %p%s%.100s>", _mulle_objc_class_get_name( cls), a, spacer, aux ? aux : "");
   return( mulle_allocator_strdup( &mulle_stdlib_allocator, buf));  // hmm hmm, what's the interface here anyway ?
}


@interface _MulleObjCZombie < MulleObjCThreadSafe>

- (BOOL) respondsToSelector:(SEL) sel     MULLE_OBJC_THREADSAFE_METHOD;

@end


@implementation _MulleObjCZombie

static char   zombie_format[] = "A deallocated object %p of %sclass \"%s\" was "
										  "sent a %x message (\"%s\")\n";

- (char *) _originalClassName
{
   return( _mulle_objc_class_get_name( _mulle_objc_object_get_isa( self)) + 11);
}


- (void) forward:(void *) _param
{
   int                          isMeta;
   struct _mulle_objc_universe  *universe;
   char                         *hashname;

   // possibly bullshit ;)
   isMeta   = _mulle_objc_class_is_metaclass( _mulle_objc_object_get_isa( self));
   universe = _mulle_objc_object_get_universe( self);
   hashname = _mulle_objc_universe_search_hashstring( universe,
  																	  (mulle_objc_methodid_t) _cmd);
   fprintf( stderr, zombie_format, self,
   										  isMeta ? "meta" : "",
   										  [self _originalClassName],
   										  (mulle_objc_methodid_t) _cmd,
   										  hashname ? hashname : "???");
   abort();
}


- (BOOL) respondsToSelector:(SEL) sel
{
   // for po basically
   return( sel == @selector( forward:));
}


#ifdef MULLE_OBJC_DEBUG_SUPPORT
//
// this should never be called
// it ensures, that the functions are present at debug time
//
+ (void) __reference_lldb_functions__
{
   extern void   mulle_objc_reference_lldb_functions( void);

   mulle_objc_reference_lldb_functions();
}


+ (void) __reference_gdb_functions__
{
   extern void   mulle_objc_reference_gdb_functions( void);

   mulle_objc_reference_gdb_functions();
}
#endif

@end


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


static void   zombifyLargeObject( id obj, int shred)
{
   _MulleObjCLargeZombie           *zombie;
   struct _mulle_objc_class        *cls;
   struct _mulle_objc_infraclass   *zombieCls;
   struct _mulle_objc_universe     *universe;

   universe  = _mulle_objc_object_get_universe( obj);
   zombieCls = mulle_objc_universe_lookup_infraclass_nofail( universe, @selector( _MulleObjCLargeZombie));
   assert( zombieCls);

   cls    = _mulle_objc_object_get_isa( obj);
   zombie = obj;
   zombie->_originalClass = (Class) cls;

   _mulle_objc_object_set_isa( obj, _mulle_objc_infraclass_as_class( zombieCls));
   if( shred)
      memset( &zombie->_originalClass + 1,
              0xad,
              _mulle_objc_class_get_instancesize( cls) - sizeof( Class));
}

@end


static void   zombifyObject( id obj, int shred)
{
   mulle_objc_classid_t            zombieClassid;
   char                            buf[ 256];
   struct _mulle_objc_classpair    *pair;
   struct _mulle_objc_class        *cls;
   struct _mulle_objc_infraclass   *zombieCls;
   struct _mulle_objc_metaclass    *meta;
   struct _mulle_objc_infraclass   *infra;
   struct _mulle_objc_infraclass   *super_class;
   struct _mulle_objc_universe     *universe;

   if( ! obj)
      return;

   cls = mulle_objc_object_get_isa( obj);
   if( _mulle_objc_class_is_metaclass( cls))
   {
      fprintf( stderr, "not zombifying class object %p\n", obj);
      abort();
   }

   universe = _mulle_objc_class_get_universe( cls);

   sprintf( buf, "_MulleObjCZombieOf%.200s", _mulle_objc_class_get_name( cls));

   zombieClassid = mulle_objc_classid_from_string( buf);
   zombieCls     = _mulle_objc_universe_lookup_infraclass( universe, zombieClassid);

   if( ! zombieCls)
   {
      super_class = _mulle_objc_universe_lookup_infraclass( universe, @selector( _MulleObjCZombie));

      pair  = mulle_objc_universe_new_classpair( universe, zombieClassid, buf, sizeof( id), 0, super_class);
      if( ! pair)
         mulle_objc_universe_fail_errno( universe);  // unfailing vectors through there

      infra = mulle_objc_classpair_get_infraclass( pair);
      meta  = mulle_objc_classpair_get_metaclass( pair);
      mulle_objc_infraclass_add_methodlist_nofail( infra, NULL);
      mulle_objc_metaclass_add_methodlist_nofail( meta, NULL);
      mulle_objc_infraclass_add_ivarlist_nofail( infra, NULL);
      mulle_objc_infraclass_add_propertylist_nofail( infra, NULL);
      mulle_objc_universe_add_infraclass_nofail( universe, infra);
   }

   _mulle_objc_object_set_isa( obj, _mulle_objc_infraclass_as_class( zombieCls));
   if( shred)
      memset( obj, 0xad, _mulle_objc_class_get_instancesize( cls));
}


void   _MulleObjCZombifyObject( id obj, int shred)
{
   struct _mulle_objc_class      *cls;
   size_t                        size;
   extern void _mulle_objc_object_trace_operation( void *obj, 
                                                   char *operation);
   assert( obj);

   cls = _mulle_objc_object_get_isa( obj);
   _mulle_objc_object_trace_operation( obj, "zombified");

   size = _mulle_objc_class_get_instancesize( cls);
   if( size >= sizeof( Class)) // sizeof( _MulleObjCLargeZombie)
      zombifyLargeObject( obj, shred);
   else
      zombifyObject( obj, shred);
}


void  MulleObjCCSVDumpMethodsToTmp( void)
{
   char                          *buf;
   char                          *name;
   char                          *tmp;
   char                          separator;
   FILE                          *fp;
   size_t                        len;
   struct _mulle_objc_universe   *universe;

   tmp =  _mulle_objc_get_tmpdir();

#ifdef _WIN32
    separator = '\\';
#else
    separator = '/';
#endif
   name = "objc-methods.csv";
   len  = strlen( name) + strlen( tmp) + 2;
   buf  = mulle_malloc(  len);
   sprintf( buf, "%s%c%s", tmp, separator, name);

   fp = fopen( buf, "w");
   if( fp)
   {
      universe   = mulle_objc_global_get_universe( __MULLE_OBJC_UNIVERSEID__);
      _mulle_objc_universe_csvdump_methods( universe, fp);
      fclose( fp);
   }
   mulle_free( buf);
}


/*
 * Stacktrace enhancer for testallocator
 * get a string to parse in 's', that is OS dependent AFAIK
 * get a buffer with len to snprintf into
 * get a non-null userinfo to store something into
 * s=NULL signals setup (*userinfo will be set to NULL) or teardown
 *
 * return s or buf, but nothing else
 */
char   *MulleObjCStacktraceSymbolize( void *address,
                                      size_t max,
                                      char *buf,
                                      size_t len,
                                      void **userinfo)
{
   struct mulle_objc_symbolizer                *symbolizer;
   struct _mulle_objc_universe                 *universe;
   struct _mulle_objc_universefoundationinfo   *info;

   assert( userinfo);

   symbolizer = *userinfo;

   // lazy init symbolizer (?)
   if( address == NULL)
   {
      if( symbolizer)
      {
#ifdef EPHEMERAL_SYMBOLIZER
         mulle_objc_symbolizer_destroy( symbolizer);
#endif
         *userinfo = NULL; // just in case...
         return( NULL);
      }

      universe = mulle_objc_global_get_universe( __MULLE_OBJC_UNIVERSEID__);
      if( _mulle_objc_universe_is_deinitializing( universe))
      {
         *userinfo = NULL; // just in case...
         return( NULL);
      }

#ifdef EPHEMERAL_SYMBOLIZER
      symbolizer = _mulle_objc_symbolizer_create( universe);
#else
      info       = _mulle_objc_universe_get_universefoundationinfo( universe);
      symbolizer = &info->debug.symbolizer;
      if( symbolizer->universe == NULL)
         _mulle_objc_symbolizer_init( symbolizer, universe);
#endif
      *userinfo  = symbolizer;

      return( NULL);
   }

   if( mulle_objc_symbolizer_snprint( symbolizer, address, max, buf, len) > 0)
      return( buf);

   return( NULL);
}


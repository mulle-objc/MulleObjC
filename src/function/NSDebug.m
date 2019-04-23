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

#import "import-private.h"

// other files in this library
#include "mulle-objc-type.h"
#import "MulleObjCIntegralType.h"
#import "MulleObjCExceptionHandler.h"
#import "MulleObjCExceptionHandler-Private.h"
#import "mulle-objc-exceptionhandlertable-private.h"
#import "mulle-objc-universefoundationinfo-private.h"
#include <mulle-objc-runtime/mulle-objc-dotdump.h>
#include <mulle-objc-runtime/mulle-objc-htmldump.h>
#include <mulle-objc-runtime/mulle-objc-symbolizer.h>

#include <string.h>

// std-c and dependencies


#pragma clang diagnostic ignored "-Wobjc-root-class"


MULLE_C_CONST_RETURN
BOOL   MulleObjCIsDebugEnabled( void)
{
   struct _mulle_objc_universe   *universe;

   universe = mulle_objc_global_inlineget_universe( __MULLE_OBJC_UNIVERSEID__);
   return( _mulle_objc_universe_is_debugenabled( universe));
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

   if( ! a)
      return( mulle_allocator_strdup( &mulle_stdlib_allocator, "*nil*"));

   cls = _mulle_objc_object_get_isa( a);
   if( ! cls)
      return( mulle_allocator_strdup( &mulle_stdlib_allocator, "*not an object (anymore ?)*"));

   universe = _mulle_objc_class_get_universe( cls);

   // typical "released" isa values
   if( cls == (void *) (intptr_t) 0xDEADDEADDEADDEAD || // our scribble
       cls == (void *) (intptr_t) 0xAAAAAAAAAAAAAAAA)   // malloc scribble
   {
      sprintf( buf, "<%p dealloced,(%p)>", a, cls);
      return( mulle_allocator_strdup( &mulle_stdlib_allocator, buf));  // hmm hmm, what's the interface here anyway ?
   }

   imp = (IMP) _mulle_objc_class_lookup_implementation_nocache_noforward( cls, @selector( cDebugDescription));
   if( imp)
   {
      s = (*imp)( a, @selector( cDebugDescription), NULL);
      return( s);
   }

   imp = (IMP) _mulle_objc_class_lookup_implementation_nocache_noforward( cls, @selector( debugDescription));
   if( imp)
   {
      s = (*imp)( a, @selector( debugDescription), NULL);
      return( _mulle_objc_universe_characters( universe, s));
   }

   imp = (IMP) _mulle_objc_class_lookup_implementation_nocache_noforward( cls, @selector( cStringDescription));
   if( imp)
   {
      s = (*imp)( a, @selector( cDebugDescription), NULL);
      return( s);
   }

   spacer = "";
   aux    = "";
   imp    = (IMP) _mulle_objc_class_lookup_implementation_nocache_noforward( cls, @selector( description));
   if( imp)
   {
      s = (*imp)( a, @selector( description), NULL);
      if( s)
      {
         aux = _mulle_objc_universe_characters( universe, s);
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

static char   zombie_format[] = "A deallocated object %p of %sclass \"%s\" was "
										  "sent a %x message (\"%s\")\n";

- (char *) _originalClassName
{
   return( _mulle_objc_class_get_name( _mulle_objc_object_get_isa( self)) + 11);
}


- (void) forward:(SEL) sel :(void *) _params
{
   int                          isMeta;
   struct _mulle_objc_universe  *universe;
   char                         *hashname;

   // possibly bullshit ;)
   isMeta   = _mulle_objc_class_is_metaclass( _mulle_objc_object_get_isa( self));
   universe = _mulle_objc_object_get_universe( self);
   hashname = _mulle_objc_universe_search_debughashname( universe,
   																	  (mulle_objc_methodid_t) sel);
   fprintf( stderr, zombie_format, self,
   										  isMeta ? "meta" : "",
   										  [self _originalClassName],
   										  (mulle_objc_methodid_t) sel,
   										  hashname ? hashname : "???");
   abort();
}


- (BOOL) respondsToSelector:(SEL) sel
{
   // for po basically
   return( sel == @selector( forward:));
}

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


static void   zombifyLargeObject( id obj)
{
   _MulleObjCLargeZombie        *zombie;
   Class                        cls;
   struct _mulle_objc_universe  *universe;

   universe = _mulle_objc_object_get_universe( obj);
   cls      = _mulle_objc_universe_lookup_infraclass_nofail( universe, @selector( _MulleObjCLargeZombie));
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
   struct _mulle_objc_universe     *universe;

   if( ! obj)
      return;

   cls   = (struct _mulle_objc_infraclass *) _mulle_objc_object_get_isa( obj);
   if( _mulle_objc_class_is_metaclass( (void *) cls))
   {
      fprintf( stderr, "not zombiying class object %p\n", obj);
      abort();
   }

   universe = _mulle_objc_infraclass_get_universe( cls);

   sprintf( buf, "_MulleObjCZombieOf%.1000s", _mulle_objc_infraclass_get_name( cls));

   classid = mulle_objc_classid_from_string( buf);
   cls     = _mulle_objc_universe_lookup_infraclass( universe, classid);

   if( ! cls)
   {
      super_class = _mulle_objc_universe_lookup_infraclass( universe, @selector( _MulleObjCZombie));

      pair  = mulle_objc_universe_new_classpair( universe, classid, buf, sizeof( id), 0, super_class);
      if( ! pair)
         mulle_objc_universe_fail_errno( universe);  // unfailing vectors through there

      infra = mulle_objc_classpair_get_infraclass( pair);
      meta  = mulle_objc_classpair_get_metaclass( pair);
      mulle_objc_infraclass_add_methodlist_nofail( infra, NULL);
      mulle_objc_metaclass_add_methodlist_nofail( meta, NULL);
      mulle_objc_universe_add_infraclass_nofail( universe, infra);
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


static char   *_mulle_objc_get_tmpdir( void)
{
   char  *s;

   s = getenv( "TMPDIR");
   if( s)
      return( s);
   s = getenv( "TMP");
   if( s)
      return( s);
   s = getenv( "TEMP");
   if( s)
      return( s);
   s = getenv( "TEMPDIR");
   if( s)
      return( s);

#ifdef _WIN32
   return( ".");
#else
   return( "/tmp");
#endif
}



#pragma mark - dreaded conveniences


void   MulleObjCHTMLDumpUniverseToDirectory( char *directory)
{
   struct _mulle_objc_universe   *universe;

   universe = MulleObjCGetUniverse();
   mulle_objc_universe_htmldump_to_directory( universe, directory);
}


void   MulleObjCHTMLDumpUniverseToTmp( void)
{
   struct _mulle_objc_universe   *universe;
   char                          *tmp;

   universe = MulleObjCGetUniverse();
   tmp      = _mulle_objc_get_tmpdir();
   mulle_objc_universe_htmldump_to_directory( universe, tmp);
}


void   MulleObjCHTMLDumpUniverse( void)
{
   struct _mulle_objc_universe   *universe;

   universe = MulleObjCGetUniverse();
   mulle_objc_universe_htmldump_to_directory( universe, ".");
}


void   MulleObjCHTMLDumpClassToDirectory( char *classname, char *directory)
{
   struct _mulle_objc_universe    *universe;
   struct _mulle_objc_class       *cls;
   struct _mulle_objc_infraclass  *infra;
   mulle_objc_classid_t           classid;

   if( ! classname || ! *classname)
   {
      fprintf( stderr, "Invalid classname\n");
      return;
   }

   universe = MulleObjCGetUniverse();
   classid  = mulle_objc_classid_from_string( classname);
   infra    = _mulle_objc_universe_lookup_infraclass( universe, classid);
   if( ! infra)
   {
      fprintf( stderr, "Class \"%s\" is unknown to the universe\n", classname);
      return;
   }

   cls = _mulle_objc_infraclass_as_class( infra);
   mulle_objc_class_htmldump_to_directory( cls, directory);
}


void   MulleObjCHTMLDumpClass( char *classname)
{
   MulleObjCHTMLDumpClassToDirectory( classname, ".");
}


void   MulleObjCHTMLDumpClassToTmp( char *classname)
{
   char   *tmp;

   tmp = _mulle_objc_get_tmpdir();
   MulleObjCHTMLDumpClassToDirectory( classname, tmp);
}




#pragma mark - conveniences


void   MulleObjCDotdumpUniverseToTmp()
{
   struct _mulle_objc_universe *universe;
   char                        *tmp;

   universe = MulleObjCGetUniverse();
   tmp      = _mulle_objc_get_tmpdir();
   mulle_objc_universe_dotdump_to_directory( universe, tmp);
}


void   MulleObjCDotdumpClassToTmp( struct _mulle_objc_class *cls)
{
   char   *tmp;

   tmp = _mulle_objc_get_tmpdir();
   mulle_objc_class_dotdump_to_directory( cls, tmp);
}


void   MulleObjCDotdumpUniverseFrameToTmp()
{
   struct _mulle_objc_universe   *universe;
   char                          *tmp;

   universe = MulleObjCGetUniverse();
   tmp       = _mulle_objc_get_tmpdir();
   mulle_objc_universe_dotdump_frame_to_directory( universe, tmp);
}


void   MulleObjCDotdumpUniverse( void)
{
   struct _mulle_objc_universe   *universe;

   universe = MulleObjCGetUniverse();
   mulle_objc_universe_dotdump_to_directory( universe, ".");
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
   struct mulle_objc_symbolizer   *symbolizer;
   struct _mulle_objc_universe    *universe;

   assert( userinfo);

   symbolizer = *userinfo;
   if( address == NULL)
   {
      if( symbolizer)
      {
         mulle_objc_symbolizer_destroy( symbolizer);
         *userinfo = NULL; // just in case...
         return( NULL);
      }

      universe   = mulle_objc_global_get_universe( __MULLE_OBJC_UNIVERSEID__);
      symbolizer = _mulle_objc_symbolizer_create( universe);
      *userinfo  = symbolizer;
      return( NULL);
   }


   if( mulle_objc_symbolizer_snprint( symbolizer, address, max, buf, len) > 0)
      return( buf);

   return( NULL);
}


void  MulleObjCCSVDumpMethodsToTmp( void)
{
   char                          *tmp;
   char                          *buf;
   size_t                        len;
   char                          separator;
   char                          *name;
   FILE                          *fp;
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
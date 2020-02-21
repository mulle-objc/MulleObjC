//
//  mulle-objc-rootconfiguration.m
//  MulleObjC
//
//  Copyright (c) 2016 Nat! - Mulle kybernetiK.
//  Copyright (c) 2016 Codeon GmbH.
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

// this is the only file that has an __attribute__ constructor
// this links in all the roots stuff into the universe
#define _GNU_SOURCE  1  // hmm, needed for Linux dlcfn have to do this first

#import "import-private.h"

#import <assert.h>

#import "mulle-objc-type.h"
#import "MulleObjCIntegralType.h"
#import "MulleObjCExceptionHandler.h"
#import "MulleObjCExceptionHandler-Private.h"
#import "MulleObjCContainerCallback.h"
#import "NSRange.h"
#import "NSDebug.h"
#import "NSThread.h"

#import "mulle-objc-universeconfiguration-private.h"
#import "mulle-objc-universefoundationinfo-private.h"

// TODO: move this to include_private.h
#import <mulle-objc-list/mulle-objc-list.h>
#import <mulle-objc-runtime/mulle-objc-csvdump.h>

#import "version.h"

// clang speciality
#ifdef __has_include
# if __has_include( <dlfcn.h>)
#  include <dlfcn.h>
#  define HAVE_DLSYM  1
# endif
#endif


# pragma clang diagnostic ignored "-Wparentheses"

# pragma mark -
# pragma mark Configuration of the North Shore

void   mulle_objc_teardown_universe( struct _mulle_objc_universe *universe)
{
   void   _MulleThreadResignAsMainThreadObjectInUniverse( struct _mulle_objc_universe *universe);
   int    trace;
   char   *filename;

   trace = mulle_objc_environment_get_yes_no( "MULLE_OBJC_TRACE_UNIVERSE");
   if( trace)
      mulle_objc_universe_trace( universe, "teardown of the universe in progress");

   if( mulle_objc_environment_get_yes_no( "MULLE_OBJC_COVERAGE"))
   {
      mulle_objc_universe_trace( universe, "writing coverage files...");

      filename = getenv( "MULLE_OBJC_CLASS_CACHESIZES_FILENAME");
      if( ! filename)
         filename = "class-cachesizes.csv";
      mulle_objc_universe_csvdump_cachesizes_to_filename( universe, filename);

      filename = getenv( "MULLE_OBJC_METHOD_COVERAGE_FILENAME");
      if( ! filename)
         filename = "method-coverage.csv";
      mulle_objc_universe_csvdump_methodcoverage_to_filename( universe, filename);

      filename = getenv( "MULLE_OBJC_CLASS_COVERAGE_FILENAME");
      if( ! filename)
         filename = "class-coverage.csv";
      mulle_objc_universe_csvdump_classcoverage_to_filename( universe, filename);
   }
}


static void   foundationinfo_finalize( struct _mulle_objc_universe *universe,
                                       void *info,
                                       enum mulle_objc_finalize_stage stage)
{
   struct _mulle_objc_universefoundationinfo   *space;

   _mulle_objc_universe_get_foundationspace( universe, (void **) &space, NULL);

   switch( stage)
   {
   //
   // this will call mulle_objc_teardown_universe as that is the
   // teardown_callback in info
   //
   case mulle_objc_will_finalize :
      _mulle_objc_universefoundationinfo_willfinalize( info);
      break;

   case mulle_objc_finalize      :
      _mulle_objc_universefoundationinfo_finalize( info);
      break;
   }
}


static void   foundationinfo_done( struct _mulle_objc_universe *universe,
                                      void *info)
{
   struct _mulle_objc_universefoundationinfo   *space;

   _mulle_objc_universe_get_foundationspace( universe, (void **) &space, NULL);
   _mulle_objc_universefoundationinfo_done( info);

   if( info != space)
   {
      if( universe->debug.trace.universe)
          mulle_objc_universe_trace( universe, "free foundationinfo");
      mulle_free( info);
   }
}



static void   nop( struct _mulle_objc_universe *universe,
                   void *friend,
                   struct mulle_objc_loadversion *info)
{
}



//
// find leaks of universe after it shut down
//
static void   reset_testallocator( struct _mulle_objc_universe *universe)
{
   void   (*mulle_testallocator_reset)( void);

#if HAVE_DLSYM
   mulle_testallocator_reset = dlsym( RTLD_DEFAULT, "mulle_testallocator_reset");
   if( mulle_testallocator_reset)
      (*mulle_testallocator_reset)();
#endif
}


struct _mulle_objc_universefoundationinfo  *
   _mulle_objc_universeconfiguration_configure_universe( struct _mulle_objc_universeconfiguration *config,
                                                         struct _mulle_objc_universe *universe)
{
   size_t                                      size;
   size_t                                      neededsize;
   struct mulle_allocator                      *allocator;
   struct _mulle_objc_foundation               foundation;
   struct _mulle_objc_universefoundationinfo   *roots;
   char                                        *kind;

   _mulle_objc_universe_defaultbang( universe,  config->universe.allocator, NULL);

   universe->classdefaults.inheritance   = MULLE_OBJC_CLASS_DONT_INHERIT_PROTOCOL_CATEGORIES;
   universe->classdefaults.forwardmethod = config->universe.forward;
   universe->failures.uncaughtexception  = (void (*)()) config->universe.uncaughtexception;

   neededsize = config->foundation.configurationsize;
   if( ! neededsize)
      neededsize = sizeof( struct _mulle_objc_universefoundationinfo);

   _mulle_objc_universe_get_foundationspace( universe, (void **) &roots, &size);
   if( size < neededsize)
      roots = mulle_malloc( neededsize);

   _mulle_objc_universefoundationinfo_init( roots,
                                            universe,
                                            config->universe.allocator,
                                            &config->foundation.exceptiontable);

   roots->teardown_callback                        = config->callbacks.teardown;
   foundation.universefriend.data                  = roots;
   foundation.staticstringclass                    = config->universe.staticstringclass;
   foundation.universefriend.finalizer             = foundationinfo_finalize;
   foundation.universefriend.destructor            = foundationinfo_done;
   foundation.universefriend.threadinfoinitializer = config->universe.threadinfoinitializer
                                                     ? config->universe.threadinfoinitializer
                                                     : _mulle_objc_threadinfo_initializer;
   foundation.universefriend.versionassert         = config->universe.versionassert
                                        ? config->universe.versionassert
                                        : nop;
   foundation.rootclassid = @selector( NSObject);
   allocator              = config->foundation.objectallocator;

   kind = "custom";
   if( ! allocator)
   {
      if( mulle_objc_environment_get_yes_no( "MULLE_OBJC_FOUNDATION_STDLIB_ALLOCATOR"))
      {
         allocator = &mulle_stdlib_allocator;
         kind      = "stdlib";
      }
      else
      {
         allocator = &mulle_default_allocator;
         kind      = "default";
      }
   }
   if( universe->debug.trace.universe)
      mulle_objc_universe_trace( universe, "foundation uses %s allocator: %p", kind, allocator);

   foundation.allocator  = *allocator;

   _mulle_objc_universe_set_foundation( universe, &foundation);

   return( roots);
}


/*
 *
 */
static void   versionassert( struct _mulle_objc_universe *universe,
                             void *friend,
                             struct mulle_objc_loadversion *version)
{
   if( (version->foundation & ~0xFF) != (MULLE_OBJC_VERSION & ~0xFF))
      mulle_objc_universe_fail_inconsistency( universe,
          "mulle_objc_universe %p: foundation version set to %x but "
          "universe foundation is %x",
          universe,
          version->foundation,
          MULLE_OBJC_VERSION);
}


# pragma mark -
# pragma mark Exceptions

static void  perror_abort( char *s)
{
   perror( s);
   abort();
}


void   *__mulle_objc_forwardcall( void *self, mulle_objc_methodid_t _cmd, void *_param);

void   *__mulle_objc_forwardcall( void *self, mulle_objc_methodid_t _cmd, void *_param)
{
   struct _mulle_objc_universe   *universe;
   struct _mulle_objc_class      *cls;

   cls      = _mulle_objc_object_get_isa( self);
   universe = _mulle_objc_class_get_universe( cls);
   mulle_objc_universe_fail_methodnotfound( universe, cls, _cmd);
   return( NULL);
}


struct _mulle_objc_method   NSObject_msgForward_method =
{
   {
      MULLE_OBJC_FORWARD_METHODID,  // forward:
      "forward:",
      "@@:@",
      0
   },
   {
      __mulle_objc_forwardcall
   }
};


static void   *return_self( void *p)
{
   return( p);
}


void  mulle_objc_postcreate_universe( struct _mulle_objc_universe  *universe)
{
   struct _mulle_objc_universefoundationinfo   *rootconfig;
   int                                         coverage;
   BOOL                                        objcTestAllocatorEnabled;

   rootconfig = _mulle_objc_universe_get_foundationdata( universe);

   // just little hacks
   rootconfig->string.charsfromobject = (char *(*)()) return_self;
   rootconfig->string.objectfromchars = (void *(*)()) return_self;

   // needed for coverage, slows things down a bit and bloats caches
   coverage                           = mulle_objc_environment_get_yes_no( "MULLE_OBJC_COVERAGE");
   universe->config.repopulate_caches = coverage;
   if( coverage)
      fprintf( stderr, "mulle-objc: coverage files will be written at exit\n");

   //
   // printing stuck classes is helpful to generate extended coverage
   // for un-optimizable libraries. Stuck categories probably
   // not so much though
   //
   universe->debug.print.stuck_class_coverage = coverage;

   mulle_objc_list_install_hook( universe);

   objcTestAllocatorEnabled = mulle_objc_environment_get_yes_no( "MULLE_OBJC_TESTALLOCATOR_ENABLED");
   if( objcTestAllocatorEnabled || mulle_objc_environment_get_yes_no( "MULLE_TESTALLOCATOR"))
   {
      void   (*mulle_testallocator_set_stacktracesymbolizer)( void (*)( void));

#if HAVE_DLSYM
      mulle_testallocator_set_stacktracesymbolizer = dlsym( RTLD_DEFAULT, "mulle_testallocator_set_stacktracesymbolizer");
      if( mulle_testallocator_set_stacktracesymbolizer)
         mulle_testallocator_set_stacktracesymbolizer( (void (*)(void)) MulleObjCStacktraceSymbolize);
#endif
   }

   // TODO: this isn't currently used at all, since tests use
   // MULLE_TESTALLOCATOR
   if( objcTestAllocatorEnabled)
      universe->callbacks.did_crunch = reset_testallocator;
}


// a rare case of const use :)
const struct _mulle_objc_universeconfiguration   *
   mulle_objc_global_get_default_universeconfiguration( void)
{
   static const struct _mulle_objc_universeconfiguration   setup =
   {
      {
         NULL,
         versionassert,
         &NSObject_msgForward_method,
         NULL,       // static string class
         NULL,
         NULL
      },
      {
         sizeof( struct _mulle_objc_universeconfiguration),
         NULL,
         { // exception vectors
            (void (*)()) perror_abort,
            (void (*)()) abort,
            (void (*)()) abort,
            (void (*)()) abort,
            (void (*)()) abort
         }
      },
      {
         (void (*)()) _mulle_objc_universeconfiguration_configure_universe,
         mulle_objc_postcreate_universe,
         mulle_objc_teardown_universe
      }
   };

   return( &setup);
}


//
// this is being called via bang
// it will eventually vector through to _mulle_objc_universeconfig_setup_universe
// unless someone "above" changes that
//
void   mulle_objc_universe_configure( struct _mulle_objc_universe *universe,
                                      struct _mulle_objc_universeconfiguration *setup)
{
   if( ! _mulle_objc_universe_is_transitioning( universe))
   {
      if( _mulle_objc_universe_is_initialized( universe))
         fprintf( stderr, "The universe %p is already initialized. Do not call "
                          "\"mulle_objc_universe_setup\" twice.\n", universe);
      else
         fprintf( stderr, "Do not call \"mulle_objc_universe_setup\" directly, "
                          "call it via _mulle_objc_universe_bang. (%d)\n",
                          _mulle_objc_universe_get_version( universe));
      abort();
   }

   (*setup->callbacks.setup)( setup, universe);
   (*setup->callbacks.postcreate)( universe);
}

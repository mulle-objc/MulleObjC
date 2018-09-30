//
//  mulle-objc_rootconfiguration.m
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
#import "NSRange.h"

#import "mulle-objc-testallocator-private.h"
#import "mulle-objc-universeconfiguration-private.h"
#import "mulle-objc-universefoundationinfo-private.h"

// TODO: move this to include_private.h
#import <mulle-objc-list/mulle-objc-list.h>
#import <mulle-objc-runtime/mulle-objc-csvdump.h>

#import "version.h"

# pragma clang diagnostic ignored "-Wparentheses"



# pragma mark -
# pragma mark Configuration of the North Shore

static void   universe_dies( struct _mulle_objc_universe *universe, void *data)
{
   struct _mulle_objc_universefoundationinfo   *config;

   _mulle_objc_universe_get_foundationspace( universe, (void **) &config, NULL);

   if( universe->debug.trace.universe)
       mulle_objc_universe_trace( universe, "release placeholders");
   mulle_set_destroy( config->object.placeholders);

   if( universe->debug.trace.universe)
       mulle_objc_universe_trace( universe, "release singletons");
   mulle_set_destroy( config->object.singletons);

   if( universe->debug.trace.universe)
       mulle_objc_universe_trace( universe, "release root objects");
   mulle_set_destroy( config->object.roots);

   if( universe->debug.trace.universe)
       mulle_objc_universe_trace( universe, "release thred objects");
   mulle_set_destroy( config->object.threads);

   if( universe->debug.trace.universe)
       mulle_objc_universe_trace( universe, "release foundationinfo");
   if( data != config)
      free( data);
}


static void  *describe_object( struct mulle_container_keycallback *callback,
                               void *p,
                               struct mulle_allocator *allocator)
{
   // we have no strings yet, someone should patch mulle_allocator_objc
   // use _mulle_objc_string here ???
   return( NULL);
}


static const struct mulle_container_keycallback
   object_container_keycallback =
{
   mulle_container_keycallback_pointer_hash,
   mulle_container_keycallback_pointer_is_equal,
   (void *(*)()) mulle_container_callback_self,
   (void (*)()) mulle_container_callback_nop,
   describe_object,

   NULL,
   NULL
};


static void   nop( struct _mulle_objc_universe *universe,
                   void *friend,
                   struct mulle_objc_loadversion *info)
{
}


/*
 * This function sets up a Foundation on a per thread
 * basis.
 */
void
   _mulle_objc_universeconfigurationinfo_init( struct _mulle_objc_universefoundationinfo *info,
                                               struct _mulle_objc_universe *universe,
                                               struct mulle_allocator *allocator,
                                               struct _mulle_objc_exceptionhandlertable *exceptiontable)
{
   info->universe            = universe;

   /* the callback is copied anyway, but the allocator needs to be stored
      in the config. It's OK to have a different allocator for Foundation
      then for the universe. The info->allocator is used to create instances.
    */

   info->exception.vectors   = *exceptiontable;

   info->object.roots        = mulle_set_create( 32,
                                                  (void *) &object_container_keycallback,
                                                  allocator);
   info->object.singletons   = mulle_set_create( 8,
                                                  (void *) &object_container_keycallback,
                                                  allocator);
   info->object.placeholders = mulle_set_create( 32,
                                                  (void *) &object_container_keycallback,
                                                  allocator);
   info->object.threads      = mulle_set_create( 4,
                                                  (void *) &object_container_keycallback,
                                                  allocator);


   info->object.debugenabled      = mulle_objc_environment_get_yes_no( "MULLE_OBJC_DEBUG_ENABLED") ||
         mulle_objc_environment_get_yes_no( "NSDebugEnabled");
   info->object.zombieenabled     = mulle_objc_environment_get_yes_no( "MULLE_OBJC_ZOMBIE_ENABLED") ||
         mulle_objc_environment_get_yes_no( "NSZombieEnabled");
   info->object.deallocatezombies = mulle_objc_environment_get_yes_no( "MULLE_OBJC_DEALLOCATE_ZOMBIE") ||
         mulle_objc_environment_get_yes_no( "NSDeallocateZombies");
}

struct _mulle_objc_universefoundationinfo  *
   _mulle_objc_universeconfiguration_configure_universe( struct _mulle_objc_universeconfiguration *config,
                                                         struct _mulle_objc_universe *universe)
{
   size_t                                      size;
   size_t                                      neededsize;
   struct mulle_allocator                      *allocator;
   struct _mulle_objc_foundation               us;
   struct _mulle_objc_universefoundationinfo   *roots;

   _mulle_objc_universe_init( universe, config->universe.allocator);

   universe->classdefaults.inheritance   = MULLE_OBJC_CLASS_DONT_INHERIT_PROTOCOL_CATEGORIES;
   universe->classdefaults.forwardmethod = config->universe.forward;
   universe->failures.uncaughtexception  = (void (*)()) config->universe.uncaughtexception;

   neededsize = config->foundation.configurationsize;
   if( ! neededsize)
      neededsize = sizeof( struct _mulle_objc_universefoundationinfo);

   _mulle_objc_universe_get_foundationspace( universe, (void **) &roots, &size);
   if( size < neededsize)
   {
      roots = (*config->universe.allocator->calloc)( 1, neededsize);
      if( ! roots)
         mulle_objc_universe_fail_errno( universe);
   }

   _mulle_objc_universeconfigurationinfo_init( roots,
                                               universe,
                                               config->universe.allocator,
                                               &config->foundation.exceptiontable);

   us.universefriend.data          = roots;
   us.universefriend.destructor    = universe_dies;
   us.universefriend.versionassert = config->universe.versionassert
                                        ? config->universe.versionassert
                                        : nop;
   us.rootclassid                  = @selector( NSObject);

   allocator    = config->foundation.objectallocator
                     ? config->foundation.objectallocator
                     : &mulle_default_allocator;

   us.allocator = *allocator;

   _mulle_objc_universe_set_foundation( universe, &us);

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



void   mulle_objc_teardown_universe( struct _mulle_objc_universe *universe)
{
   void  _NSThreadResignAsMainThreadObject( struct _mulle_objc_universe *universe);
   int   trace;
   char   *filename;

   trace = mulle_objc_environment_get_yes_no( "MULLE_OBJC_TRACE_UNIVERSE");
   if( trace)
      fprintf( stderr, "mulle-objc: mulle_objc_teardown_universe %p in progress\n", universe);

   if( mulle_objc_environment_get_yes_no( "MULLE_OBJC_COVERAGE"))
   {
      fprintf( stderr, "mulle-objc: writing coverage files...\n");

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

  // this is called by _NSThreadResignAsMainThreadObject:  mulle_objc_release_universe
   _NSThreadResignAsMainThreadObject( universe);
}


//
// atexit method (THIS IS A DUPLICATE NOW OF THE BUILTIN CODE)
// remove this
//
static void   teardown_objc( void)
{
   struct _mulle_objc_universe  *universe;

   universe = __mulle_objc_global_get_defaultuniverse();
   if( ! universe)
      return;

   if( _mulle_objc_universe_is_initialized( universe))
   {
      if( universe->debug.trace.universe)
            mulle_objc_universe_trace( universe, "atexit tears down the universe");
      mulle_objc_teardown_universe( universe);
   }
   else
      if( universe->debug.trace.universe)
         mulle_objc_universe_trace( universe,
                                    "atexit skips teardown of uninitialized universe");

   if( mulle_objc_environment_get_yes_no( "MULLE_OBJC_TESTALLOCATOR"))
      mulle_objc_testallocator_reset();
}



static void   *return_self( void *p)
{
   return( p);
}


static void  universe_postcreate( struct _mulle_objc_universe  *universe)
{
   struct _mulle_objc_universefoundationinfo   *rootconfig;
   int                             coverage;

   rootconfig = _mulle_objc_universe_get_foundationdata( universe);

   rootconfig->string.charsfromobject = (char *(*)()) return_self;
   rootconfig->string.objectfromchars = (void *(*)()) return_self;

   // needed for coverage, slows things down a bit and bloats caches
   coverage = mulle_objc_environment_get_yes_no( "MULLE_OBJC_COVERAGE");
   universe->config.repopulate_caches = coverage;
   if( coverage)
      fprintf( stderr, "mulle-objc: coverage files will be written at exit\n");

   //
   // printing stuck classes is helpful to generate extended coverage
   // for un-optimizable libraries. Stuck categories probably
   // not so much though
   //
   universe->debug.print.stuck_class_coverage = coverage;
}


extern struct mulle_allocator   mulle_allocator_objc;
extern struct mulle_allocator   mulle_objc_testallocator;


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
         NULL,
      },
      {
         sizeof( struct _mulle_objc_universeconfiguration),
         &mulle_allocator_objc,
         { // exception vectors
            (void (*)()) perror_abort,
            (void (*)()) abort,
            (void (*)()) abort,
            (void (*)()) abort,
            (void (*)()) abort,
            (void (*)()) abort
         }
      },
      {
         (void (*)()) _mulle_objc_universeconfiguration_configure_universe,
         teardown_objc,
         universe_postcreate
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
   int   is_pedantic;
   int   is_test;
   int   is_coverage;

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

   is_pedantic = mulle_objc_environment_get_yes_no( "MULLE_OBJC_PEDANTIC_EXIT");
   is_test     = mulle_objc_environment_get_yes_no( "MULLE_OBJC_TESTALLOCATOR");
   is_coverage = mulle_objc_environment_get_yes_no( "MULLE_OBJC_COVERAGE");

   if( is_test)
   {
      // call this because we are probably also in +load here
      mulle_objc_testallocator_initialize();

      //
      // in case of leaks, getting traces of universe allocatios can be
      // tedious. Assuming universe is leak free, run with a test
      // allocator for objects only (MULLE_OBJC_TESTALLOCATOR=1)
      //
      if( is_test & 0x1)
         setup->foundation.objectallocator = &mulle_objc_testallocator;
      if( is_test & 0x2)
         setup->universe.allocator          = &mulle_objc_testallocator;
#if DEBUG
      if( is_test & 0x3)
         fprintf( stderr, "MulleObjC uses \"mulle_objc_testallocator\" to detect leaks.\n");
#endif
   }

   (*setup->callbacks.setup)( setup, universe);
   (*setup->callbacks.postcreate)( universe);

   if( is_pedantic || is_test || is_coverage)
   {
      struct _mulle_objc_universefoundationinfo *rootcfg;

      rootcfg = _mulle_objc_universe_get_foundationdata( universe);

      // if we retain zombies, we leak, so no point in looking for leaks
      if( rootcfg->object.zombieenabled && ! rootcfg->object.deallocatezombies)
         is_test = 0;

      if( universe->debug.trace.universe)
         fprintf( stderr, "mulle-objc: install atexit handler for universe crunch...\n");

      if( atexit( setup->callbacks.teardown))
         perror( "atexit:");
   }

   mulle_objc_list_install_hook( universe);
}

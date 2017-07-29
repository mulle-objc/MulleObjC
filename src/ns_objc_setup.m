//
//  ns_objc_setup.m
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

#define _GNU_SOURCE  1  // hmm, needed for Linux dlcfn have to do this first

#include "ns_objc_setup.h"

#include "ns_rootconfiguration.h"
#include "ns_test_allocation.h"
#include <mulle_objc_runtime/mulle_objc_csvdump.h>
#include <mulle_objc_list/mulle_objc_list.h>



// std-c and dependencies

static void   versionassert( struct _mulle_objc_universe *universe,
                            void *friend,
                            struct mulle_objc_loadversion *version)
{
   if( (version->foundation & ~0xFF) != (MULLE_OBJC_VERSION & ~0xFF))
      _mulle_objc_universe_raise_inconsistency_exception( universe, "mulle_objc_universe %p: foundation version set to %x but universe foundation is %x",
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


/*
 * it's just too convenient, to have this as the old name (really ?)
 */
void   *__forward_mulle_objc_object_call( void *self, mulle_objc_methodid_t _cmd, void *_param);

void   *__forward_mulle_objc_object_call( void *self, mulle_objc_methodid_t _cmd, void *_param)
{
   struct _mulle_objc_class   *cls;

   cls = _mulle_objc_object_get_isa( self);
   _mulle_objc_class_raise_method_not_found_exception( cls, _cmd);
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
      __forward_mulle_objc_object_call
   }
};



void   ns_objc_universe_tear_down()
{
   void  _NSThreadResignAsMainThread( void);
   int   trace;
   
   trace = mulle_objc_getenv_yes_no( "MULLE_OBJC_TRACE_UNIVERSE");
   if( trace)
      fprintf( stderr, "mulle-objc: ns_objc_universe_tear_down in progress\n");
   
   if( mulle_objc_getenv_yes_no( "MULLE_OBJC_COVERAGE"))
   {
      fprintf( stderr, "mulle-objc: writing coverage files...\n");
      
      mulle_objc_csvdump_methodcoverage();
      mulle_objc_csvdump_classcoverage();
      mulle_objc_csvdump_cachesizes();
   }
   
  // this is called by _NSThreadResignAsMainThread:  mulle_objc_release_universe
   _NSThreadResignAsMainThread();
}


static void tear_down()
{
   ns_objc_universe_tear_down();

   if( mulle_objc_getenv_yes_no( "MULLE_OBJC_TEST_ALLOCATOR"))
      mulle_test_allocator_objc_reset();
}


static void   *return_self( void *p)
{
   return( p);
}


static void  post_create( struct _mulle_objc_universe  *universe)
{
   struct _ns_rootconfiguration   *rootconfig;
   int                             coverage;
   
   rootconfig = _mulle_objc_universe_get_foundationdata( universe);

   rootconfig->string.charsfromobject = (char *(*)()) return_self;
   rootconfig->string.objectfromchars = (void *(*)()) return_self;

   // needed for coverage, slows things down a bit and bloats caches
   coverage = mulle_objc_getenv_yes_no( "MULLE_OBJC_COVERAGE");
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
extern struct mulle_allocator   mulle_test_allocator_objc;


const struct _ns_root_setupconfig   *ns_objc_get_default_setupconfig( void)
{
   static const struct _ns_root_setupconfig   setup =
   {
      {
         NULL,
         versionassert,
         &NSObject_msgForward_method,
         NULL,
      },
      {
         sizeof( struct _ns_root_setupconfig),
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
         (void (*)()) _ns_root_setup,
         tear_down,
         post_create
      }
   };

   return( &setup);
}


void   ns_objc_universe_setup( struct _mulle_objc_universe *universe,
                               struct _ns_root_setupconfig *setup)
{
   int   is_pedantic;
   int   is_test;
   int   is_coverage;

   if( ! _mulle_objc_universe_is_transitioning( universe))
   {
      if( _mulle_objc_universe_is_initialized( universe))
         fprintf( stderr, "The universe %p is already initialized. Do not call \"ns_objc_universe_setup\" twice.\n", universe);
      else
         fprintf( stderr, "Do not call \"ns_objc_universe_setup\" directly, call it via _mulle_objc_universe_bang. (%d)\n", _mulle_objc_universe_get_version( universe));
      abort();
   }

   is_pedantic = mulle_objc_getenv_yes_no( "MULLE_OBJC_PEDANTIC_EXIT");
   is_test     = mulle_objc_getenv_yes_no( "MULLE_OBJC_TEST_ALLOCATOR");
   is_coverage = mulle_objc_getenv_yes_no( "MULLE_OBJC_COVERAGE");

   if( is_test)
   {
      // call this because we are probably also in +load here
      mulle_test_allocator_objc_initialize();

      //
      // in case of leaks, getting traces of universe allocatios can be
      // tedious. Assuming universe is leak free, run with a test
      // allocator for objects only (MULLE_OBJC_TEST_ALLOCATOR=1)
      //
      if( is_test & 0x1)
         setup->foundation.objectallocator = &mulle_test_allocator_objc;
      if( is_test & 0x2)
         setup->universe.allocator          = &mulle_test_allocator_objc;
#if DEBUG
      if( is_test & 0x3)
         fprintf( stderr, "MulleObjC uses \"mulle_test_allocator_objc\" to detect leaks.\n");
#endif
   }

   (*setup->callbacks.setup)( universe, setup);
   (*setup->callbacks.post_create)( universe);

   if( is_pedantic || is_test || is_coverage)
   {
      struct _ns_rootconfiguration *rootcfg;

      rootcfg = _mulle_objc_universe_get_foundationdata( universe);

      // if we retain zombies, we leak, so no point in looking for leaks
      if( rootcfg->object.zombieenabled && ! rootcfg->object.deallocatezombies)
         is_test = 0;
      
      if( universe->debug.trace.universe)
         fprintf( stderr, "mulle-objc: install atexit handler for universe crunch...\n");

      if( atexit( setup->callbacks.tear_down))
         perror( "atexit:");
   }

   mulle_objc_list_install_hook( universe);
}

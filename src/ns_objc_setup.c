//
//  ns_objc_setup.c
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

#include "ns_objc_setup.h"

#include "ns_rootconfiguration.h"
#include "ns_test_allocation.h"


// std-c and dependencies

static void   versionassert( struct _mulle_objc_runtime *runtime,
                            void *friend,
                            struct mulle_objc_loadversion *version)
{
   if( (version->foundation & ~0xFF) != (MULLE_OBJC_VERSION & ~0xFF))
      _mulle_objc_runtime_raise_inconsistency_exception( runtime, "mulle_objc_runtime %p: foundation version set to %x but runtime foundation is %x",
                                                        runtime,
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
void   *_objc_msgForward( void *self, mulle_objc_methodid_t _cmd, void *_param)
{
   struct _mulle_objc_class   *cls;

   cls = _mulle_objc_object_get_isa( self);
   _mulle_objc_class_raise_method_not_found_exception( cls, _cmd);
   return( NULL);
}

struct _mulle_objc_method   NSObject_msgForward_method =
{
   MULLE_OBJC_FORWARD_METHODID,  // forward:
   "forward:",
   "@@:@",
   0,

   _objc_msgForward
};


static void  tear_down()
{
   extern void  _NSThreadResignAsMainThread( void);

   _NSThreadResignAsMainThread();

   // No Objective-C available anymore
}


static void   tear_down_and_check()
{
   tear_down();

   mulle_test_allocator_objc_reset();
}


static void   *return_self( void *p)
{
   return( p);
}


static void  post_create( struct _mulle_objc_runtime  *runtime)
{
   struct _ns_rootconfiguration         *rootconfig;

   rootconfig = _mulle_objc_runtime_get_foundationdata( runtime);

   rootconfig->string.charsfromobject = (char *(*)()) return_self;
   rootconfig->string.objectfromchars = (void *(*)()) return_self;
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
         tear_down_and_check,
         post_create
      }
   };

   return( &setup);
}


struct _mulle_objc_runtime  *ns_objc_create_runtime( struct _ns_root_setupconfig *setup)
{
   BOOL                         is_pedantic;
   char                         *s;
   int                          is_test;
   struct _mulle_objc_runtime   *runtime;

   runtime = __mulle_objc_get_runtime();
   assert( ! _mulle_objc_runtime_is_initalized( runtime));

   is_pedantic = getenv( "MULLE_OBJC_PEDANTIC_EXIT") != NULL;
   s           = getenv( "MULLE_OBJC_TEST_ALLOCATOR");
   is_test     = s ? atoi( s) : 0;

   if( is_test)
   {
      // call this because we are probably also in +load here
      mulle_test_allocator_objc_initialize();

      //
      // in case of leaks, getting traces of runtime allocatios can be
      // tedious. Assuming runtime is leak free, run with a test
      // allocator for objects only (MULLE_OBJC_TEST_ALLOCATOR=1)
      //
      if( is_test & 0x1)
         setup->foundation.objectallocator = &mulle_test_allocator_objc;
      if( is_test & 0x2)
         setup->runtime.allocator          = &mulle_test_allocator_objc;
#if DEBUG
      if( is_test & 0x3)
         fprintf( stderr, "MulleObjC uses \"mulle_test_allocator_objc\" to detect leaks.\n");
#endif
   }

   (*setup->callbacks.setup)( runtime, setup);
   (*setup->callbacks.post_create)( runtime);

   if( is_pedantic || is_test)
   {
      struct _ns_rootconfiguration *rootcfg;

      rootcfg = _mulle_objc_runtime_get_foundationdata( runtime);

      // if we retain zombies, we leak, so no point in looking for leaks
      if( rootcfg->object.zombieenabled && ! rootcfg->object.deallocatezombies)
         is_test = 0;

      if( atexit( is_test ? setup->callbacks.tear_down_and_check
                          : setup->callbacks.tear_down))
         perror( "atexit:");
   }

   return( runtime);
}

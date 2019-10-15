//
//  mulle-objc-foundationinfo.m
//  MulleObjC
//
//  Copyright (c) 2011-2018 Nat! - Mulle kybernetiK.
//  Copyright (c) 2011-2018 Codeon GmbH.
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
#pragma clang diagnostic ignored "-Wparentheses"

#import "import-private.h"

#import "mulle-objc-universefoundationinfo-private.h"
#import "NSThread.h"
#import "NSAutoreleasePool.h"


// TODO: MulleObjCContainer.h ??

static const struct mulle_container_keycallback
   object_container_keycallback =
{
   mulle_container_keycallback_pointer_hash,
   mulle_container_keycallback_pointer_is_equal,
   mulle_container_keycallback_self,
   mulle_container_keycallback_nop,
   mulle_container_keycallback_no_description,

   NULL,
   NULL
};


//
// this is unfortunately linkorder and platform dependent
//
static void   assert_proper_testallocator_linkorder( void)
{
   char  *s;

   if( ! mulle_objc_environment_get_yes_no( "MULLE_TESTALLOCATOR"))
      return;

   if( mulle_default_allocator.free == free)
   {
      fprintf( stderr,
         "The testallocator is not linked in or not in the proper order.\n"
         "The universe is initialized first. Flip linkorder for this platform ?\n");
      abort();
   }
}


void
   _mulle_objc_universefoundationinfo_init( struct _mulle_objc_universefoundationinfo *info,
                                            struct _mulle_objc_universe *universe,
                                            struct mulle_allocator *allocator,
                                            struct _mulle_objc_exceptionhandlertable *exceptiontable)
{
   info->universe = universe;

   /* the callback is copied anyway, but the allocator needs to be stored
      in the info. It's OK to have a different allocator for Foundation
      then for the universe. The info->allocator is used to create instances.
    */
   if( universe->debug.trace.universe)
      mulle_objc_universe_trace( universe, "setting up root/singleton/etc sets");

#if DEBUG
   assert_proper_testallocator_linkorder();
#endif
   info->exception.vectors   = *exceptiontable;

   info->object.roots        = mulle_set_create( 32,
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


#if 0
static void
   _mulle_objc_infraclass_release_cvars( struct _mulle_objc_infraclass *infra)
{
   struct _mulle_objc_universe                 *universe;
   struct mulle_allocator                      *allocator;
   struct mulle_concurrent_hashmapenumerator   rover;
   intptr_t                                    key;
   id                                          value;

   rover = mulle_concurrent_hashmap_enumerate( &infra->cvars);
   while( mulle_concurrent_hashmapenumerator_next( &rover, &key, (void **) &value) == 1)
      [value release];
   mulle_concurrent_hashmapenumerator_done( &rover);

   // reset the hashmap now
   universe  = _mulle_objc_infraclass_get_universe( infra);
   allocator = _mulle_objc_universe_get_allocator( universe);
      _mulle_concurrent_hashmap_done( &infra->cvars);
   _mulle_concurrent_hashmap_init( &infra->cvars, 0, allocator);
}


static void
   _mulle_objc_universe_release_cvars( struct _mulle_objc_universe *universe)
{
   struct _mulle_objc_infraclass               *infra;
   struct mulle_concurrent_hashmapenumerator   rover;

   rover = mulle_concurrent_hashmap_enumerate( &universe->classtable);
   while( _mulle_concurrent_hashmapenumerator_next( &rover, NULL, (void **) &infra))
      _mulle_objc_infraclass_release_cvars( infra);
   mulle_concurrent_hashmapenumerator_done( &rover);
}
#endif

static void
   _mulle_objc_universe_finalize_singletons( struct _mulle_objc_universe *universe)
{
   struct _mulle_objc_infraclass               *infra;
   struct mulle_concurrent_hashmapenumerator   rover;
   id                                          obj;
   int                                         is_constant;

   //
   // performFinalize on singletons, this will add stuff to the
   // autoreleasepool, we want our singletons to be releases later,
   // so we autorelease them later

   rover = mulle_concurrent_hashmap_enumerate( &universe->classtable);
   while( _mulle_concurrent_hashmapenumerator_next( &rover, NULL, (void **) &infra))
   {
      obj = (id) _mulle_objc_infraclass_get_singleton( infra);
      if( ! obj)
         continue;

      // singletons can be ephemeral and not constant, but we want to
      // deal with both
      is_constant = _mulle_objc_object_is_constant( obj);
      if( is_constant)
         _mulle_objc_object_deconstantify_noatomic( obj);

      [obj mullePerformFinalize];

      // this weird dance is there, because we can not otherwise call
      // -finalize, but we need to keep it constant because some code
      // may depend on it later in +unload
      if( is_constant)
         _mulle_objc_object_constantify_noatomic( obj);
   }
   mulle_concurrent_hashmapenumerator_done( &rover);
}


void
   _mulle_objc_universefoundationinfo_willfinalize( struct _mulle_objc_universefoundationinfo *info)
{
   struct _mulle_objc_universe   *universe;

   universe = info->universe;
   assert( universe);

   //
   // we empty out the pool with the remaining user objects now before anything
   // else
   //
   if( universe->debug.trace.universe)
       mulle_objc_universe_trace( universe, "pop autoreleasepools");
   mulle_objc_thread_reset_poolconfiguration( universe);

   //
   // get rid of runloop and thread dictionary
   //
   if( universe->debug.trace.universe)
       mulle_objc_universe_trace( universe, "finalize main thread object");
   _NSThreadFinalizeMainThreadObject( universe);

   //
   // we empty out the pools now before anything else is reclaimed during
   // shutdown
   //
   if( universe->debug.trace.universe)
       mulle_objc_universe_trace( universe, "pop autoreleasepools");
   mulle_objc_thread_reset_poolconfiguration( universe);
}


void
   _mulle_objc_universefoundationinfo_finalize( struct _mulle_objc_universefoundationinfo *info)
{
   struct _mulle_objc_universe                 *universe;
   struct _mulle_objc_infraclass               *infra;
   struct mulle_concurrent_hashmapenumerator   rover;

   universe = info->universe;
   assert( universe);

   /* technically interesting is that we are releasing the root objects here.
      Yet objects in the NSThread autoreleasepool may still need them.
      So the teardown_callback should empty the root autoreleasepool now.
   */
   if( info->teardown_callback)
      (*info->teardown_callback)( universe);

   //
   // we empty out the pools now before singletons are reclaimed
   //
   if( universe->debug.trace.universe)
       mulle_objc_universe_trace( universe, "pop autoreleasepools");
   mulle_objc_thread_reset_poolconfiguration( universe);

#if 0
   //
   // dealloc class vars
   //
   if( universe->debug.trace.universe)
      mulle_objc_universe_trace( universe,
                                 "universe (foundation) releases class variables");
   _mulle_objc_universe_release_cvars( universe);
#endif

   //
   // dealloc singletons. A singleton could assume that stuff from +initialize
   // is still present
   //
   if( universe->debug.trace.universe)
      mulle_objc_universe_trace( universe,
                                 "universe (foundation) finalizes singletons");
   _mulle_objc_universe_finalize_singletons( universe);


   //
   // we empty out the pools again now, but put up a new one for our roots
   //
   if( universe->debug.trace.universe)
       mulle_objc_universe_trace( universe, "pop autoreleasepools");
   mulle_objc_thread_reset_poolconfiguration( universe);

   // autoreleasepool should be the last root to go
   if( universe->debug.trace.universe)
       mulle_objc_universe_trace( universe, "release root objects");
   _mulle_objc_universefoundationinfo_release_rootobjects( info);

   // crashing here with a false free ? Then testallocator was not
   // initialized ahead of the universe. Flip linkorder for this
   // platform
   mulle_set_destroy( info->object.roots);
}


//
// second stage, this cleans the autoreleasepool and this is about the
// very last thing that happens in a universe
//
void
   _mulle_objc_universefoundationinfo_done( struct _mulle_objc_universefoundationinfo *info)
{
   struct _mulle_objc_universe   *universe;

   universe = info->universe;
   assert( universe);

   if( universe->debug.trace.universe)
       mulle_objc_universe_trace( universe, "resign main thread object");
   _NSThreadResignAsMainThreadObject( universe);

   if( universe->debug.trace.universe)
       mulle_objc_universe_trace( universe, "release thread storage");

   // threads should be gone by now
   assert( mulle_set_get_count( info->object.threads) == 0);
   mulle_set_destroy( info->object.threads);
}


# pragma mark -
# pragma mark root object handling

void   _mulle_objc_universefoundationinfo_add_rootobject( struct _mulle_objc_universefoundationinfo *info,
                                                          void *obj)
{
   assert( mulle_set_get( info->object.roots, obj) == NULL);
   assert( mulle_set_get( info->object.threads, obj) == NULL);

   // no constant strings or tagged pointers
   assert( ! _mulle_objc_object_is_constant( obj));

   if( mulle_set_insert( info->object.roots, obj))
      mulle_objc_universe_fail_inconsistency( info->universe, "Object %p is already root", obj);
}


void   _mulle_objc_universefoundationinfo_remove_rootobject( struct _mulle_objc_universefoundationinfo *info,
                                                             void *obj)
{
   assert( mulle_set_get( info->object.roots, obj) != NULL);

   mulle_set_remove( info->object.roots, obj);
}


void   _mulle_objc_universefoundationinfo_release_rootobjects( struct _mulle_objc_universefoundationinfo *info)
{
   struct mulle_setenumerator   rover;
   void                         *obj;

   /* remove all root objects: need to have an enclosing
    * autoreleasepool here
    */
   rover = mulle_set_enumerate( info->object.roots);
   while( obj = mulle_setenumerator_next_nil( &rover))
      mulle_objc_object_release( obj);
   mulle_setenumerator_done( &rover);
}


# pragma mark -
# pragma mark thread storage

void   _mulle_objc_universefoundationinfo_add_threadobject( struct _mulle_objc_universefoundationinfo *info,
                                                            void *obj)
{
   assert( mulle_set_get( info->object.roots, obj) == NULL);
   assert( mulle_set_get( info->object.threads, obj) == NULL);

   mulle_set_set( info->object.threads, obj);
}


void   _mulle_objc_universefoundationinfo_remove_threadobject( struct _mulle_objc_universefoundationinfo *info,
                                                               void *obj)
{
   assert( mulle_set_get( info->object.threads, obj) != NULL);

   mulle_set_remove( info->object.threads, obj);
}


//
// mainthread doesn't need to be accessed locked, since it doesn't change
//
void   _mulle_objc_universefoundationinfo_set_mainthreadobject( struct _mulle_objc_universefoundationinfo *info,
                                                                 void *obj)
{
   info->thread.mainthread = obj;  //
}


void   *_mulle_objc_universefoundationinfo_get_mainthreadobject( struct _mulle_objc_universefoundationinfo *info)
{
   return( info->thread.mainthread);
}



# pragma mark -
# pragma mark locking wrapper for above

void  _mulle_objc_universe_lockedcall_universefoundationinfo( struct _mulle_objc_universe *universe,
                                                              void (*f)( struct _mulle_objc_universefoundationinfo *))
{
   // get foundation add to roots
   struct _mulle_objc_universefoundationinfo   *info;

   _mulle_objc_universe_lock( universe);
   {
      info = _mulle_objc_universe_get_foundationdata( universe);
      (*f)( info);
   }
   _mulle_objc_universe_unlock( universe);
}


void  _mulle_objc_universe_lockedcall1_universefoundationinfo( struct _mulle_objc_universe *universe,
                                                               void (*f)( struct _mulle_objc_universefoundationinfo *, void *),
                                                               void *obj)
{
   struct _mulle_objc_universefoundationinfo   *info;

   assert( obj);

   _mulle_objc_universe_lock( universe);
   {
      info = _mulle_objc_universe_get_foundationdata( universe);
      (*f)( info, obj);
   }
   _mulle_objc_universe_unlock( universe);
}

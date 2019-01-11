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


static void  *describe_object( struct mulle_container_keycallback *callback,
                               void *p,
                               struct mulle_allocator *allocator)
{
   // we have no strings yet, someone should patch mulle_allocator_objc
   // use _mulle_objc_string here ???
   return( NULL);
}


// TODO: MulleObjCContainer.h ??

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


void
   _mulle_objc_universefoundationinfo_done( struct _mulle_objc_universefoundationinfo *info)
{
   struct _mulle_objc_universe   *universe;

   universe = info->universe;
   assert( universe);

   if( info->teardown_callback)
      (*info->teardown_callback)( universe);

   if( universe->debug.trace.universe)
       mulle_objc_universe_trace( universe, "release placeholders");
    _mulle_objc_universefoundationinfo_release_placeholders( info);
   mulle_set_destroy( info->object.placeholders);

   if( universe->debug.trace.universe)
       mulle_objc_universe_trace( universe, "release singletons");
    _mulle_objc_universefoundationinfo_release_singletons( info);
   mulle_set_destroy( info->object.singletons);

   if( universe->debug.trace.universe)
       mulle_objc_universe_trace( universe, "release root objects");
    _mulle_objc_universefoundationinfo_release_rootobjects( info);
   mulle_set_destroy( info->object.roots);

   if( universe->debug.trace.universe)
       mulle_objc_universe_trace( universe, "release thread objects");

   _NSThreadResignAsMainThreadObject( universe);

   // threads should be gone by now
   assert( mulle_set_get_count( info->object.threads) == 0);
   mulle_set_destroy( info->object.threads);
}



# pragma mark -
# pragma mark root object handling

void   _mulle_objc_universefoundationinfo_add_rootobject( struct _mulle_objc_universefoundationinfo *info,
                                                          void *obj)
{
   assert( mulle_set_get( info->object.placeholders, obj) == NULL);
   assert( mulle_set_get( info->object.roots, obj) == NULL);
   assert( mulle_set_get( info->object.singletons, obj) == NULL);
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
   while( obj = mulle_setenumerator_next( &rover))
      mulle_objc_object_release( obj);
   mulle_setenumerator_done( &rover);
}


# pragma mark -
# pragma mark placeholder storage

void   _mulle_objc_universefoundationinfo_add_placeholder( struct _mulle_objc_universefoundationinfo *info,
                                                           void *obj)
{
   assert( mulle_set_get( info->object.placeholders, obj) == NULL);
   assert( mulle_set_get( info->object.roots, obj) == NULL);
   assert( mulle_set_get( info->object.singletons, obj) == NULL);
   assert( mulle_set_get( info->object.threads, obj) == NULL);

   mulle_set_set( info->object.placeholders, obj);
}


void   _mulle_objc_universefoundationinfo_release_placeholders( struct _mulle_objc_universefoundationinfo *info)
{
   struct mulle_setenumerator   rover;
   void                         *obj;

   /* remove all root objects: need to have an enclosing
    * autoreleasepool here
    */
   rover = mulle_set_enumerate( info->object.placeholders);
   while( obj = mulle_setenumerator_next( &rover))
      mulle_objc_object_release( obj);
   mulle_setenumerator_done( &rover);
}


# pragma mark -
# pragma mark singleton storage

void   _mulle_objc_universefoundationinfo_add_singleton( struct _mulle_objc_universefoundationinfo *info,
                                                         void *obj)
{
   assert( mulle_set_get( info->object.placeholders, obj) == NULL);
   assert( mulle_set_get( info->object.roots, obj) == NULL);
   assert( mulle_set_get( info->object.singletons, obj) == NULL);
   assert( mulle_set_get( info->object.threads, obj) == NULL);

   mulle_set_set( info->object.singletons, obj);
}


void   _mulle_objc_universefoundationinfo_release_singletons( struct _mulle_objc_universefoundationinfo *info)
{
   struct mulle_setenumerator   rover;
   void                         *obj;

   /* remove all root objects: need to have an enclosing
    * autoreleasepool here
    */
   rover = mulle_set_enumerate( info->object.singletons);
   while( obj = mulle_setenumerator_next( &rover))
      mulle_objc_object_release( obj);
   mulle_setenumerator_done( &rover);
}


# pragma mark -
# pragma mark thread storage

void   _mulle_objc_universefoundationinfo_add_rootthreadobject( struct _mulle_objc_universefoundationinfo *info,
                                                                void *obj)
{
   assert( mulle_set_get( info->object.placeholders, obj) == NULL);
   assert( mulle_set_get( info->object.roots, obj) == NULL);
   assert( mulle_set_get( info->object.singletons, obj) == NULL);
   assert( mulle_set_get( info->object.threads, obj) == NULL);

   mulle_set_set( info->object.threads, obj);
}


void   _mulle_objc_universefoundationinfo_remove_rootthreadobject( struct _mulle_objc_universefoundationinfo *info,
                                                                   void *obj)
{
   assert( mulle_set_get( info->object.threads, obj) != NULL);

   mulle_set_remove( info->object.threads, obj);
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



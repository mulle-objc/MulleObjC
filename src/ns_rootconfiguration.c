//
//  ns_rootconfiguration.c
//  MulleObjC
//
//  Created by Nat! on 15/10/15.
//  Copyright © 2015 Mulle kybernetiK. All rights reserved.
//

// this is the only file that has an __attribute__ constructor
// this links in all the roots stuff into the runtime

#include "ns_objc_include.h"

#include "ns_rootconfiguration.h"
#include "_ns_exception.h"
#include <assert.h>


# pragma mark -
# pragma mark root object handling

void   _ns_rootconfiguration_add_root( struct _ns_rootconfiguration *config, void *obj)
{
   assert( mulle_set_get( config->object.placeholders, obj) == NULL);
   assert( mulle_set_get( config->object.roots, obj) == NULL);
   assert( mulle_set_get( config->object.singletons, obj) == NULL);
   assert( mulle_set_get( config->object.threads, obj) == NULL);
   
   mulle_set_put( config->object.roots, obj);
}


void   _ns_rootconfiguration_remove_root( struct _ns_rootconfiguration *config, void *obj)
{
   assert( mulle_set_get( config->object.roots, obj) != NULL);
   
   mulle_set_remove( config->object.roots, obj);
}



void   _ns_rootconfiguration_release_roots( struct _ns_rootconfiguration *config)
{
   struct mulle_setenumerator     rover;
   void                           *obj;
   
   /* remove all root objects: need to have an enclosing
    * autoreleasepool here
    */
   rover = mulle_set_enumerate( config->object.roots);
   while( obj = mulle_setenumerator_next( &rover))
      mulle_objc_object_release( obj);
   mulle_setenumerator_done( &rover);
}



# pragma mark -
# pragma mark placeholder storage

void   _ns_rootconfiguration_add_placeholder( struct _ns_rootconfiguration *config, void *obj)
{
   assert( mulle_set_get( config->object.placeholders, obj) == NULL);
   assert( mulle_set_get( config->object.roots, obj) == NULL);
   assert( mulle_set_get( config->object.singletons, obj) == NULL);
   assert( mulle_set_get( config->object.threads, obj) == NULL);
   
   mulle_set_put( config->object.placeholders, obj);
}


void   _ns_rootconfiguration_release_placeholders( struct _ns_rootconfiguration *config)
{
   struct mulle_setenumerator     rover;
   void                           *obj;
   
   /* remove all root objects: need to have an enclosing
    * autoreleasepool here
    */
   rover = mulle_set_enumerate( config->object.placeholders);
   while( obj = mulle_setenumerator_next( &rover))
      mulle_objc_object_release( obj);
   mulle_setenumerator_done( &rover);
}


# pragma mark -
# pragma mark singleton storage

void   _ns_rootconfiguration_add_singleton( struct _ns_rootconfiguration *config, void *obj)
{
   assert( mulle_set_get( config->object.placeholders, obj) == NULL);
   assert( mulle_set_get( config->object.roots, obj) == NULL);
   assert( mulle_set_get( config->object.singletons, obj) == NULL);
   assert( mulle_set_get( config->object.threads, obj) == NULL);
   
   mulle_set_put( config->object.singletons, obj);
}


void   _ns_rootconfiguration_release_singletons( struct _ns_rootconfiguration *config)
{
   struct mulle_setenumerator     rover;
   void                           *obj;
   
   /* remove all root objects: need to have an enclosing
    * autoreleasepool here
    */
   rover = mulle_set_enumerate( config->object.singletons);
   while( obj = mulle_setenumerator_next( &rover))
      mulle_objc_object_release( obj);
   mulle_setenumerator_done( &rover);
}


# pragma mark -
# pragma mark thread storage

void   _ns_rootconfiguration_add_thread( struct _ns_rootconfiguration *config, void *obj)
{
   assert( mulle_set_get( config->object.placeholders, obj) == NULL);
   assert( mulle_set_get( config->object.roots, obj) == NULL);
   assert( mulle_set_get( config->object.singletons, obj) == NULL);
   assert( mulle_set_get( config->object.threads, obj) == NULL);
   
   mulle_set_put( config->object.threads, obj);
}


void   _ns_rootconfiguration_remove_thread( struct _ns_rootconfiguration *config, void *obj)
{
   assert( mulle_set_get( config->object.threads, obj) != NULL);
   
   mulle_set_remove( config->object.threads, obj);
}



# pragma mark -
# pragma mark locking wrapper for above

void  _ns_rootconfiguration_locked_call( void (*f)( struct _ns_rootconfiguration*))
{
   // get foundation add to roots
   struct _ns_rootconfiguration   *config;
   struct _mulle_objc_runtime     *runtime;
   
   runtime = mulle_objc_inlined_get_runtime();
   
   _mulle_objc_runtime_lock( runtime);
   {
      _mulle_objc_runtime_get_foundationspace( runtime, (void **) &config, NULL);
      (*f)( config);
   }
   _mulle_objc_runtime_unlock( runtime);
}


void  _ns_rootconfiguration_locked_call1( void (*f)( struct _ns_rootconfiguration*, void *),
                                          void *obj)
{
   // get foundation add to roots
   struct _ns_rootconfiguration   *config;
   struct _mulle_objc_runtime     *runtime;
   struct _mulle_objc_class       *cls;
   
   assert( obj);
   
   cls     = _mulle_objc_object_get_isa( obj);
   runtime = _mulle_objc_class_get_runtime( cls);
   
   _mulle_objc_runtime_lock( runtime);
   {
      _mulle_objc_runtime_get_foundationspace( runtime, (void **) &config, NULL);
      (*f)( config, obj);
   }
   _mulle_objc_runtime_unlock( runtime);
}


# pragma mark -
# pragma mark Configuration of the North Shore

extern void   MulleObjCAutoreleasePoolConfigurationUnsetThread( void);


static void   runtime_dies( struct _mulle_objc_runtime *runtime, void *data)
{
   struct _ns_rootconfiguration   *config;
   
   _mulle_objc_runtime_get_foundationspace( runtime, (void **) &config, NULL);
   
   mulle_set_free( config->object.placeholders);
   mulle_set_free( config->object.singletons);
   mulle_set_free( config->object.roots);
   mulle_set_free( config->object.threads);

   if( data != config)
      free( data);
}


static void  *describe_object( struct mulle_container_keycallback *callback,
                               void *p,
                               struct mulle_allocator *allocator)
{
   // we have no strings yet, someone should patch mulle_allocator_objc
   return( NULL);
}


static const struct mulle_container_keycallback   default_root_object_callback =
{
   (void *) mulle_container_callback_pointer_hash,
   (void *) mulle_container_callback_pointer_is_equal,
   (void *) mulle_container_callback_self,
   (void *) mulle_container_callback_nop,
   describe_object,

   NULL,
   NULL
};


static void   nop( struct _mulle_objc_runtime *runtime, void *friend,  struct mulle_objc_loadversion *info)
{
}


/*
 * This function sets up a Foundation on a per thread
 * basis.
 */
extern void   MulleObjCDeterminePageSize( void);

struct _ns_rootconfiguration  *__MulleObjC_root_setup( struct _mulle_objc_runtime *runtime,
                                                struct _ns_root_setupconfig *config)
{
   size_t                          size;
   size_t                          neededsize;
   struct _mulle_objc_foundation   us;
   struct _ns_rootconfiguration    *roots;
   struct mulle_allocator          *allocator;
   
   MulleObjCDeterminePageSize();

   __mulle_objc_runtime_setup( runtime, config->runtime.allocator);
   
   runtime->classdefaults.inheritance   = MULLE_OBJC_CLASS_DONT_INHERIT_PROTOCOL_CATEGORIES;
   runtime->classdefaults.forwardmethod = config->runtime.forward;
   runtime->failures.uncaughtexception  = (void *) config->runtime.uncaughtexception;
   
   neededsize = config->foundation.configurationsize;
   if( ! neededsize)
      neededsize = sizeof( struct _ns_rootconfiguration);
   
   _mulle_objc_runtime_get_foundationspace( runtime, (void **) &roots, &size);
   if( size < neededsize)
   {
      roots = (*config->runtime.allocator->calloc)( 1, neededsize);
      if( ! roots)
         mulle_objc_raise_fail_errno_exception();
   }

   us.runtimefriend.destructor    = runtime_dies;
   us.runtimefriend.data          = roots;
   us.runtimefriend.versionassert = config->runtime.versionassert ? config->runtime.versionassert : nop;

   allocator = config->foundation.objectallocator
                  ? config->foundation.objectallocator
                  : &mulle_default_allocator;

   us.allocator = *allocator;
   
   roots->runtime = runtime;
   
   /* the callback is copied anyway, but the allocator needs to be stored
      in the config. It's OK to have a different allocator for Foundation
      then for the runtime. The roots->allocator is used to create instances.
    */
   
   roots->exception.vectors = *config->foundation.exceptiontable;

   roots->object.roots = mulle_set_create( 32,
                                           (void *) &default_root_object_callback,
                                           config->runtime.allocator);
   roots->object.singletons = mulle_set_create( 8,
                                                (void *) &default_root_object_callback,
                                                config->runtime.allocator);
   roots->object.placeholders = mulle_set_create( 32,
                                                  (void *) &default_root_object_callback,
                                                  config->runtime.allocator);
   roots->object.threads = mulle_set_create( 4,
                                            (void *) &default_root_object_callback,
                                            config->runtime.allocator);
   
   _mulle_objc_runtime_set_foundation( runtime, &us);

   roots->object.debugenabled      = getenv( "MULLE_OBJC_DEBUG_ENABLED") != NULL;
   roots->object.zombieenabled     = getenv( "MULLE_OBJC_ZOMBIE_ENABLED") != NULL;
   roots->object.deallocatezombies = getenv( "MULLE_OBJC_DEALLOCATE_ZOMBIES") != NULL;
   
   return( roots);
}


void   _ns_root_setup( struct _mulle_objc_runtime *runtime,
                       struct _ns_root_setupconfig *config)
{
   struct _ns_rootconfiguration   *roots;
   
   roots = __MulleObjC_root_setup( runtime, config);

   //
   //
   // this will be done in [NSThread load]
   // .. we can not do this yet, no classes are loaded
   //
   // thread = [NSThread new];
   // [thread instantiateRuntimeThread];
}



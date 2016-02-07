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


# pragma mark -
# pragma mark Exceptions

static void  perror_abort( char *s)
{
   perror( s);
   abort();
}


static void  init_ns_exceptionhandlertable ( struct _ns_exceptionhandlertable *table)
{
   unsigned int   i;
   
   for( i = 0; i <= _NSExceptionHandlerTableSize; i++)
      table->handlers[ i] = (i == _NSExceptionErrnoHandlerIndex) ? (void *) perror_abort : (void *) abort;
}


# pragma mark -
# pragma mark AutoreleasePool

static void   runtime_dies( struct _mulle_objc_runtime *runtime, void *data)
{
   struct        _MulleObjCRoots   *roots;
   extern void   _NSAutoreleasePoolConfigurationUnsetThread( void);

   _mulle_objc_runtime_get_foundationspace( runtime, (void **) &roots, NULL);
   if( data != roots)
      free( data);
}


static void   release_object( struct mulle_container_keycallback *callback, void *p)
{
   _mulle_objc_object_release( p);
}


static void  *describe_object( struct mulle_container_keycallback *callback, void *p)
{
   // we have no strings yet, someone should patch mulle_allocator_objc
   return( NULL);
}


static struct mulle_container_keycallback   default_root_object_callback =
{
   (void *) mulle_container_callback_pointer_hash,
   (void *) mulle_container_callback_pointer_is_equal,
   (void *) mulle_container_callback_self,
   release_object,
   describe_object,
   NULL,
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
struct _ns_rootconfiguration  *__ns_root_setup( mulle_objc_runtimefriend_versionassert_t versionassert)
{
   size_t                              size;
   struct _ns_rootconfiguration        *roots;
   struct _mulle_objc_runtime          *runtime;
   struct _mulle_objc_foundation       us;
   struct mulle_container_keycallback  root_object_callback;
   extern struct mulle_allocator       mulle_allocator_objc;
   extern void                         _NSDeterminePageSize( void);

   _NSDeterminePageSize();

   runtime = __mulle_objc_runtime_setup();
   runtime->classdefaults.inheritance = MULLE_OBJC_CLASS_DONT_INHERIT_PROTOCOL_CATEGORIES;
   
   _mulle_objc_runtime_get_foundationspace( runtime, (void **) &roots, &size);
   if( size < sizeof( struct _ns_rootconfiguration))
   {
      roots = calloc( 1, sizeof( struct _ns_rootconfiguration));
      if( ! roots)
         mulle_objc_raise_fail_errno_exception();
   }

   us.runtimefriend.destructor    = runtime_dies;
   us.runtimefriend.data          = roots;
   us.runtimefriend.versionassert = versionassert ? versionassert : nop;
   
   roots->runtime = runtime;
   
   /* the callback is copied anyway, but the allocator needs to be stored
      in the config 
    */
   
   roots->allocator     = mulle_allocator_objc;
   root_object_callback = default_root_object_callback;
   root_object_callback.allocator = &roots->allocator;
   
   roots->roots   = mulle_set_create( 32, &root_object_callback);
   _mulle_objc_runtime_set_foundation( runtime, &us);
   
   return( roots);
}


struct _mulle_objc_runtime  *_ns_root_setup( mulle_objc_runtimefriend_versionassert_t versionassert)
{
   struct _ns_rootconfiguration   *roots;
   
   roots = __ns_root_setup( versionassert);
   
   init_ns_exceptionhandlertable ( &roots->exceptions);

   //
   // this initializes the autorelease pool for this thread
   // it registers this thread with the runtime
   // .. we can not do this yet, no classes are loaded
   //
   // this will be done in [NSThread load]
   //
   // thread = [NSThread new];
   // [thread makeRuntimeThread];

   return( roots->runtime);
}


//
// your chance to take over, if you somehow make it to the front of the
// __load chain. (You can with dylibs, but is very hard with .a)
//
struct _mulle_objc_runtime   *(*ns_root_setup)( mulle_objc_runtimefriend_versionassert_t versionassert) = _ns_root_setup;

mulle_thread_tss_t   __ns_rootconfigurationKey;

//
// we assume worst case, that some other class is loading in faster than
// this is the "patch" in function, that is not defined by the objc
// runtime
//


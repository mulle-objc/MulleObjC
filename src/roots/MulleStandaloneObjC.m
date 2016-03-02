//
//  MulleStandaloneObjC.c
//  MulleObjC
//
//  Created by Nat! on 04.02.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "MulleStandaloneObjC.h"

#include "ns_test_allocation.h"
#include "ns_allocation.h"


static void   versionassert( struct _mulle_objc_runtime *runtime,
                             void *friend,
                             struct mulle_objc_loadversion *version)
{
   if( (version->foundation & ~0xFF) != (MULLE_OBJC_FOUNDATION_VERSION & ~0xFF))
      _mulle_objc_runtime_raise_inconsistency_exception( runtime, "mulle_objc_runtime %p: foundation version set to %x but runtime foundation is %x",
                                                        runtime,
                                                        version->foundation,
                                                        MULLE_OBJC_FOUNDATION_VERSION);
}



/* 
 * it's just too convenient, to have this as the old name
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
   NSThread  *thread;
   
   //
   // keep current thread around, which is a root
   // that way we also have an AutoreleasePool in place
   //
   assert( ! [NSThread isMultiThreaded]);

   thread = [NSThread currentThread];
   [thread retain];
   [NSObject releaseAllRootObjects];
   [thread release];
   
   // TODO: check that all autoreleasepools are gone
   
   mulle_objc_release_runtime();
   
   if( getenv( "MULLE_OBJC_TEST_ALLOCATOR"))
      mulle_test_allocator_objc_reset();
}



__attribute__((const))  // always returns same value (in same thread)
struct _mulle_objc_runtime  *__get_or_create_objc_runtime( void)
{
   struct _mulle_objc_runtime           *runtime;
   extern struct mulle_allocator        mulle_objc_allocator;
   static struct _ns_root_setupconfig   config =
   {
      &mulle_allocator_objc,
      versionassert,
      &NSObject_msgForward_method,
      NULL
   };
   BOOL   is_test;
   BOOL   is_pedantic;
   
   runtime = __mulle_objc_get_runtime();
   if( ! runtime->version)
   {
      is_test = getenv( "MULLE_OBJC_TEST_ALLOCATOR") != NULL;
      if( is_test)
      {
         // call this because we are probably also in +load here
         mulle_test_allocator_objc_initialize();
         
         config.allocator_p = &mulle_test_allocator_objc;
#if DEBUG
         fprintf( stderr, "MulleObjC uses \"mulle_test_allocator_objc\" to detect leaks.\n");
#endif
      }
      (*ns_root_setup)( runtime, &config);

      is_pedantic = getenv( "MULLE_OBJC_PEDANTIC_EXIT") != NULL;
      if( is_test || is_pedantic)
         if( atexit( tear_down))
            perror( "atexit:");
   }
   return( runtime);
}


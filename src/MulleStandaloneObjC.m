//
//  MulleStandaloneObjC.c
//  MulleObjC
//
//  Created by Nat! on 04.02.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


// other files in this library
#import "MulleObjC.h"
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


static void  init_ns_exceptionhandlertable ( struct _ns_exceptionhandlertable *table)
{
   table->errno_error            = (void (*)()) perror_abort;
   table->allocation_error       = (void (*)()) abort;
   table->internal_inconsistency = (void (*)()) abort;
   table->invalid_argument       = (void (*)()) abort;
   table->invalid_index          = (void (*)()) abort;
   table->invalid_range          = (void (*)()) abort;
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


__attribute__((const))  // always returns same value (in same thread)
struct _mulle_objc_runtime  *__get_or_create_objc_runtime( void)
{
   struct _mulle_objc_runtime           *runtime;
   struct _ns_rootconfiguration         *rootconfig;
   extern struct mulle_allocator        mulle_objc_allocator;
   struct _ns_exceptionhandlertable     vectors;
   static struct _ns_root_setupconfig   config =
   {
      {
         NULL,
         versionassert,
         &NSObject_msgForward_method,
         NULL
      },
      {
         0,
         &mulle_allocator_objc,
         NULL
      }
   };
   int    is_test;
   BOOL   is_pedantic;
   char   *s;
   
   runtime = __mulle_objc_get_runtime();
   if( runtime->version)
      return( runtime);
   
   s       = getenv( "MULLE_OBJC_TEST_ALLOCATOR");
   is_test = s ? atoi( s) : 0;
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
         config.foundation.objectallocator = &mulle_test_allocator_objc;
      if( is_test & 0x2)
         config.runtime.allocator          = &mulle_test_allocator_objc;
#if DEBUG
      if( is_test & 0x3)
         fprintf( stderr, "MulleObjC uses \"mulle_test_allocator_objc\" to detect leaks.\n");
#endif
   }
   
   init_ns_exceptionhandlertable( &vectors);
   config.foundation.exceptiontable = &vectors;
   {
      _ns_root_setup( runtime, &config);
   }
   config.foundation.exceptiontable = NULL; // pedantic
   
   rootconfig = _mulle_objc_runtime_get_foundationdata( runtime);
   
   rootconfig->string.charsfromobject = (char *(*)()) return_self;
   rootconfig->string.objectfromchars = (void *(*)()) return_self;
   
   // if we retain zombies, we leak, so no point in looking for leaks
   is_pedantic = getenv( "MULLE_OBJC_PEDANTIC_EXIT") != NULL;
   if( is_pedantic || is_test)
   {
      if( rootconfig->object.zombieenabled && ! rootconfig->object.deallocatezombies)
         is_test = 0;
      if( atexit( is_test ? tear_down_and_check : tear_down))
         perror( "atexit:");
   }
   return( runtime);
}


//
// see: https://stackoverflow.com/questions/35998488/where-is-the-eprintf-symbol-defined-in-os-x-10-11/36010972#36010972
//
__attribute__((visibility("hidden")))
void __eprintf( const char* format, const char* file,
               unsigned line, const char *expr)
{
   fprintf( stderr, format, file, line, expr);
   abort();
}

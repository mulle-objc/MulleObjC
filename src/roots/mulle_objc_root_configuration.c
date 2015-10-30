//
//  MulleObjCRoots.m
//  mulle-objc-roots
//
//  Created by Nat! on 15/10/15.
//  Copyright © 2015 Mulle kybernetiK. All rights reserved.
//

// this is the only file that has an __attribute__ constructor
// this links in all the roots stuff into the runtime

#import "mulle_objc_root_configuration.h"

#import "_ns_exception.h"


# pragma mark -
# pragma mark Exceptions

static void  perror_abort( char *s)
{
   perror( s);
   abort();
}


static void  init_mulle_objc_exception_handler_table( struct _mulle_objc_exception_handler_table *table)
{
   unsigned int   i;
   
   for( i = 0; i <= _NSExceptionCharacterConversionHandlerIndex; i++)
      table->handlers[ i] = (i == _NSExceptionErrnoHandlerIndex) ? (void *) perror_abort : (void *) abort;
}


# pragma mark -
# pragma mark AutoreleasePool

static void   runtime_dies( struct _mulle_objc_runtime *runtime, void *data)
{
   struct         _MulleObjCRoots   *roots;
   extern void    _NSAutoreleasePoolConfigurationUnsetThread( void);

   _mulle_objc_runtime_get_foundation_space( runtime, (void **) &roots, NULL);
   if( data != roots)
      free( data);
}


/*
 * This function sets up a Foundation on a per thread
 * basis.
 */
struct _mulle_objc_root_configuration  *__mulle_objc_root_setup( void)
{
   size_t                              size;
   struct _mulle_objc_root_configuration  *roots;
   struct _mulle_objc_runtime          *runtime;
   struct _mulle_objc_runtime_friend   us;
   
   runtime = __mulle_objc_runtime_setup();
   runtime->class_defaults.inheritance = MULLE_OBJC_CLASS_DONT_INHERIT_PROTOCOL_CATEGORIES;
   
   _mulle_objc_runtime_get_foundation_space( runtime, (void **) &roots, &size);
   if( size < sizeof( struct _mulle_objc_root_configuration))
   {
      roots = calloc( 1, sizeof( struct _mulle_objc_root_configuration));
      if( ! roots)
         mulle_objc_raise_fail_errno_exception();
   }
   us.destructor = runtime_dies;
   us.data       = roots;

   roots->runtime = runtime;

   _mulle_objc_runtime_set_foundation( runtime, &us);
   
   return( roots);
}


struct _mulle_objc_runtime  *_mulle_objc_root_setup( void)
{
   struct _mulle_objc_root_configuration   *roots;
   
   roots = __mulle_objc_root_setup();
   
   init_mulle_objc_exception_handler_table( &roots->exceptions);

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
struct _mulle_objc_runtime   *(*mulle_objc_root_setup)( void) = _mulle_objc_root_setup;

mulle_thread_key_t   __mulle_objc_root_configurationKey;

//
// we assume worst case, that some other class is loading in faster than
// this is the "patch" in function, that is not defined by the objc
// runtime
//


/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSAutoreleasePool.m is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */

#import "NSAutoreleasePool.h"

#import "NSAllocation.h"
#import "NSAutoreleasePool+Private.h"
#import "NSDebug.h"
#import "NSObject.h"
#import "NSThread.h"
#include "ns_type.h"
#include "ns_zone.h"
#include "_ns_autoreleasepointerarray.h"
#include "ns_objc_include.h"


@interface _NSAutoreleasePoolPlaceholder : NSAutoreleasePool
@end


@implementation _NSAutoreleasePoolPlaceholder

+ (id) alloc                         { abort(); }
+ (id) allocWithZone:(NSZone *) zone { abort(); }

- (id) autorelease         { return( self); }
- (id) retain              { return( self); }
- (void) release           {}

- (id) init
{
   return( (id) NSPushAutoreleasePool());
}

@end


@implementation NSAutoreleasePool


static void                popAutoreleasePool( struct _NSAutoreleasePoolConfiguration *config, NSAutoreleasePool *pool);
static NSAutoreleasePool   *pushAutoreleasePool( struct _NSAutoreleasePoolConfiguration *config);

static id     _autoreleaseObject( struct _NSAutoreleasePoolConfiguration *config, id p);
static void   _autoreleaseObjects( struct _NSAutoreleasePoolConfiguration *config, id *objects, NSUInteger count);

mulle_thread_tss_t   _NSAutoreleasePoolConfigurationKey;
#if DEBUG
static Class         __NSAutoreleasePoolClass;
#endif

void   _NSAutoreleasePoolConfigurationSetThread( void)
{
   struct _NSAutoreleasePoolConfiguration   *config;
   mulle_thread_tss_t    key;
   
   key    = NSAutoreleasePoolUnfailingGetOrCreateThreadKey();
   
   config = _NSAllocateMemory( sizeof( struct _NSAutoreleasePoolConfiguration));

   config->poolClass          = [NSAutoreleasePool class];
#if DEBUG
   __NSAutoreleasePoolClass   = config->poolClass;
#endif
   config->autoreleaseObject  = _autoreleaseObject;
   config->autoreleaseObjects = _autoreleaseObjects;
   config->push               = pushAutoreleasePool;
   config->pop                = popAutoreleasePool;
   
   mulle_thread_tss_set( key, config);
   (*config->push)( config);  // create a pool
}


void   _NSAutoreleasePoolConfigurationUnsetThread( void)
{
   struct _NSAutoreleasePoolConfiguration   *config;
   
   config = _NSAutoreleasePoolConfiguration();
   
   // remove all pools
   while( config->tail)
      (*config->pop)( config, config->tail);
   _NSDeallocateMemory( config);
}


static inline NSZone   *_NSZoneFromAutoreleasePool( NSAutoreleasePool *pool)
{
   return( NSZoneFromPointer( pool));
}


static void  thread_dies( void *something)
{
}


mulle_thread_tss_t   NSAutoreleasePoolUnfailingGetOrCreateThreadKey()
{
   if( ! _NSAutoreleasePoolConfigurationKey)
      if( mulle_thread_tss_create( &_NSAutoreleasePoolConfigurationKey, thread_dies))
         mulle_objc_raise_fail_errno_exception();
   return( _NSAutoreleasePoolConfigurationKey);
}


static inline struct _ns_autoreleasepointerarray   *static_storage( struct _NSAutoreleasePoolConfiguration *config,
                                                NSAutoreleasePool *pool)
{
   size_t   size;
   
   size = _mulle_objc_class_get_instance_size( config->poolClass);
   return( (struct _ns_autoreleasepointerarray *) &((char *) pool)[ size]);
}


static inline void   addObject( NSAutoreleasePool *self, id p)
{
   struct _ns_autoreleasepointerarray   *array;
   
   if( ! self)
   {
      // or talk about leaking
      abort();
      return;
   }   
#if DEBUG   
   assert( p != nil);
   assert( _mulle_objc_object_get_class( p) != (struct _mulle_objc_class *) __NSAutoreleasePoolClass);
   assert( [p isProxy] || [p respondsToSelector:@selector( release)]);
#endif

   array = (struct _ns_autoreleasepointerarray *) self->_storage;
   if( !  _ns_autoreleasepointerarray_can_add( array))
   {
#ifndef DEBUG
      if( NSDebugEnabled)
#endif      
         if( array)
            fprintf( stderr, "Growing NSAutoreleasePool %p\n", self);
         
      self->_storage = array = _ns_autoreleasepointerarray_create( array);
   }
   _ns_autoreleasepointerarray_add( array, p);
}


static inline void   addObjects( NSAutoreleasePool *self, id *objects, NSUInteger count)
{
   NSUInteger                           amount;
   struct _ns_autoreleasepointerarray   *array;

   if( ! self)
   {
      // or talk about leaking
      abort();
      return;
   }   
   
#if DEBUG   
   {
      NSUInteger   i;
      id           p;

      for( i = 0; i < count; i++)
      {
         p = objects[ i];
         assert( p != nil);
         assert( _mulle_objc_object_get_class( p) !=  (struct _mulle_objc_class *) __NSAutoreleasePoolClass);
         assert( [p isProxy] || [p respondsToSelector:@selector( release)]);
      }
   }
#endif

   array  = self->_storage;
   while( count)
   {
      amount = array ? _ns_autoreleasepointerarray_space_left( array) : 0;
      if( ! amount)
      {
#ifndef DEBUG
         if( NSDebugEnabled)
#endif      
         if( array)
            fprintf( stderr, "Growing NSAutoreleasePool %p\n", self);
      
         self->_storage = array = _ns_autoreleasepointerarray_create( array);
         amount         = N_NS_OBJECT_C_ARRAY;
      }
      
      if( count < amount)
         amount = count;
      
      memcpy( &array->objects_[ array->used_], objects, amount);
      
      array->used_ += amount;
      objects       = &objects[ amount];
      count        -= amount;
   }
}


static id   _autoreleaseObject( struct _NSAutoreleasePoolConfiguration *config, id p)
{
   if( config->releasing)
   {
#if DEBUG
      if( ! config->tail)
      {
         fprintf( stderr, "*** There is no AutoreleasePool set up. Would leak! ***\n");
         abort();
         return( nil);
      }
#endif
      // must be within a pool releasing
      // --------------------------------------------------------------------
      // to release the object now, would be cool... alas not possible f.e.
      // for strings that are created on the fly in NSLog messages in dealloc
      // --------------------------------------------------------------------
#if FORBID_ALLOC_DURING_AUTORELEASE
      [p release];
      return( nil);
#endif
   }
#if defined( DEBUG) & ! defined( NO_AUTORELEASE_DEBUG)
   else
      [p __willBeAddedToAutoreleasePool:config->tail];
#endif
   addObject( config->tail, p);
   return( p);
}


static inline id  autoreleaseObject( id p)
{
   struct _NSAutoreleasePoolConfiguration   *config;
   
   config = _NSAutoreleasePoolConfiguration();
   return( _autoreleaseObject( config, p));
}


static void   _autoreleaseObjects( struct _NSAutoreleasePoolConfiguration *config, id *objects, NSUInteger count)
{
   if( ! objects || ! count)
      return;

   if( config->releasing)
   {
      _mulle_objc_objects_call_retain( (void **) objects, count);
      return;
   }
   
   addObjects( config->tail, objects, count);
}


static inline void   autoreleaseObjects( id *objects, NSUInteger count)
{
   struct _NSAutoreleasePoolConfiguration   *config;
   
   config = _NSAutoreleasePoolConfiguration();
   _autoreleaseObjects( config, objects, count);
}


- (void) addObject:(id) p
{
   autoreleaseObject( p);
}


+ (void) addObject:(id) p
{
   autoreleaseObject( p);
}


- (void) addObjects:(id *) objects
              count:(NSUInteger) count
{              
   autoreleaseObjects( objects, count);
}


+ (void) addObjects:(id *) objects
              count:(NSUInteger) count
{
   autoreleaseObjects( objects, count);
}


static NSAutoreleasePool  *pushAutoreleasePool( struct _NSAutoreleasePoolConfiguration *config)
{
   NSAutoreleasePool   *pool;
   struct _ns_autoreleasepointerarray      *array;
   
   //
   // avoid zeroing out the initial buffer
   //
   pool             = _NSAllocateNonZeroedObject( config->poolClass,
                                                  sizeof( struct _ns_autoreleasepointerarray), 
                                                  NULL);
   array            = static_storage( config, pool);
   pool->_storage   = array;
   array->used_     = 0;
   array->previous_ = NULL;

   pool->_owner     = config->tail;
   config->tail     = pool;

   config->releasing = 0;
   
   return( pool);
}


static void   popAutoreleasePool( struct _NSAutoreleasePoolConfiguration *config, NSAutoreleasePool *aPool)
{
   NSAutoreleasePool   *pool;
//   NSException         *exception;
   struct _ns_autoreleasepointerarray      *storage;
   
   assert( [aPool isKindOfClass:[NSAutoreleasePool class]]);
   
   pool = aPool;
   if( pool != config->tail)
   {
#if DEBUG   
      abort();
#endif      
      return;
   }
   
   config->releasing = 1;

//   exception = nil;
//NS_DURING
   // keep going until all is gone
   while( storage = pool->_storage)
   {
      pool->_storage = NULL;
      _ns_autoreleasepointerarray_release_and_free( storage, static_storage( config, pool));
   }
//NS_HANDLER
//   exception = localException;
//NS_ENDHANDLER

   // experimentally moved one down
   config->tail      = pool->_owner;
   config->releasing = config->tail == NULL;
   
//   [exception raise];
   
   NSDeallocateObject( pool);
}


static struct _NSObject   placeholder;

+ (void) load
{
   // MD5 ("NSThread") =
   extern void   _NSThreadMainThreadConfiguration( void);
   struct _mulle_objc_runtime   *runtime;
   
   runtime = __get_or_create_objc_runtime();
   if( _mulle_objc_runtime_lookup_class( runtime, MULLE_OBJC_CLASSID( 0xd8e30a39434366a7)))
      [NSThread makeRuntimeThread];

}


+ (void) initialize
{
   _mulle_objc_object_set_class( NSObjectFrom_NSObject( &placeholder), [_NSAutoreleasePoolPlaceholder class]);
   _mulle_objc_object_infinite_retain( NSObjectFrom_NSObject( &placeholder));
 }


+ (id) allocWithZone:(NSZone *) zone
{
   return( NSObjectFrom_NSObject( &placeholder));
}


+ (id) new
{
   return( NSPushAutoreleasePool());
}


- (id) retain
{
   abort();
   return( nil);
}


- (void) drain
{
   [self release];
}


- (NSUInteger) retainCount
{
   return( 1);
}


- (void) release
{
   NSAutoreleasePool                        *pool;
   struct _NSAutoreleasePoolConfiguration   *config;
   
   config = _NSAutoreleasePoolConfiguration();
   
   while( pool = config->tail)
   {
      (*config->pop)( config, pool);
      if( pool == self)
         return;
   }
   abort();  // popped too much
}


- (id) autorelease
{
   abort();
   return( nil);
}


- (void) dealloc
{
   abort();
}

@end


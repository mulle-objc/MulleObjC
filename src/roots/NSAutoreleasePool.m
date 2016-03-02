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

#import "NSAutoreleasePool+Private.h"
#import "NSAllocation.h"
#import "NSDebug.h"
#import "NSThread.h"
#include "ns_zone.h"
#include "_ns_autoreleasepointerarray.h"


#define AUTORELEASEPOOL_HASH   0x511c9ac972f81c49  // NSAutoreleasePool
#define THREAD_UNIQUEHASH      0xd8e30a39434366a7  // NSThread
#define PLACEHOLDER_HASH       0xb234d7412f0f951f  // MulleObjCAutoreleasePoolPlaceholder


@interface MulleObjCAutoreleasePoolPlaceholder : NSAutoreleasePool
@end


@implementation MulleObjCAutoreleasePoolPlaceholder

+ (id) alloc                         { abort(); }
+ (id) allocWithZone:(NSZone *) zone { abort(); }

- (id) init
{
   return( (id) NSPushAutoreleasePool());
}

@end


@implementation NSAutoreleasePool

static void                popAutoreleasePool( struct MulleObjCAutoreleasePoolConfiguration *config,
                                               NSAutoreleasePool *pool);
static NSAutoreleasePool   *pushAutoreleasePool( struct MulleObjCAutoreleasePoolConfiguration *config);

static void   _autoreleaseObject( struct MulleObjCAutoreleasePoolConfiguration *config, id p);
static void   _autoreleaseObjects( struct MulleObjCAutoreleasePoolConfiguration *config,
                                   id *objects, NSUInteger count);

mulle_thread_tss_t   MulleObjCAutoreleasePoolConfigurationKey;
#if DEBUG
static Class         __NSAutoreleasePoolClass;
#endif



void   MulleObjCAutoreleasePoolConfigurationSetThread( void)
{
   struct MulleObjCAutoreleasePoolConfiguration   *config;
   mulle_thread_tss_t    key;
   
   key    = NSAutoreleasePoolUnfailingGetOrCreateThreadKey();
   
   config = MulleObjCAllocateMemory( sizeof( struct MulleObjCAutoreleasePoolConfiguration));

   config->poolClass          = mulle_objc_unfailing_get_or_lookup_class( MULLE_OBJC_CLASSID( AUTORELEASEPOOL_HASH));
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


void   MulleObjCAutoreleasePoolConfigurationUnsetThread( void)
{
   struct MulleObjCAutoreleasePoolConfiguration   *config;
   
   config = MulleObjCAutoreleasePoolConfiguration();
   
   // remove all pools
   while( config->tail)
      (*config->pop)( config, config->tail);
   MulleObjCDeallocateMemory( config);
}


static void  thread_dies( void *something)
{
}


mulle_thread_tss_t   NSAutoreleasePoolUnfailingGetOrCreateThreadKey()
{
   if( ! MulleObjCAutoreleasePoolConfigurationKey)
      if( mulle_thread_tss_create( &MulleObjCAutoreleasePoolConfigurationKey, thread_dies))
         mulle_objc_raise_fail_errno_exception();
   return( MulleObjCAutoreleasePoolConfigurationKey);
}


static inline struct _mulle_autoreleasepointerarray   *static_storage( struct MulleObjCAutoreleasePoolConfiguration *config,
                                                NSAutoreleasePool *pool)
{
   size_t   size;
   
   size = _mulle_objc_class_get_instance_size( config->poolClass);
   return( (struct _mulle_autoreleasepointerarray *) &((char *) pool)[ size]);
}


static inline void   addObject( NSAutoreleasePool *self, id p)
{
   struct _mulle_autoreleasepointerarray   *array;
   
   if( ! self)
   {
      // or talk about leaking
      abort();
   }   
#if DEBUG   
   assert( p != nil);
   assert( _mulle_objc_object_get_isa( p) != (struct _mulle_objc_class *) __NSAutoreleasePoolClass);
   assert( [p isProxy] || [p respondsToSelector:@selector( release)]);
#endif

   array = (struct _mulle_autoreleasepointerarray *) self->_storage;
   if( !  _mulle_autoreleasepointerarray_can_add( array))
   {
#ifndef DEBUG
      if( NSDebugEnabled)
#endif      
         if( array)
            fprintf( stderr, "Growing NSAutoreleasePool %p\n", self);
         
      self->_storage = array = _mulle_autoreleasepointerarray_create( array);
   }
   _mulle_autoreleasepointerarray_add( array, p);
}


static inline void   addObjects( NSAutoreleasePool *self, id *objects, NSUInteger count)
{
   NSUInteger                           amount;
   struct _mulle_autoreleasepointerarray   *array;

   if( ! self)
   {
      // or talk about leaking
      abort();
   }   
   
#if DEBUG   
   {
      NSUInteger   i;
      id           p;

      for( i = 0; i < count; i++)
      {
         p = objects[ i];
         assert( p != nil);
         assert( _mulle_objc_object_get_isa( p) !=  (struct _mulle_objc_class *) __NSAutoreleasePoolClass);
         assert( [p isProxy] || [p respondsToSelector:@selector( release)]);
      }
   }
#endif

   array  = self->_storage;
   while( count)
   {
      amount = array ? _mulle_autoreleasepointerarray_space_left( array) : 0;
      if( ! amount)
      {
#ifndef DEBUG
         if( NSDebugEnabled)
#endif      
         if( array)
            fprintf( stderr, "Growing NSAutoreleasePool %p\n", self);
      
         self->_storage = array = _mulle_autoreleasepointerarray_create( array);
         amount         = N_MULLE_OBJECT_C_ARRAY;
      }
      
      if( count < amount)
         amount = count;
      
      memcpy( &array->objects_[ array->used_], objects, amount);
      
      array->used_ += amount;
      objects       = &objects[ amount];
      count        -= amount;
   }
}


+ (NSAutoreleasePool *) defaultAutoreleasePool
{
   struct MulleObjCAutoreleasePoolConfiguration   *config;
   NSAutoreleasePool   *pool;
   
   config = MulleObjCAutoreleasePoolConfiguration();
   return( config->tail);
}


+ (NSAutoreleasePool *) parentAutoreleasePool
{
   struct MulleObjCAutoreleasePoolConfiguration   *config;
   NSAutoreleasePool   *pool;
   
   config = MulleObjCAutoreleasePoolConfiguration();
   pool   = config->tail;
   if( pool)
      pool = pool->_owner;
   return( pool);
}


- (NSAutoreleasePool *) parentAutoreleasePool
{
   return( self->_owner);
}


static void   _autoreleaseObject( struct MulleObjCAutoreleasePoolConfiguration *config, id p)
{
   if( config->releasing)
   {
#if DEBUG
      if( ! config->tail)
      {
         fprintf( stderr, "*** There is no AutoreleasePool set up. Would leak! ***\n");
         abort();
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
}


static inline void  autoreleaseObject( id p)
{
   struct MulleObjCAutoreleasePoolConfiguration   *config;
   
   config = MulleObjCAutoreleasePoolConfiguration();
   _autoreleaseObject( config, p);
}


static void   _autoreleaseObjects( struct MulleObjCAutoreleasePoolConfiguration *config, id *objects, NSUInteger count)
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
   struct MulleObjCAutoreleasePoolConfiguration   *config;
   
   config = MulleObjCAutoreleasePoolConfiguration();
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


static NSAutoreleasePool  *pushAutoreleasePool( struct MulleObjCAutoreleasePoolConfiguration *config)
{
   NSAutoreleasePool                       *pool;
   struct _mulle_autoreleasepointerarray   *array;
   
   //
   // avoid zeroing out the initial buffer
   //
   pool             = MulleObjCAllocateNonZeroedObject( config->poolClass,
                                                  sizeof( struct _mulle_autoreleasepointerarray), 
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


static void   popAutoreleasePool( struct MulleObjCAutoreleasePoolConfiguration *config, NSAutoreleasePool *aPool)
{
   NSAutoreleasePool                       *pool;
//   NSException         *exception;
   struct _mulle_autoreleasepointerarray   *storage;
   
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
      _mulle_autoreleasepointerarray_release_and_free( storage, static_storage( config, pool));
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




static struct MulleObjCObjectWithHeader   placeholder;


+ (void) load
{
   struct _mulle_objc_runtime   *runtime;
   
   runtime = __get_or_create_objc_runtime();
   if( _mulle_objc_runtime_lookup_class( runtime, MULLE_OBJC_CLASSID( THREAD_UNIQUEHASH)))
      [NSThread _instantiateRuntimeThread];
}


+ (void) initialize
{
   struct _mulle_objc_class     *cls;
   struct _mulle_objc_runtime   *runtime;
   
   cls = mulle_objc_unfailing_get_or_lookup_class( MULLE_OBJC_CLASSID( PLACEHOLDER_HASH));
   _mulle_objc_object_set_isa( MulleObjCObjectWithHeaderGetObject( &placeholder), cls);
   _mulle_objc_object_infinite_retain( MulleObjCObjectWithHeaderGetObject( &placeholder));
}


+ (id) alloc
{
   return( MulleObjCObjectWithHeaderGetObject( &placeholder));
}


+ (id) allocWithZone:(NSZone *) zone
{
   return( MulleObjCObjectWithHeaderGetObject( &placeholder));
}


+ (id) new
{
   return( (id) NSPushAutoreleasePool());
}


- (void) drain
{
   [self dealloc];
}


- (void) finalize
{
}


- (void) dealloc
{
   NSAutoreleasePool                              *pool;
   struct MulleObjCAutoreleasePoolConfiguration   *config;
   
   config = MulleObjCAutoreleasePoolConfiguration();
   
   while( pool = config->tail)
   {
      (*config->pop)( config, pool);
      if( pool == self)
      {
         mulle_objc_checkin_current_thread();
         return;
      }
   }
   
   abort();  // popped too much, throw an exception
}

@end


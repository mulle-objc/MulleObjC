//
//  NSAutoreleasePool.m
//  MulleObjC
//
//  Copyright (c) 2011 Nat! - Mulle kybernetiK.
//  Copyright (c) 2011 Codeon GmbH.
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

#import "NSAutoreleasePool.h"

// other files in this library
#import "MulleObjCAllocation.h"
#import "MulleObjCProtocol.h"
#import "MulleObjCAutoreleasePool.h"
#import "MulleObjCExceptionHandler.h"
#import "MulleObjCExceptionHandler-Private.h"
#import "NSDebug.h"
#import "NSZone.h"
#import "mulle-objc-autoreleasepointerarray-private.h"

// other libraries of MulleObjCFoundation

// std-c and dependencies


#ifdef DEBUG
# define DEBUG_MAX_OBJECTS
#endif

static void   mulle_objc_make_class_boring( Class self)
{
   struct _mulle_objc_class   *infra;
   struct _mulle_objc_class   *meta;

   infra = (struct _mulle_objc_class *) self;
   _mulle_objc_class_set_state_bit( infra, MULLE_OBJC_CLASS_IS_BORING_ALLOCATION);

   meta = (struct _mulle_objc_class *) 
            _mulle_objc_infraclass_get_metaclass( (struct _mulle_objc_infraclass *) infra);
   _mulle_objc_class_set_state_bit( meta, MULLE_OBJC_CLASS_IS_BORING_ALLOCATION);
}


void   *_mulle_objc_object_autorelease( void *obj)
{
   struct _mulle_objc_poolconfiguration   *config;
   struct _mulle_objc_universe            *universe;

   universe = _mulle_objc_object_get_universe( obj);
   config   = mulle_objc_thread_get_poolconfiguration( universe);
   (*config->autoreleaseObject)( config, obj);
   return( obj);
}


@implementation NSAutoreleasePool

+ (void) load 
{
   mulle_objc_make_class_boring( self);
}


static void   popAutoreleasePool( struct _mulle_objc_poolconfiguration *config,
                                  id pool);
static void   *pushAutoreleasePool( struct _mulle_objc_poolconfiguration *config);

static void   _autoreleaseObject( struct _mulle_objc_poolconfiguration *config, id p);
static void   _autoreleaseObjects( struct _mulle_objc_poolconfiguration *config,
                                   id *objects,
                                   NSUInteger count,
                                   NSUInteger step);

static struct mulle_container_keyvaluecallback    object_map_callback;


void   _mulle_objc_poolconfiguration_init( struct _mulle_objc_poolconfiguration *config, Class poolClass)
{
   char   *s;

   assert( config);

   config->poolClass = poolClass;

   //
   // If autorelease pools are using the "default" allocator, they show up in
   // memorytraces a lot, which is usually boring
   //
   _mulle_objc_infraclass_set_allocator( config->poolClass, &mulle_stdlib_allocator);

   config->autoreleaseObject  = _autoreleaseObject;
   config->autoreleaseObjects = _autoreleaseObjects;
   config->push               = pushAutoreleasePool;
   config->pop                = popAutoreleasePool;
   config->object_map         = NULL;

#ifndef DEBUG
   if( mulle_objc_environment_get_yes_no( "MULLE_OBJC_AUTORELEASEPOOL_MAP"))
#endif
   {
      object_map_callback.keycallback   = mulle_container_keycallback_nonowned_pointer;
      object_map_callback.valuecallback = mulle_container_valuecallback_intptr;
      _mulle_map_init( &config->_object_map,
                       1024,
                       &object_map_callback,
                       &mulle_stdlib_allocator);  // keep debug stuff out
      config->object_map = &config->_object_map;
   }

#ifdef DEBUG_MAX_OBJECTS
   s = getenv( "MULLE_OBJC_AUTORELEASEPOOL_MAX");
   if( s && strlen( s))
   {
      config->maxObjects = atoi( s);
   }
#endif

   s = getenv( "MULLE_OBJC_TRACE_AUTORELEASEPOOL");
   if( s && strlen( s))
   {
      config->trace = atoi( s);
      if( ! config->trace && (*s != '0' && *s != 'N'))
         config->trace = 0xFF;
   }
}


void   _mulle_objc_poolconfiguration_reset( struct _mulle_objc_poolconfiguration *config)
{
   assert( config);

   // remove all pools
   while( config->tail)
      (*config->pop)( config, config->tail);
   (*config->push)( config);  // create a pool
}


void   _mulle_objc_poolconfiguration_done( struct _mulle_objc_poolconfiguration *config)
{
   assert( config);

   // remove all pools
   while( config->tail)
      (*config->pop)( config, config->tail);

   if( config->object_map == &config->_object_map)
   {
      _mulle_map_done( &config->_object_map);
      config->object_map = NULL;
   }
}


static void   _mulle_objc_thread_set_poolconfiguration( struct _mulle_objc_universe *universe,
                                                        struct _mulle_objc_poolconfiguration *config)
{
   Class   poolClass;

   poolClass = mulle_objc_universe_lookup_infraclass_nofail( universe,
                                                             @selector( NSAutoreleasePool));
   _mulle_objc_poolconfiguration_init( config, poolClass);
   (*config->push)( config);  // create a pool
}


void   mulle_objc_thread_new_poolconfiguration( struct _mulle_objc_universe *universe)
{
   if( universe)
      _mulle_objc_thread_set_poolconfiguration( universe,
                                                mulle_objc_thread_get_poolconfiguration( universe));
}


void   mulle_objc_thread_reset_poolconfiguration( struct _mulle_objc_universe *universe)
{
   struct _mulle_objc_poolconfiguration   *config;

   config = mulle_objc_thread_get_poolconfiguration( universe);
   assert( config);

   _mulle_objc_poolconfiguration_reset( config);
}


void   mulle_objc_thread_done_poolconfiguration( struct _mulle_objc_universe *universe)
{
   struct _mulle_objc_poolconfiguration   *config;

   config = mulle_objc_thread_get_poolconfiguration( universe);
   assert( config);

   _mulle_objc_poolconfiguration_done( config);
}


- (char *) mulleNameUTF8String
{
   return( _mulleNameUTF8String[ 0] ? &_mulleNameUTF8String[ 0] : "unnamed");
}


- (void) mulleSetNameUTF8String:(char *) s
{
   strncpy( _mulleNameUTF8String, s ? s : "", sizeof( _mulleNameUTF8String) - 1);
}


//
// Apparently not used anymore
//
// //
// // it is clear now, due to dependencies
// // that NSThread +load runs after NSAutoreleasePool
// // ...
// // so maybe this piece of load code should be done
// // in NSThread now ?
// //
// void  NSAutoreleasePoolLoader( struct _mulle_objc_universe *universe)
// {
//    struct _mulle_objc_poolconfiguration      *config;
//    struct _mulle_objc_threadinfo             *threadconfig;
//    struct _mulle_objc_threadfoundationinfo   *local;
//
//    threadconfig = _mulle_objc_thread_get_threadinfo( universe);
//    if( ! threadconfig)
//       return;
//
//    local  = _mulle_objc_threadinfo_get_foundationspace( threadconfig);
//    config = &local->poolconfig;
//
//    if( config->object_map)
//       _mulle_map_done( config->object_map);
//
//    _mulle_objc_thread_set_poolconfiguration( universe, config);
// }


static inline struct _mulle_autoreleasepointerarray   *
   static_storage( struct _mulle_objc_poolconfiguration *config,
                   NSAutoreleasePool *pool)
{
   size_t   size;

   size = _mulle_objc_infraclass_get_instancesize( config->poolClass);
   return( (struct _mulle_autoreleasepointerarray *) &((char *) pool)[ size]);
}


static inline void   addObject( struct _mulle_objc_poolconfiguration *config, id p)
{
   struct _mulle_autoreleasepointerarray   *array;
   NSAutoreleasePool                       *pool;

   pool = config->tail;

#ifndef NDEBUG
   struct _mulle_objc_universe *universe;

   assert( pool != nil);
   assert( p != nil);
   universe = _mulle_objc_object_get_universe( p);
   assert( _mulle_objc_object_get_isa( p));
   assert( _mulle_objc_class_get_universe( _mulle_objc_object_get_isa( p)) ==
           _mulle_objc_infraclass_get_universe( _mulle_objc_thread_get_autoreleasepoolclass( universe))) ;
   assert( _mulle_objc_object_get_infraclass( p) != _mulle_objc_thread_get_autoreleasepoolclass( universe));
// this messages ObjC too much, which gets boring in traces
//   assert( [p isProxy] || [p respondsToSelector:@selector( release)]);
#endif

   array = (struct _mulle_autoreleasepointerarray *) pool->_storage;

#ifdef DEBUG
   if( config->maxObjects)
   {
      if( _mulle_autoreleasepointerarray_count( array) >= config->maxObjects)
      {
         fprintf( stderr, "[pool] %p is growing too much\n", pool);
         abort();
      }
   }
#endif

   if( ! _mulle_autoreleasepointerarray_can_add( array))
   {
      array          = _mulle_autoreleasepointerarray_create( array);
      pool->_storage = array;
   }

   _mulle_autoreleasepointerarray_add( array, p);
}


/* objects can have space between them:
 * ex.  objects = struct a { id a; intptr_t x; }[ 120];
 *      addObjects( self, objects, 120, sizeof( struct a))
 */
static inline void   addObjects( struct _mulle_objc_poolconfiguration *config,
                                 id *objects,
                                 NSUInteger count,
                                 NSUInteger step)
{
   NSUInteger                              amount;
   struct _mulle_autoreleasepointerarray   *array;
   NSAutoreleasePool                       *pool;

   pool = config->tail;

   assert( step >= sizeof( id));

   if( ! pool)
   {
      // or talk about leaking
      abort();
   }

#if DEBUG
   {
      char   *p;
      char   *sentinel;
      id     q;

      p        = (char *) objects;
      sentinel = &p[ step * count];

      while( p < sentinel)
      {
         q  = *(id *) p;
         p += step;

         assert( q != nil);
         assert( _mulle_objc_object_get_infraclass( q) != _mulle_objc_object_get_infraclass( pool));
         // assert( [q isProxy] || [q respondsToSelector:@selector( release)]);
      }
   }
#endif

   array  = pool->_storage;

#ifdef DEBUG_MAX_OBJECTS
   if( config->maxObjects)
   {
      if( _mulle_autoreleasepointerarray_count( array) + count >= config->maxObjects)
      {
         fprintf( stderr, "[pool] %p is growing too much\n", pool);
         abort();
      }
   }
#endif

   while( count)
   {
      amount = array ? _mulle_autoreleasepointerarray_space_left( array) : 0;
      if( ! amount)
      {
         pool->_storage = array = _mulle_autoreleasepointerarray_create( array);
         amount         = MULLE_AUTORELEASEPOINTERARRRAY_N_OBJECTS;
      }

      if( count < amount)
         amount = count;

      if( step != sizeof( id))
      {
         char   *p;
         char   *sentinel;
         id     *dst;

         dst      = &array->objects[ array->used];
         p        = (char *) objects;
         sentinel = &p[ step * amount];

         while( p < sentinel)
         {
            *dst++ = *(id *) p;
            p     += step;
         }
         objects = (id *) p;
      }
      else
      {
         mulle_id_copy( &array->objects[ array->used], objects, amount);
         objects = &objects[ amount];
      }

      array->used += amount;
      count        -= amount;
   }
}


+ (NSAutoreleasePool *) mulleDefaultAutoreleasePool
{
   struct _mulle_objc_poolconfiguration   *config;
   struct _mulle_objc_universe            *universe;

   universe = _mulle_objc_infraclass_get_universe( self);
   config   = mulle_objc_thread_get_poolconfiguration( universe);
   return( config->tail);
}


+ (NSAutoreleasePool *) mulleParentAutoreleasePool
{
   NSAutoreleasePool                      *pool;
   struct _mulle_objc_poolconfiguration   *config;
   struct _mulle_objc_universe            *universe;

   universe = _mulle_objc_infraclass_get_universe( self);
   config   = mulle_objc_thread_get_poolconfiguration( universe);
   pool     = config->tail;
   if( pool)
      pool = pool->_owner;
   return( pool);
}


- (NSAutoreleasePool *) mulleParentAutoreleasePool
{
   return( self->_owner);
}


//
// autoreleaseObject
//
static void   _autoreleaseObject( struct _mulle_objc_poolconfiguration *config, id p)
{
   NSUInteger   count;

   if( ! config->tail)
   {
      if( config->trace)
         fprintf( stderr, "[pool] %p tried to autorelease with no pool in place\n", p);
#if DEBUG
      fprintf( stderr, "*** There is no AutoreleasePool set up. Would leak! ***\n");
      abort();
#endif
      return;
   }

#if FORBID_ALLOC_DURING_AUTORELEASE
   if( config->releasing)
   {
      // must be within a pool releasing
      // --------------------------------------------------------------------
      // to release the object now, would be cool... alas not possible f.e.
      // for strings that are created on the fly in NSLog messages in dealloc
      // or finalize
      // --------------------------------------------------------------------
      if( config->trace & 0x2)
         fprintf( stderr, "[pool] %p (RC: %ld) immediate release from pool %p\n",
                                  p,
                                  mulle_objc_object_get_retaincount( p),
                                  config->tail);
      [p release];
      return( nil);
   }
#endif

   if( config->object_map)
   {
      count = (NSUInteger) mulle_map_get( config->object_map, p) + 1;
      mulle_map_set( config->object_map, p, (void *) count);
   }

   addObject( config, p);

   if( config->trace & 0x1)
      fprintf( stderr, "[pool] object %p (RC: %ld) added to storage %p of pool %p\n",
                           p,
                           (long) mulle_objc_object_get_retaincount( p),
                           ((NSAutoreleasePool *) config->tail)->_storage,
                           config->tail);
}


static inline void   autoreleaseObject( id p, struct _mulle_objc_universe *universe)
{
   struct _mulle_objc_poolconfiguration   *config;

   config = mulle_objc_thread_get_poolconfiguration( universe);
   _autoreleaseObject( config, p);
}



- (void) addObject:(id) p
{
   autoreleaseObject( p, _mulle_objc_object_get_universe( self));
}


+ (void) addObject:(id) p
{
   autoreleaseObject( p, _mulle_objc_infraclass_get_universe( self));
}


//
// autoreleaseObjects
//

static void   _autoreleaseObjects( struct _mulle_objc_poolconfiguration *config,
                                   id *objects,
                                   NSUInteger count,
                                   NSUInteger step)
{
   id          *p;
   id          *sentinel;
   NSUInteger  value;

   if( ! objects || ! count)
      return;

   if( ! config->tail)
   {
      if( config->trace)
         fprintf( stderr, "[pool] trying to autorelease %lu objects "
                          "at %p with no pool in place\n", (long) count, objects);
#if DEBUG
      fprintf( stderr, "*** There is no AutoreleasePool set up. Would leak! ***\n");
      abort();
#endif
      return;
   }

#if FORBID_ALLOC_DURING_AUTORELEASE
   if( config->releasing)
   {
      _mulle_objc_objects_release( (void **) objects, count);
      return;
   }
#endif

   if( config->object_map)
   {
      p        = objects;
      sentinel = &p[ count];
      while( p < sentinel)
      {
         value = (NSUInteger) mulle_map_get( config->object_map, *p) + 1;
         mulle_map_set( config->object_map, *p, (void *) value);
         ++p;
      }
   }

   addObjects( config, objects, count, step);

   if( config->trace & 0x1)
   {
      id   *sentinel;

      fprintf( stderr, "[pool] added objects to pool %p:\n", config->tail);
      sentinel = &objects[ count];

      do
         fprintf( stderr, "\t%p\n", *objects);
      while( ++objects < sentinel);
   }
}


static inline void   autoreleaseObjects( id *objects,
                                         NSUInteger count,
                                         struct _mulle_objc_universe *universe)
{
   struct _mulle_objc_poolconfiguration   *config;

   config = mulle_objc_thread_get_poolconfiguration( universe);
   _autoreleaseObjects( config, objects, count, sizeof( id));
}


- (void) mulleAddObjects:(id *) objects
               count:(NSUInteger) count
{
   autoreleaseObjects( objects, count, _mulle_objc_object_get_universe( self));
}


+ (void) mulleAddObjects:(id *) objects
               count:(NSUInteger) count
{
   autoreleaseObjects( objects, count, _mulle_objc_object_get_universe( self));
}


//
// contains
//
static inline int   mulleContainsObject( NSAutoreleasePool *self, id p)
{
   struct _mulle_autoreleasepointerarray   *array;

   if( ! self)
      return( 0);

   array = (struct _mulle_autoreleasepointerarray *) self->_storage;
   if( ! array)
      return( 0);

   return( _mulle_autoreleasepointerarray_contains( array, p));
}


- (BOOL) mulleContainsObject:(id) p
{
   struct _mulle_objc_poolconfiguration   *config;
   struct _mulle_objc_universe            *universe;

   universe = _mulle_objc_object_get_universe( self);
   config   = mulle_objc_thread_get_poolconfiguration( universe);
   return( mulleContainsObject( config->tail, p));
}


+ (BOOL) mulleContainsObject:(id) p
{
   NSAutoreleasePool                      *pool;
   struct _mulle_objc_poolconfiguration   *config;
   struct _mulle_objc_universe            *universe;

   universe = _mulle_objc_object_get_universe( self);
   config   = mulle_objc_thread_get_poolconfiguration( universe);
   if( config->object_map)
      return( (NSUInteger) mulle_map_get( config->object_map, p) != 0);

   for( pool = config->tail; pool; pool = pool->_owner)
      if( mulleContainsObject( pool, p))
         return( YES);

   return( NO);
}


//
// count
//
static inline int   mulleCountObject( NSAutoreleasePool *self, id p)
{
   struct _mulle_autoreleasepointerarray   *array;

   if( ! self)
      return( 0);

   array = (struct _mulle_autoreleasepointerarray *) self->_storage;
   if( ! array)
      return( 0);

   return( _mulle_autoreleasepointerarray_count_object( array, p));
}


- (NSUInteger) mulleCountObject:(id) p;
{
   struct _mulle_objc_poolconfiguration   *config;
   struct _mulle_objc_universe            *universe;

   universe = _mulle_objc_object_get_universe( self);
   config   = mulle_objc_thread_get_poolconfiguration( universe);
   return( mulleCountObject( config->tail, p));
}


+ (NSUInteger) mulleCountObject:(id) p;
{
   NSAutoreleasePool                      *pool;
   NSUInteger                             count;
   struct _mulle_objc_poolconfiguration   *config;
   struct _mulle_objc_universe            *universe;

   universe = _mulle_objc_object_get_universe( self);
   config   = mulle_objc_thread_get_poolconfiguration( universe);
   if( config->object_map)
      return( (NSUInteger) mulle_map_get( config->object_map, p));

   count  = 0;
   for( pool = config->tail; pool; pool = pool->_owner)
      count += mulleCountObject( pool, p);

   return( count);
}


static inline unsigned int   mulleCount( NSAutoreleasePool *self)
{
   struct _mulle_autoreleasepointerarray   *array;

   if( ! self)
      return( 0);

   array = (struct _mulle_autoreleasepointerarray *) self->_storage;
   if( ! array)
      return( 0);

   return( _mulle_autoreleasepointerarray_count( array));
}


- (NSUInteger) mulleCount
{
   struct _mulle_objc_poolconfiguration   *config;
   struct _mulle_objc_universe            *universe;

   universe = _mulle_objc_object_get_universe( self);
   config   = mulle_objc_thread_get_poolconfiguration( universe);
   return( mulleCount( config->tail));
}


+ (NSUInteger) mulleCount
{
   NSAutoreleasePool                      *pool;
   NSUInteger                             count;
   struct _mulle_objc_poolconfiguration   *config;
   struct _mulle_objc_universe            *universe;

   universe = _mulle_objc_object_get_universe( self);
   config   = mulle_objc_thread_get_poolconfiguration( universe);

   count    = 0;
   for( pool = config->tail; pool; pool = pool->_owner)
      count += mulleCount( pool);

   return( count);
}


//
// Release is taking objects out of the NSAutoreleasePool and destroying
// them "early". This should only be done via -mulleRelinquishAccess.
// It leaves holes in the NSAutoreleasePool.
//
static inline void   releaseObjects( NSAutoreleasePool *self,
                                     id *p,
                                     NSUInteger n,
                                     struct mulle_map *object_map)
{
   struct _mulle_autoreleasepointerarray   *array;

   if( ! self)
      return;

   array = (struct _mulle_autoreleasepointerarray *) self->_storage;
   if( ! array)
      return;

   _mulle_autoreleasepointerarray_release_objects( array, p, n, object_map);
}



- (void) mulleReleasePoolObjects:(id *) p
                       count:(NSUInteger) count
{
   struct _mulle_objc_poolconfiguration   *config;
   struct _mulle_objc_universe            *universe;

   universe = _mulle_objc_object_get_universe( self);
   config   = mulle_objc_thread_get_poolconfiguration( universe);
   releaseObjects( config->tail, p, count, config->object_map);
}


+ (void) mulleReleasePoolObjects:(id *) p
                       count:(NSUInteger) count
{
   NSAutoreleasePool                      *pool;
   struct _mulle_objc_poolconfiguration   *config;
   struct _mulle_objc_universe            *universe;

   universe = _mulle_objc_object_get_universe( self);
   config   = mulle_objc_thread_get_poolconfiguration( universe);

   for( pool = config->tail; pool; pool = pool->_owner)
      releaseObjects( pool, p, count, config->object_map);
}


//
// push / pop pools
//
static void   *pushAutoreleasePool( struct _mulle_objc_poolconfiguration *config)
{
   NSAutoreleasePool                       *pool;
   struct _mulle_autoreleasepointerarray   *array;
   size_t                                  size;

   //
   // avoid zeroing out the initial buffer
   //
   size  = sizeof( struct _mulle_autoreleasepointerarray);
   pool  = _MulleObjCClassAllocateNonZeroedObject( config->poolClass, size);
   array = static_storage( config, pool);

   // init all pool ivars(!)
   pool->_storage    = array;
   pool->_owner      = config->tail;

   array->used       = 0;
   array->previous   = NULL;

   config->tail      = pool;
   config->releasing = 0;

   if( config->trace & 0x4)
      fprintf( stderr, "[pool] pushed pool %p in thread 0x%lx\n", pool, (long) mulle_thread_self());

   return( pool);
}


static void   releaseAllObjectsInPool( struct _mulle_objc_poolconfiguration *config,
                                       NSAutoreleasePool *pool)
{
   struct _mulle_autoreleasepointerarray   *storage;

   while( storage = pool->_storage)
   {
      pool->_storage = NULL;
      if( config->trace & 0x2)
      {
         fprintf( stderr, "[pool] %p releases objects of storage %p\n", pool, storage);

         _mulle_autoreleasepointerarray_dump_objects( storage,
                                                      "releases",
                                                      static_storage( config, pool));
      }
      _mulle_autoreleasepointerarray_release_and_free( storage,
                                                       static_storage( config, pool),
                                                       config->object_map);
   }
}


static void   popAutoreleasePool( struct _mulle_objc_poolconfiguration *config, id aPool)
{
   NSAutoreleasePool   *pool;
//   NSException         *exception;

   assert( config);
   assert( aPool);

   if( config->trace & 0x4)
      fprintf( stderr, "[pool] popping to pool %p in thread 0x%lx\n",
                        aPool, (long) mulle_thread_self());
   do
   {
      pool = config->tail;
      if( ! pool)
      {
         fprintf( stderr, "[pool] asked to pop to pool %p that didn't exist in "
                          "thread 0x%lx\n", aPool, (long) mulle_thread_self());
         abort();
      }

      config->releasing = 1;

      if( config->trace & 0x4)
         fprintf( stderr, "[pool] popping pool %p in thread 0x%lx\n",
                           pool, (long) mulle_thread_self());

   //   exception = nil;
   //NS_DURING
      // keep going until all is gone
      releaseAllObjectsInPool( config, pool);
   //NS_HANDLER
   //   exception = localException;
   //NS_ENDHANDLER

      // experimentally moved one down
      config->tail      = pool->_owner;
      config->releasing = (config->tail == NULL);

   //   [exception raise];
      if( config->trace & 0x4)
         fprintf( stderr, "[pool] %p pool deallocates\n", pool);
      _MulleObjCInstanceFree( pool);
   }
   while( pool != aPool);
}


+ (instancetype) alloc
{
   struct _mulle_objc_universe   *universe;

   universe = _mulle_objc_infraclass_get_universe( self);
   return( (id) __MulleAutoreleasePoolPush( universe));
}


+ (instancetype) new
{
   struct _mulle_objc_universe   *universe;

   universe = _mulle_objc_infraclass_get_universe( self);
   return( (id) __MulleAutoreleasePoolPush( universe));
}


- (instancetype) init
{
   return( self);
}


+ (Class) class
{
   return( self);
}


- (Class) class
{
   return( _mulle_objc_object_get_infraclass( self));
}


// untested!
- (void) mulleReleaseAllPoolObjects
{
   struct _mulle_objc_poolconfiguration   *config;
   struct _mulle_objc_universe            *universe;

   universe = _mulle_objc_object_get_universe( self);
   config   = mulle_objc_thread_get_poolconfiguration( universe);
   releaseAllObjectsInPool( config, self);
}


// called by the compiler... for @autoreleasepool
- (void) drain
{
   [self release];
}



- (instancetype) retain       MULLE_OBJC_THREADSAFE_METHOD
{
   abort();
}


- (void) release
{
   _mulle_objc_object_release_inline( self);
}


- (void) finalize
{
}


- (void) dealloc
{
   NSAutoreleasePool                      *pool;
   struct _mulle_objc_poolconfiguration   *config;
   struct _mulle_objc_universe            *universe;

   universe = _mulle_objc_object_get_universe( self);
   config   = mulle_objc_thread_get_poolconfiguration( universe);

   while( pool = config->tail)
   {
      (*config->pop)( config, pool);
      if( pool == self)
      {
         _mulle_objc_thread_checkin_universe_gc( universe);
         return;
      }
   }

   abort();  // popped too much, throw an exception
}


@end


#pragma clang diagnostic ignored "-Wobjc-root-class"


@interface _MulleObjCAutoreleaseAllocation < MulleObjCThreadSafe>
{
	void                     *_pointer;
	struct mulle_allocator   *_allocator;
}

- (void) release                          MULLE_OBJC_THREADSAFE_METHOD;
- (BOOL) isProxy                          MULLE_OBJC_THREADSAFE_METHOD;
- (BOOL) respondsToSelector:(SEL) sel     MULLE_OBJC_THREADSAFE_METHOD;

@end


@implementation _MulleObjCAutoreleaseAllocation

+ (void) load 
{
   mulle_objc_make_class_boring( self);
}


+ (id) newWithPointer:(void *) pointer
            allocator:(struct mulle_allocator *) allocator
{
	_MulleObjCAutoreleaseAllocation   *allocation;

	if( ! pointer)
		return( nil);

	allocation = _MulleObjCClassAllocateInstance( self, 0);
	allocation->_pointer   = pointer;
	allocation->_allocator = allocator;
	return( allocation);
}


static void   dealloc( _MulleObjCAutoreleaseAllocation *self)
{
   mulle_allocator_free( self->_allocator, self->_pointer);
   _MulleObjCInstanceFree( self);
}


- (void) dealloc
{
   dealloc( self);
}


// called by inline release
- (void) finalize
{
}

// we are just in an autoreleasepool and don't retaincount
- (void) release
{
   dealloc( self);
}


- (BOOL) isProxy
{
	return( NO);
}


- (BOOL) respondsToSelector:(SEL) sel
{
	return( sel == @selector( release));
}

@end



void   *MulleObjCAutoreleaseAllocation( void *pointer, struct mulle_allocator *allocator)
{
	_MulleObjCAutoreleaseAllocation   *allocation;

	allocation = [_MulleObjCAutoreleaseAllocation newWithPointer:pointer
																		allocator:allocator];
	NSAutoreleaseObject( allocation);
   // relieve register pressure
   return( pointer);  // sic ! allocation is unknown to caller
}


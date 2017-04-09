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

#import "NSAutoreleasePool.h"

// other files in this library
#import "MulleObjCAllocation.h"
#import "NSDebug.h"
#import "NSThread.h"
#include "ns_zone.h"
#include "_ns_autoreleasepointerarray.h"

// other libraries of MulleObjCFoundation

// std-c and dependencies



#define NSAUTORELEASEPOOL_HASH   0x5b791fc6  // NSAutoreleasePool

@implementation NSAutoreleasePool

static void   popAutoreleasePool( struct _ns_poolconfiguration *config,
                                  id pool);
static void   *pushAutoreleasePool( struct _ns_poolconfiguration *config);

static void   _autoreleaseObject( struct _ns_poolconfiguration *config, id p);
static void   _autoreleaseObjects( struct _ns_poolconfiguration *config,
                                   id *objects,
                                   NSUInteger count,
                                   NSUInteger step);

static struct mulle_container_keyvaluecallback    object_map_callback;


static void   __ns_poolconfiguration_set_thread( struct _ns_poolconfiguration  *config)
{
   char   *s;

   config->poolClass          = mulle_objc_unfailing_get_or_lookup_infraclass( MULLE_OBJC_CLASSID( NSAUTORELEASEPOOL_HASH));
   config->autoreleaseObject  = _autoreleaseObject;
   config->autoreleaseObjects = _autoreleaseObjects;
   config->push               = pushAutoreleasePool;
   config->pop                = popAutoreleasePool;
   config->object_map         = NULL;

#ifndef DEBUG
   if( getenv( "MULLE_OBJC_AUTORELEASEPOOL_MAP"))
#endif
   {
      object_map_callback.keycallback   = mulle_container_keycallback_nonowned_pointer;
      object_map_callback.valuecallback = mulle_container_valuecallback_intptr;
      mulle_map_init( &config->_object_map,
                      1024,
                      &object_map_callback,
                      &mulle_stdlib_allocator);  // keep debug stuff out
      config->object_map = &config->_object_map;
   }

   s             = getenv( "MULLE_OBJC_AUTORELEASEPOOL_TRACE");
   config->trace = s ? atoi( s) : 0;
   (*config->push)( config);  // create a pool
}


void   _ns_poolconfiguration_set_thread( void)
{
   __ns_poolconfiguration_set_thread( _ns_get_poolconfiguration());
}


//
// if NSThread ran before, it can't have setup the main autoreleasepool yet
// fix that...
//
+ (void) load
{
   struct _ns_poolconfiguration          *config;
   struct _mulle_objc_threadconfig       *threadconfig;
   struct _ns_threadlocalconfiguration   *local;

   threadconfig = mulle_objc_get_threadconfig();
   if( ! threadconfig)
      return;

   local  = _mulle_objc_threadconfig_get_foundationspace( threadconfig);
   config = &local->poolconfig;

   if( config->object_map)
      mulle_map_done( config->object_map);

   __ns_poolconfiguration_set_thread( config);
}


void   _ns_poolconfiguration_unset_thread( void)
{
   struct _ns_poolconfiguration   *config;

   config = _ns_get_poolconfiguration();
   assert( config);

   // remove all pools
   while( config->tail)
      (*config->pop)( config, config->tail);
}


static inline struct _mulle_autoreleasepointerarray   *static_storage( struct _ns_poolconfiguration *config,
                                                NSAutoreleasePool *pool)
{
   size_t   size;

   size = _mulle_objc_infraclass_get_instancesize( config->poolClass);
   return( (struct _mulle_autoreleasepointerarray *) &((char *) pool)[ size]);
}


static inline int   _containsObject( NSAutoreleasePool *self, id p)
{
   struct _mulle_autoreleasepointerarray   *array;

   if( ! self)
      return( 0);

   array = (struct _mulle_autoreleasepointerarray *) self->_storage;
   if( ! array)
      return( 0);

   return( _mulle_autoreleasepointerarray_contains( array, p));
}


static inline int   _countObject( NSAutoreleasePool *self, id p)
{
   struct _mulle_autoreleasepointerarray   *array;

   if( ! self)
      return( 0);

   array = (struct _mulle_autoreleasepointerarray *) self->_storage;
   if( ! array)
      return( 0);

   return( _mulle_autoreleasepointerarray_count_object( array, p));
}


static inline void   addObject( NSAutoreleasePool *self, id p)
{
   struct _mulle_autoreleasepointerarray   *array;

   assert( self != nil);
   assert( p != nil);
   assert( _mulle_objc_object_get_isa( p));
   assert( _mulle_objc_class_get_runtime( _mulle_objc_object_get_isa( p)) ==
           _mulle_objc_infraclass_get_runtime( _ns_get_autoreleasepoolclass())) ;
   assert( _mulle_objc_object_get_infraclass( p) != _ns_get_autoreleasepoolclass());
   assert( [p isProxy] || [p respondsToSelector:@selector( release)]);

   array = (struct _mulle_autoreleasepointerarray *) self->_storage;
   if( ! _mulle_autoreleasepointerarray_can_add( array))
   {
      array          = _mulle_autoreleasepointerarray_create( array);
      self->_storage = array;
   }
   _mulle_autoreleasepointerarray_add( array, p);
}


/* objects can have space between them
 * ex.  objects = struct { id a; intptr_t x; }[ 120];
 *      addObjects( self, objects, 120, sizeof( id) + sizeof( intptr_t))
 */
static inline void   addObjects( NSAutoreleasePool *self,
                                 id *objects,
                                 NSUInteger count,
                                 NSUInteger step)
{
   NSUInteger                              amount;
   struct _mulle_autoreleasepointerarray   *array;

   assert( step >= sizeof( id));

   if( ! self)
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
         assert( _mulle_objc_object_get_infraclass( q) !=_ns_get_autoreleasepoolclass());
         assert( [q isProxy] || [q respondsToSelector:@selector( release)]);
      }
   }
#endif

   array  = self->_storage;
   while( count)
   {
      amount = array ? _mulle_autoreleasepointerarray_space_left( array) : 0;
      if( ! amount)
      {
         self->_storage = array = _mulle_autoreleasepointerarray_create( array);
         amount         = MULLE_AUTORELEASEPOINTERARRRAY_N_OBJECTS;
      }

      if( count < amount)
         amount = count;

      if( step != sizeof( id))
      {
         char   *p;
         char   *sentinel;
         id     *dst;

         dst      = &array->objects_[ array->used_];
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
         memcpy( &array->objects_[ array->used_], objects, sizeof( id) * amount);
         objects = &objects[ amount];
      }

      array->used_ += amount;
      count        -= amount;
   }
}


+ (NSAutoreleasePool *) _defaultAutoreleasePool
{
   struct _ns_poolconfiguration   *config;

   config = _ns_get_poolconfiguration();
   return( config->tail);
}


+ (NSAutoreleasePool *) _parentAutoreleasePool
{
   struct _ns_poolconfiguration   *config;
   NSAutoreleasePool              *pool;

   config = _ns_get_poolconfiguration();
   pool   = config->tail;
   if( pool)
      pool = pool->_owner;
   return( pool);
}


- (NSAutoreleasePool *) _parentAutoreleasePool
{
   return( self->_owner);
}


static void   _autoreleaseObject( struct _ns_poolconfiguration *config, id p)
{
   NSUInteger   count;

#if DEBUG
   if( ! config->tail)
   {
      fprintf( stderr, "*** There is no AutoreleasePool set up. Would leak! ***\n");
      abort();
   }
#endif

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
         fprintf( stderr, "[pool] %p immediately releases object %p\n", config->tail, p);
      [p release];
      return( nil);
   }
#endif

   if( config->object_map)
   {
      count = (NSUInteger) mulle_map_get( config->object_map, p) + 1;
      mulle_map_set( config->object_map, p, (void *) count);
   }

   addObject( config->tail, p);

   if( config->trace & 0x1)
      fprintf( stderr, "[pool] %p added object %p to storage %p\n",
                           config->tail,
                           p,
                           ((NSAutoreleasePool *) config->tail)->_storage);
}


static inline void   autoreleaseObject( id p)
{
   struct _ns_poolconfiguration   *config;

   config = _ns_get_poolconfiguration();
   _autoreleaseObject( config, p);
}


static void   _autoreleaseObjects( struct _ns_poolconfiguration *config,
                                   id *objects,
                                   NSUInteger count,
                                   NSUInteger step)
{
   id          *p;
   id          *sentinel;
   NSUInteger  value;

   if( ! objects || ! count)
      return;

#if FORBID_ALLOC_DURING_AUTORELEASE
   if( config->releasing)
   {
      _mulle_objc_objects_call_release( (void **) objects, count);
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

   addObjects( config->tail, objects, count, step);

   if( config->trace & 0x1)
   {
      id   *sentinel;

      fprintf( stderr, "[pool] %p added objects:\n", config->tail);
      sentinel = &objects[ count];

      do
         fprintf( stderr, "\t%p\n", *objects);
      while( ++objects < sentinel);
   }
}


static inline void   autoreleaseObjects( id *objects, NSUInteger count)
{
   struct _ns_poolconfiguration   *config;

   config = _ns_get_poolconfiguration();
   _autoreleaseObjects( config, objects, count, sizeof( id));
}


- (void) addObject:(id) p
{
   autoreleaseObject( p);
}


+ (void) addObject:(id) p
{
   autoreleaseObject( p);
}


- (void) _addObjects:(id *) objects
              count:(NSUInteger) count
{
   autoreleaseObjects( objects, count);
}


+ (void) _addObjects:(id *) objects
              count:(NSUInteger) count
{
   autoreleaseObjects( objects, count);
}


- (BOOL) _containsObject:(id) p
{
   struct _ns_poolconfiguration   *config;

   config = _ns_get_poolconfiguration();
   return( _containsObject( config->tail, p));
}


- (NSUInteger) _countObject:(id) p;
{
   struct _ns_poolconfiguration   *config;

   config = _ns_get_poolconfiguration();
   return( _countObject( config->tail, p));
}


+ (BOOL) _containsObject:(id) p
{
   struct _ns_poolconfiguration   *config;
   NSAutoreleasePool              *pool;

   config = _ns_get_poolconfiguration();
   if( config->object_map)
      return( (NSUInteger) mulle_map_get( config->object_map, p) != 0);

   for( pool = config->tail; pool; pool = pool->_owner)
      if( _containsObject( pool, p))
         return( YES);

   return( NO);
}


+ (NSUInteger) _countObject:(id) p;
{
   struct _ns_poolconfiguration   *config;
   NSAutoreleasePool              *pool;
   NSUInteger                     count;

   config = _ns_get_poolconfiguration();
   if( config->object_map)
      return( (NSUInteger) mulle_map_get( config->object_map, p));

   count  = 0;
   for( pool = config->tail; pool; pool = pool->_owner)
      count += _countObject( pool, p);

   return( count);
}


static void   *pushAutoreleasePool( struct _ns_poolconfiguration *config)
{
   NSAutoreleasePool                       *pool;
   struct _mulle_autoreleasepointerarray   *array;

   //
   // avoid zeroing out the initial buffer
   //
   pool             = _MulleObjCClassAllocateNonZeroedObject( config->poolClass,
                                                        sizeof( struct _mulle_autoreleasepointerarray));
   array            = static_storage( config, pool);

   // init all pool ivars(!)
   pool->_storage   = array;
   pool->_owner     = config->tail;

   array->used_     = 0;
   array->previous_ = NULL;

   config->tail      = pool;
   config->releasing = 0;

   if( config->trace & 0x4)
      fprintf( stderr, "[pool] pushed %p in thread 0x%lx\n", pool, (long) mulle_thread_self());

   return( pool);
}


static void   popAutoreleasePool( struct _ns_poolconfiguration *config, id aPool)
{
   NSAutoreleasePool                       *pool;
//   NSException         *exception;
   struct _mulle_autoreleasepointerarray   *storage;

   assert( config);
   assert( aPool);

   pool = aPool;
   if( pool != config->tail)
   {
#if DEBUG
      abort();
#endif
      return;
   }

   config->releasing = 1;

   if( config->trace & 0x4)
      fprintf( stderr, "[pool] popping %p in thread 0x%lx\n", pool, (long) mulle_thread_self());

//   exception = nil;
//NS_DURING
   // keep going until all is gone
   while( storage = pool->_storage)
   {
      pool->_storage = NULL;
      if( config->trace & 0x2)
      {
         fprintf( stderr, "[pool] %p releases objects of storage %p\n", pool, storage);

         _mulle_autoreleasepointerarray_dump_objects( storage, static_storage( config, pool));
      }
      _mulle_autoreleasepointerarray_release_and_free( storage, static_storage( config, pool), config->object_map);
   }
//NS_HANDLER
//   exception = localException;
//NS_ENDHANDLER

   // experimentally moved one down
   config->tail      = pool->_owner;
   config->releasing = (config->tail == NULL);

//   [exception raise];

   if( config->trace & 0x4)
      fprintf( stderr, "[pool] %p deallocates\n", pool);
   NSDeallocateObject( pool);
}


+ (id) alloc
{
   return( (id) NSPushAutoreleasePool());
}


+ (id) new
{
   return( (id) NSPushAutoreleasePool());
}


- (id) init
{
   return( self);
}


- (id) retain
{
   abort();
}


- (void) drain
{
   [self release];
}


- (void) release
{
   _mulle_objc_object_release( self);
}


- (void) finalize
{
}


- (void) dealloc
{
   NSAutoreleasePool              *pool;
   struct _ns_poolconfiguration   *config;

   config = _ns_get_poolconfiguration();

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

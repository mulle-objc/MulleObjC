//
//  NSAutoreleasePool.h
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
#import "MulleObjCRuntimeObject.h"

#import "MulleObjCAutoreleasePool.h"


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-root-class"


//
// if you feel the need to subclass this, change the
// NSAutoreleasePoolConfiguration, to use your functions
// Be careful when touching a running system
// This is not a subclass of NSObject, because it really is different
//
// A NSAutoreleasePool is not even a MulleObjCRuntimeObject, you can't do
// much with it. As a consequence of it being a root object, instance methods
// like -init or -mulleNameUTF8String will wrap around, so be careful.
//
@interface NSAutoreleasePool
{
   NSAutoreleasePool   *_owner;
   void                *_storage;
   char                _mulleNameUTF8String[ 48];
}

// MEMO: this is marked as threadsafe, but that's because its assumed
//       you set it only during initialization. Its sort of a blemish
//       (compare with NSThread: -mulleNameUTF8String)
//       returns address of pool if uninitialized
@property( dynamic, assign) char  *mulleNameUTF8String   MULLE_OBJC_THREADSAFE_PROPERTY;

+ (id) alloc;
+ (id) new;
- (id) init;

+ (Class) class         MULLE_OBJC_THREADSAFE_METHOD;
- (Class) class         MULLE_OBJC_THREADSAFE_METHOD;
- (void) release        MULLE_OBJC_THREADSAFE_METHOD;

+ (void) addObject:(id) object;
- (void) addObject:(id) object;

#pragma mark mulle additions:

+ (void) mulleAddObjects:(id *) objects
                   count:(NSUInteger) count;
- (void) mulleAddObjects:(id *) objects
                   count:(NSUInteger) count;

+ (NSAutoreleasePool *) mulleDefaultAutoreleasePool;
+ (NSAutoreleasePool *) mulleParentAutoreleasePool;
- (NSAutoreleasePool *) mulleParentAutoreleasePool;

//
// these only check within the current thread, these routines are
// not fast as they search linearly. only useful for debugging
//
- (BOOL) mulleContainsObject:(id) p;
- (NSUInteger) mulleCountObject:(id) p;

+ (BOOL) mulleContainsObject:(id) p;
+ (NSUInteger) mulleCountObject:(id) p;

// untested! This like -drain, but the autoreleasepool stays in place
// so its somewhat nicer than:
//
//    NSPopAutoreleasePool( pool);
//    pool = NSPushAutoreleasePool();
- (void) mulleReleaseAllPoolObjects;


//
// just do the specific autoreleasepool, find all objects that match
// and immediately release them. Of course your thread must not touch any
// of these objects thereafter
//
+ (void) mulleReleasePoolObjects:(id *) p
                           count:(NSUInteger) count;
- (void) mulleReleasePoolObjects:(id *) p
                           count:(NSUInteger) count;

//
// Returns YES, if 'p' has autoreleases
//
+ (BOOL) mulleContainsObject:(id) p;
- (BOOL) mulleContainsObject:(id) p;


// count number of autoreleases for object
+ (NSUInteger) mulleCountObject:(id) p;
- (NSUInteger) mulleCountObject:(id) p;

// just for statistical interest, these are not distinct objects but
// "autoreleases"
//
+ (NSUInteger) mulleCount;
- (NSUInteger) mulleCount;

@end



#pragma clang diagnostic pop


//
// in MulleFoundation there is always a root NSAutoreleasePool, ergo this
// can't leak. Thread local autorelease pools don't have to be thread safe
//
static inline NSAutoreleasePool   *__MulleAutoreleasePoolPush( struct _mulle_objc_universe *universe)
{
   struct _mulle_objc_poolconfiguration   *config;

   if( ! universe)
      return( NULL);

   config = mulle_objc_thread_get_poolconfiguration( universe);
   return( (*config->push)( config));
}

//
// this is what the compiler should call, when @autoreleasepool is used
//
static inline NSAutoreleasePool   *_MulleAutoreleasePoolPush( mulle_objc_universeid_t universeid)
{
   struct _mulle_objc_universe   *universe;

   universe = mulle_objc_global_get_universe_inline( universeid);
   return( __MulleAutoreleasePoolPush( universe));
}


static inline NSAutoreleasePool   *MulleAutoreleasePoolPush( void)
{
   return( _MulleAutoreleasePoolPush( __MULLE_OBJC_UNIVERSEID__));
}


// we ignore the size
static inline NSAutoreleasePool   *NSPushAutoreleasePool( unsigned int size)
{
   struct _mulle_objc_universe   *universe;

   universe = mulle_objc_global_get_universe_inline( MULLE_OBJC_DEFAULTUNIVERSEID);
   return( __MulleAutoreleasePoolPush( universe));
}


static inline void   MulleAutoreleasePoolPop( NSAutoreleasePool *pool)
{
   struct _mulle_objc_poolconfiguration   *config;
   struct _mulle_objc_universe            *universe;

   if( pool)
   {
      universe = _mulle_objc_object_get_universe( pool);
      config   = mulle_objc_thread_get_poolconfiguration( universe);
      (*config->pop)( config, pool);
   }
}


//
// Apple crashes if pool is NULL
// otherwise the autorelease pool unwinds until and including NSAutoreleasePool
//
static inline void   NSPopAutoreleasePool( NSAutoreleasePool *pool)
{
   MulleAutoreleasePoolPop( pool);
}


// the compiler will inline this directly
MULLE_C_ALWAYS_INLINE
static inline id   NSAutoreleaseObject( id obj)
{
   if( obj)
      _MulleObjCAutoreleaseObject( obj);
   return( obj);
}



//
// Use this in the debugger in a breakpoint, then all threads are stopped
// and the output should be meaningful. You get a CSV file, which you can
// then import into sqlite and then post-process, like this for example:
//
// .mode csv
// .import 'pooldump.stdout' data
// .headers on
//
// CREATE TABLE NSThread AS
// SELECT DISTINCT thread_id, thread AS thread_name
// FROM data;
//
// CREATE TABLE NSAutoreleasePool AS
// SELECT DISTINCT pool_id, pool AS pool_name, thread_id
// FROM data;
//
// CREATE TABLE pool_objects AS
// SELECT DISTINCT pool_id, thread_id, object_id
// FROM data;
//
// CREATE TABLE objects AS
// SELECT
//     object_id,
//     object AS object_name,
//     class AS class_name,
//     rc AS retain_count,
//     (SELECT COUNT(*) FROM data AS d WHERE d.object_id = data.object_id) AS pool_count
// FROM
//     data
// GROUP BY
//     object_id, object, class, rc;
//
// Remember that objects that are "roots", which are also autoreleased
// somewhere will have diverging pool_count and retain_count.
//
// Next escalation would be to have SQL on our objects live...
//

MULLE_OBJC_GLOBAL
void   MulleObjCDumpAutoreleasePoolsToFile( char *filename);

MULLE_OBJC_GLOBAL
void   MulleObjCDumpAutoreleasePoolsToFileIndexed( char *filename);

MULLE_OBJC_GLOBAL
void   MulleObjCDumpAutoreleasePoolsToFILEWithOptions( FILE *fp, int indexed);

//
// MEMO: like the functions above, you should only use them when you
//       are in the debugger and a breakpoint has happened, but for debugging
//       you can sometimes get by even in running programs, if threads are
//       waiting for each other.
//
MULLE_OBJC_GLOBAL
unsigned long   MulleObjCDumpAutoreleasePoolsFrame( void);

/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSAutoreleasePool.h is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSObject.h"

#import "NSThread.h"
#import "ns_threadconfiguration.h"


//
// if you feel the need to subclass this, change the
// NSAutoreleasePoolConfiguration, to use your functions
// Be careful when touching a running system
// This is not a subclass of NSObject, because it really is different
//
@interface NSAutoreleasePool
{
   NSAutoreleasePool   *_owner;
   void                *_storage;
}

+ (void) addObjects:(id *) objects
              count:(NSUInteger) count;
- (void) addObjects:(id *) objects
              count:(NSUInteger) count;
+ (void) addObject:(id) object;
- (void) addObject:(id) object;

+ (NSAutoreleasePool *) defaultAutoreleasePool;
+ (NSAutoreleasePool *) parentAutoreleasePool;
- (NSAutoreleasePool *) parentAutoreleasePool;

// mulle addition:
- (BOOL) containsObject:(id) p;

@end


//
// in MulleFoundation there is always a root NSAutoreleasePool, ergo this
// can't leak. Thread local autorelease pools don't have to be thread safe
//
static inline NSAutoreleasePool   *NSPushAutoreleasePool()
{
   struct _ns_poolconfiguration   *config;
   
   config = _ns_get_poolconfiguration();
   return( (*config->push)( config));
}


static inline void   NSPopAutoreleasePool( NSAutoreleasePool *pool)
{
   struct _ns_poolconfiguration   *config;
   
   config = _ns_get_poolconfiguration();
   (*config->pop)( config, pool);
}


static inline void   _MulleObjCAutoreleaseObject( id obj)
{
   struct _ns_poolconfiguration   *config;
   
   config = _ns_get_poolconfiguration();
   (*config->autoreleaseObject)( config, obj);
}


// the compiler will inline this directly
__attribute__((always_inline))
static inline id   NSAutoreleaseObject( id obj)
{
   if( obj)
      _MulleObjCAutoreleaseObject( obj);
   return( obj);
}


// for NSThread
void   _ns_poolconfiguration_set_thread( void);
void   _ns_poolconfiguration_unset_thread( void);

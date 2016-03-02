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


@class NSAutoreleasePool;

#pragma mark -
#pragma mark MulleObjCAutoreleasePoolConfiguration

//
// these are shortcuts for the currently active pool in this thread
//
struct MulleObjCAutoreleasePoolConfiguration
{
   void                (*autoreleaseObject)( struct MulleObjCAutoreleasePoolConfiguration *, id);
   void                (*autoreleaseObjects)( struct MulleObjCAutoreleasePoolConfiguration *, id *, NSUInteger);

   NSAutoreleasePool   *tail;
   Class               poolClass;
   
   NSAutoreleasePool   *(*push)( struct MulleObjCAutoreleasePoolConfiguration *);
   void                (*pop)( struct MulleObjCAutoreleasePoolConfiguration *, NSAutoreleasePool *pool);

   int                 releasing;
};



static inline struct MulleObjCAutoreleasePoolConfiguration   *MulleObjCAutoreleasePoolConfiguration( void)
{
   extern mulle_thread_tss_t               MulleObjCAutoreleasePoolConfigurationKey;
   struct MulleObjCAutoreleasePoolConfiguration  *config;
   
   assert( MulleObjCAutoreleasePoolConfigurationKey);
   config = mulle_thread_tss_get( MulleObjCAutoreleasePoolConfigurationKey);
   assert( config);
   return( config);
}


__attribute__((const))
mulle_thread_tss_t   NSAutoreleasePoolUnfailingGetOrCreateThreadKey( void);

void   MulleObjCAutoreleasePoolConfigurationSetThread( void);
void   MulleObjCAutoreleasePoolConfigurationUnsetThread( void);


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

@end


//
// in MulleFoundation there is always a root NSAutoreleasePool, ergo this
// can't leak. Thread local autorelease pools don't have to be thread safe
//
static inline NSAutoreleasePool   *NSPushAutoreleasePool()
{
   struct MulleObjCAutoreleasePoolConfiguration   *config;
   
   config = MulleObjCAutoreleasePoolConfiguration();
   return( (*config->push)( config));
}


static inline void   NSPopAutoreleasePool( NSAutoreleasePool *pool)
{
   struct MulleObjCAutoreleasePoolConfiguration   *config;
   
   config = MulleObjCAutoreleasePoolConfiguration();
   (*config->pop)( config, pool);
}


static inline void   _MulleObjCAutoreleaseObject( id obj)
{
   struct MulleObjCAutoreleasePoolConfiguration   *config;
   
   config = MulleObjCAutoreleasePoolConfiguration();
   (*config->autoreleaseObject)( config, obj);
}


// the compile will inline this directly
__attribute__((always_inline))
static inline id   NSAutoreleaseObject( id obj)
{
   if( obj)
      _MulleObjCAutoreleaseObject( obj);
   return( obj);
}


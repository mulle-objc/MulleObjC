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
#import "NSObjectProtocol.h"


@class NSAutoreleasePool;

#pragma mark -
#pragma mark _NSAutoreleasePoolConfiguration

//
// these are shortcuts for the currently active pool in this thread
//
struct _NSAutoreleasePoolConfiguration
{
   id                  (*autoreleaseObject)( struct _NSAutoreleasePoolConfiguration *, id);
   void                (*autoreleaseObjects)( struct _NSAutoreleasePoolConfiguration *, id *, NSUInteger);

   NSAutoreleasePool   *tail;
   Class               poolClass;
   
   NSAutoreleasePool   *(*push)( struct _NSAutoreleasePoolConfiguration *);
   void                (*pop)( struct _NSAutoreleasePoolConfiguration *, NSAutoreleasePool *pool);

   int                 releasing;
};


static inline struct _NSAutoreleasePoolConfiguration   *_NSAutoreleasePoolConfiguration( void)
{
   extern mulle_thread_tss_t               _NSAutoreleasePoolConfigurationKey;
   struct _NSAutoreleasePoolConfiguration  *config;
   
   config = mulle_thread_tss_get( _NSAutoreleasePoolConfigurationKey);
   assert( config);
   return( config);
}


mulle_thread_tss_t   NSAutoreleasePoolUnfailingGetOrCreateThreadKey( void);

void   _NSAutoreleasePoolConfigurationSetThread( void);
void   _NSAutoreleasePoolConfigurationUnsetThread( void);


//
// if you feel the need to subclass this, change the
// NSAutoreleasePoolConfiguration, to use your functions
// Be careful when touching a running system
// This is not a subclass of NSObject, because it really is different
//
@interface NSAutoreleasePool <NSObject>
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

@end


//
// in MulleFoundation there is always a root NSAutoreleasePool, ergo this
// can't leak. Thread local autorelease pools don't have to be thread safe
//
static inline NSAutoreleasePool   *NSPushAutoreleasePool()
{
   struct _NSAutoreleasePoolConfiguration   *config;
   
   config = _NSAutoreleasePoolConfiguration();
   return( (*config->push)( config));
}


static inline void   NSPopAutoreleasePool( NSAutoreleasePool *pool)
{
   struct _NSAutoreleasePoolConfiguration   *config;
   
   config = _NSAutoreleasePoolConfiguration();
   (*config->pop)( config, pool);
}


static inline id   _NSAutoreleaseObject( id obj)
{
   struct _NSAutoreleasePoolConfiguration   *config;
   
   config = _NSAutoreleasePoolConfiguration();
   return( (*config->autoreleaseObject)( config, obj));
}


// the compile will inline this directly
static inline id   NSAutoreleaseObject( id obj)
{
   return( obj ? _NSAutoreleaseObject( obj) : obj);
}


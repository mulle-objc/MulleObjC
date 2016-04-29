//
//  ns_threadconfiguration.h
//  MulleObjC
//
//  Created by Nat! on 04.03.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#ifndef ns_threadconfiguration_h__
#define ns_threadconfiguration_h__

#include "ns_type.h"


//
// these are shortcuts for the currently active pool in this thread
//
struct _ns_poolconfiguration
{
   void   (*autoreleaseObject)( struct _ns_poolconfiguration *, id);
   void   (*autoreleaseObjects)( struct _ns_poolconfiguration *, id *, NSUInteger, NSUInteger);
   
   id                         tail;     // NSAutoreleasepool
   struct _mulle_objc_class   *poolClass;
   
   void   *(*push)( struct _ns_poolconfiguration *);
   void   (*pop)( struct _ns_poolconfiguration *, id pool);
   
   int    releasing;
   int    trace;
};


struct _ns_threadlocalconfiguration
{
   struct _ns_poolconfiguration   poolconfig;

   void                           *thread;
   void                           *userinfo;
};


static inline struct _ns_threadlocalconfiguration   *_ns_get_threadlocalconfiguration( void)
{
   struct _mulle_objc_threadconfig       *threadconfig;
   struct _ns_threadlocalconfiguration   *local;

   assert( S_MULLE_OBJC_THREADCONFIG_FOUNDATION_SPACE >= sizeof( struct _ns_threadlocalconfiguration));

   threadconfig = mulle_objc_get_threadconfig();
   assert( threadconfig);
   
   local = _mulle_objc_threadconfig_get_foundationspace( threadconfig);
   return( local);
}


static inline void   *_ns_get_thread_userinfo( void)
{
   return( _ns_get_threadlocalconfiguration()->userinfo);
}


static inline void   _ns_set_thread_userinfo( void *userinfo)
{
   _ns_get_threadlocalconfiguration()->userinfo = userinfo;
}


static inline void   *_ns_get_thread( void)
{
   return( _ns_get_threadlocalconfiguration()->thread);
}


static inline void   _ns_set_thread( void *thread)
{
   _ns_get_threadlocalconfiguration()->thread = thread;
}


static inline struct _ns_poolconfiguration   *_ns_get_poolconfiguration( void)
{
   return( &_ns_get_threadlocalconfiguration()->poolconfig);
}


static inline struct _mulle_objc_class   *_ns_get_autoreleasepoolclass( void)
{
   return( _ns_get_threadlocalconfiguration()->poolconfig.poolClass);
}


#endif /* ns_threadconfiguration_h */

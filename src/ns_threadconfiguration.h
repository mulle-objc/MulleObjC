//
//  ns_threadconfiguration.h
//  MulleObjC
//
//  Copyright (c) 2016 Nat! - Mulle kybernetiK.
//  Copyright (c) 2016 Codeon GmbH.
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

#ifndef ns_threadconfiguration_h__
#define ns_threadconfiguration_h__

#include "ns_objc_type.h"
#include "ns_int_type.h"


//
// these are shortcuts for the currently active pool in this thread
//
struct _ns_poolconfiguration
{
   void   (*autoreleaseObject)( struct _ns_poolconfiguration *, id);
   void   (*autoreleaseObjects)( struct _ns_poolconfiguration *, id *, NSUInteger, NSUInteger);

   id                         tail;        // NSAutoreleasepool
   struct _mulle_objc_class   *poolClass;
   struct mulle_map           *object_map;
   struct mulle_map           _object_map;

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

   threadconfig = _mulle_objc_get_threadconfig();
   if( ! threadconfig)
   {
      // looks like we are in a "foreign" thread
      // make it our own
      _NSThreadNewRuntimeThread();
      threadconfig = _mulle_objc_get_threadconfig();
      if( ! threadconfig)
         mulle_objc_throw_internal_inconsistency_exception( "could not make the current thread a MulleObjC thread");
   }
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

/*
 *  MulleObjCCore.h
 *  MulleFoundation
 *
 *  Created by Nat! on 19.08.11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */
#ifndef ns_rootconfiguration__h__
#define ns_rootconfiguration__h__

//
// this is defined here for standalone. a "real" foundation will want to
// produce their own.
//
#define MULLE_OBJC_VERSION_MAJOR  0
#define MULLE_OBJC_VERSION_MINOR  3
#define MULLE_OBJC_VERSION_PATCH  0

#define MULLE_OBJC_VERSION               \
     ((MULLE_OBJC_VERSION_MAJOR << 20) | \
      (MULLE_OBJC_VERSION_MINOR << 8)  | \
       MULLE_OBJC_VERSION_PATCH)

#include "ns_objc_include.h"
#include "ns_type.h"
#include "_ns_exception.h"

#pragma mark -
#pragma mark per thread runtime configuration

struct _ns_objectconfiguration
{
   struct mulle_set         *roots;

   // single out some known classes into their own sets
   struct mulle_set         *placeholders;
   struct mulle_set         *singletons;
   struct mulle_set         *threads;
   
   unsigned char            debugenabled;
   unsigned char            zombieenabled;
   unsigned char            deallocatezombies;
   unsigned char            unused;
};


struct _ns_threadconfiguration
{
   volatile BOOL             is_multi_threaded;
   mulle_atomic_pointer_t    n_threads;
};


struct _ns_stringconfiguration
{
   void   *(*objectfromchars)( char *s);
   char   *(*charsfromobject)( void *obj);
};


struct _ns_exceptionconfiguration
{
   struct _ns_exceptionhandlertable   vectors;
};


struct _ns_autoreleasepool
{
   mulle_thread_tss_t   config_key;
   Class                pool_class;
};


//
// rename this to foundationconfiguration or so...
// this is part of the runtime structure..
//
struct _ns_rootconfiguration
{
   struct _ns_objectconfiguration     object;  // for easy access to allocator keep this up here

   struct _ns_exceptionconfiguration  exception;
   struct _ns_stringconfiguration     string;
   struct _ns_threadconfiguration     thread;
   struct _ns_autoreleasepool         pool;

   struct _mulle_objc_runtime         *runtime;
};

#pragma mark -
#pragma mark inital config setup

struct _ns_root_runtimeconfig
{
   struct mulle_allocator                     *allocator;
   mulle_objc_runtimefriend_versionassert_t   *versionassert;
   struct _mulle_objc_method                  *forward;
   void                                       (*uncaughtexception)( void *exception) __attribute__ ((noreturn));
};


struct _ns_root_foundationconfig
{
   size_t                             configurationsize;
   struct mulle_allocator             *objectallocator;
   struct _ns_exceptionhandlertable   *exceptiontable;  // must be set
};


struct _ns_root_setupconfig
{
   struct _ns_root_runtimeconfig     runtime;
   struct _ns_root_foundationconfig  foundation;
};


struct _ns_rootconfiguration   *__mulle_objc_root_setup( struct _mulle_objc_runtime *runtime,
                                                         struct _ns_root_setupconfig *config);

// this also sets up exception vectors
void   _ns_root_setup( struct _mulle_objc_runtime *runtime,
                       struct _ns_root_setupconfig *config);

__attribute__((const, returns_nonnull))  // always returns same value (in same thread)
static inline struct _ns_rootconfiguration   *_ns_get_rootconfiguration( void)
{
   struct _mulle_objc_runtime     *runtime;
   
   runtime = mulle_objc_inlined_get_runtime();
   return( _mulle_objc_runtime_get_foundationdata( runtime));
}


//
// check how much faster this is in thread local configuration
// so far unused!
//
__attribute__((const, returns_nonnull))  // always returns same value (in same thread)
static inline struct _ns_rootconfiguration   *_ns_object_get_rootconfiguration( void *obj)
{
   struct _mulle_objc_runtime     *runtime;
   
   runtime = _mulle_objc_object_get_runtime( obj);
   return( _mulle_objc_runtime_get_foundationdata( runtime));
}



// these functions do not retain/release
void   _ns_rootconfiguration_add_root( struct _ns_rootconfiguration *config, void *obj);
void   _ns_rootconfiguration_remove_root( struct _ns_rootconfiguration *config, void *obj);
void   _ns_rootconfiguration_release_roots( struct _ns_rootconfiguration *config);

void   _ns_rootconfiguration_add_placeholder( struct _ns_rootconfiguration *config, void *obj);
void   _ns_rootconfiguration_release_placeholders( struct _ns_rootconfiguration *config);

void   _ns_rootconfiguration_add_singleton( struct _ns_rootconfiguration *config, void *obj);
void   _ns_rootconfiguration_release_singletons( struct _ns_rootconfiguration *config);

void   _ns_rootconfiguration_add_thread( struct _ns_rootconfiguration *config, void *obj);
void   _ns_rootconfiguration_remove_thread( struct _ns_rootconfiguration *config, void *obj);


void  _ns_rootconfiguration_locked_call( void (*f)( struct _ns_rootconfiguration*));
void  _ns_rootconfiguration_locked_call1( void (*f)( struct _ns_rootconfiguration*, void *),
                                          void *obj);


# pragma mark -
# pragma mark root object conveniences

static inline void  _ns_add_root( void *obj)
{
   _ns_rootconfiguration_locked_call1( _ns_rootconfiguration_add_root, obj);
}

static inline void  _ns_remove_root( void *obj)
{
   _ns_rootconfiguration_locked_call1( _ns_rootconfiguration_remove_root, obj);
}

static inline void  _ns_release_roots( void)
{
   _ns_rootconfiguration_locked_call( _ns_rootconfiguration_release_roots);
}


static inline void  _ns_add_placeholder( void *obj)
{
   _ns_rootconfiguration_locked_call1( _ns_rootconfiguration_add_placeholder, obj);
}

static inline void  _ns_release_placeholders( void)
{
   _ns_rootconfiguration_locked_call( _ns_rootconfiguration_release_placeholders);
}


static inline void  _ns_add_singleton( void *obj)
{
   _ns_rootconfiguration_locked_call1( _ns_rootconfiguration_add_singleton, obj);
}

static inline void  _ns_release_singletons( void)
{
   _ns_rootconfiguration_locked_call( _ns_rootconfiguration_release_singletons);
}


static inline void  _ns_add_thread( void *obj)
{
   _ns_rootconfiguration_locked_call1( _ns_rootconfiguration_add_thread, obj);
}

static inline void  _ns_remove_thread( void *obj)
{
   _ns_rootconfiguration_locked_call1( _ns_rootconfiguration_remove_thread, obj);
}


# pragma mark -
# pragma mark string conveniences

static inline void   *_ns_string( char *s)
{
   struct _ns_rootconfiguration   *config;
 
   if( ! s)
      return( NULL);
   
   config = _ns_get_rootconfiguration();
   return( config->string.objectfromchars( s));
}


static inline char   *_ns_characters( void *obj)
{
   struct _ns_rootconfiguration   *config;
 
   if( ! obj)
      return( "*nil*");
   
   config = _ns_get_rootconfiguration();
   return( config->string.charsfromobject( obj));
}

#endif


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
#define MULLE_OBJC_VERSION_MINOR  2
#define MULLE_OBJC_VERSION_PATCH  0

#define MULLE_OBJC_VERSION               \
     ((MULLE_OBJC_VERSION_MAJOR << 20) | \
      (MULLE_OBJC_VERSION_MINOR << 8)  | \
       MULLE_OBJC_VERSION_PATCH)

#include "ns_objc_include.h"
#include "ns_type.h"
#include "_ns_exception.h"


struct _ns_objectconfiguration
{
   struct mulle_allocator   allocator;  // for easy access to allocator keep this up here
   struct mulle_set         *roots;
};


struct _ns_threadconfiguration
{
   volatile BOOL             is_multi_threaded;
   mulle_atomic_pointer_t    n_threads;
};


struct _ns_stringconfiguration
{
   struct _mulle_objc_class   *static_string_class;
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


struct _ns_rootconfiguration
{
   struct _ns_objectconfiguration     object;  // for easy access to allocator keep this up here

   struct _ns_exceptionconfiguration  exception;
   struct _ns_stringconfiguration     string;
   struct _ns_threadconfiguration     thread;
   struct _ns_autoreleasepool         pool;

   struct _mulle_objc_runtime         *runtime;
};


struct _ns_root_setupconfig
{
   struct mulle_allocator                     *allocator_p;
   mulle_objc_runtimefriend_versionassert_t   *versionassert;
   struct _mulle_objc_method                  *forward;
   void                                       (*uncaughtexception)( void *exception) __attribute__ ((noreturn));
};


struct _ns_rootconfiguration   *__ns_root_setup( struct _mulle_objc_runtime *runtime,
                                                 struct _ns_root_setupconfig *config);

void   _ns_root_setup( struct _mulle_objc_runtime *runtime,
                       struct _ns_root_setupconfig *config);

// vector to call
extern void   (*ns_root_setup)( struct _mulle_objc_runtime *runtime,
                                struct _ns_root_setupconfig *config);


__attribute__((const, returns_nonnull))  // always returns same value (in same thread)
static inline struct _ns_rootconfiguration   *_ns_rootconfiguration( void)
{
   struct _ns_rootconfiguration   *config;
   struct _mulle_objc_runtime     *runtime;
   
   runtime = mulle_objc_inlined_get_runtime();
   _mulle_objc_runtime_get_foundationspace( runtime, (void **) &config, NULL);
   return( config);
}


// these two functions do not retain/release
void   _ns_rootconfiguration_add_root( struct _ns_rootconfiguration *config, void *obj);
void   _ns_rootconfiguration_remove_root( struct _ns_rootconfiguration *config, void *obj);

void   _ns_rootconfiguration_release_roots( struct _ns_rootconfiguration *config);


# pragma mark -
# pragma mark root object conveniences

void  _ns_add_root( void *obj);
void  _ns_remove_root( void *obj);
void  _ns_release_roots( struct _mulle_objc_class *cls);

#endif


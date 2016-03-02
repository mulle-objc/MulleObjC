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

#include "ns_objc_include.h"
#include "ns_type.h"
#include "_ns_exception.h"


struct _ns_rootconfiguration
{
   struct _mulle_objc_runtime         *runtime;
   
   struct mulle_allocator             allocator;
   struct _ns_exceptionhandlertable   exceptions;
   struct _mulle_objc_class           *static_string_class;
   struct mulle_set                   *roots;
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


static inline struct _ns_rootconfiguration   *_ns_rootconfiguration( void)
{
   struct _ns_rootconfiguration    *config;
   struct _mulle_objc_runtime      *runtime;
   
   runtime = mulle_objc_inlined_get_runtime();
   _mulle_objc_runtime_get_foundationspace( runtime, (void **) &config, NULL);
   return( config);
}

void   _ns_rootconfiguration_add_root( struct _ns_rootconfiguration *config, void *obj);
void   _ns_rootconfiguration_release_roots( struct _ns_rootconfiguration *config);

#endif


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

#include "ns_allocation.h"
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
   mulle_objc_runtimefriend_versionassert_t   *versionassert;
   struct _mulle_objc_method                  *forward;
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
   
   runtime = mulle_objc_get_runtime();
   _mulle_objc_runtime_get_foundationspace( runtime, (void **) &config, NULL);
   return( config);
}

#endif


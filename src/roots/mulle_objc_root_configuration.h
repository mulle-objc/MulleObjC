/*
 *  MulleObjCCore.h
 *  MulleFoundation
 *
 *  Created by Nat! on 19.08.11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */
#ifndef mulle_objc_root_configuration_h__
#define mulle_objc_root_configuration_h__


#include "mulle_objc_root_parent_include.h"

#include "ns_type.h"

#include "ns_allocation.h"
#include "_ns_exception.h"


struct _mulle_objc_root_configuration
{
   struct _mulle_objc_runtime                   *runtime;
   
   struct _mulle_objc_exception_handler_table   exceptions;
};


struct _mulle_objc_root_configuration   *__mulle_objc_root_setup( void);
struct _mulle_objc_runtime              *_mulle_objc_root_setup( void);

// vector to call
extern struct _mulle_objc_runtime  *(*mulle_objc_root_setup)( void);


static inline struct _mulle_objc_root_configuration   *_mulle_objc_root_configuration( void)
{
   struct _mulle_objc_root_configuration      *config;
   struct _mulle_objc_runtime              *runtime;
   
   runtime = _mulle_objc_get_runtime();
   _mulle_objc_runtime_get_foundation_space( runtime, (void **) &config, NULL);
   return( config);
}

#endif


//
//  ns_objc_runtime_setup.h
//  MulleObjC
//
//  Created by Nat! on 15.08.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#ifndef ns_objc_runtime_setup_h__
#define ns_objc_runtime_setup_h__

#include "ns_rootconfiguration.h"

//
// copy this struct, modify to taste and pass it to ns_create_objc_runtime
//
const struct _ns_root_setupconfig   *ns_objc_get_default_setupconfig( void);

//
// use this in standalone to actually setup
// setup will be modified by ns_objc_create_runtime
//
struct _mulle_objc_runtime   *ns_objc_create_runtime( struct _ns_root_setupconfig *setup);

#endif /* ns_objc_runtime_setup_h */

//
//  ns_test_allocation.h
//  MulleObjC
//
//  Created by Nat! on 25.02.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#ifndef ns_test_allocation_h__
#define ns_test_allocation_h__

#include "ns_allocation.h"

extern struct mulle_allocator    mulle_test_allocator_objc;


static inline void  mulle_test_allocator_objc_initialize()
{
   extern void   mulle_test_allocator_initialize();
   
   mulle_test_allocator_initialize();
}


static inline void  mulle_test_allocator_objc_reset()
{
   extern void   mulle_test_allocator_reset();
   
   mulle_test_allocator_reset();
}


#endif

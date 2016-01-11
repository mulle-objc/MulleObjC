/*
 *  NSAutoreleasePool+Private.h
 *  MulleFoundation
 *
 *  Created by Nat! on 23.08.11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

@class NSObject;


#define NS_OBJECT_C_ARRAY_BYTES   (4096 * 2 - 4 * sizeof( void *))   // two pages, embeddable in NSAutoreleasePool
#define N_NS_OBJECT_C_ARRAY       ((NS_OBJECT_C_ARRAY_BYTES - sizeof( unsigned int) - sizeof( struct _ns_autoreleasepointerarray *)) / sizeof( NSObject *))



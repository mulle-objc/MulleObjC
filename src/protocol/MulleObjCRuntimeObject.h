//
//  MulleObjCRuntimeObject.h
//  MulleObjC
//
//  Created by Nat! on 12.05.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
//
#import "import.h"

#import "NSZone.h"
#import "mulle-objc-type.h"
#import "MulleObjCIntegralType.h"


#ifdef TRACE_INCLUDE_MULLE_FOUNDATION
# warning MulleObjCRuntimeObject protocol included
#endif


@protocol MulleObjCRuntimeObject

//
// these methods must not be overriden
// the runtime will replace any [foo alloc] call
// with a C function (with -O2 or better)
//
- (NSZone *) zone   __attribute__((deprecated("zones have no meaning and will eventually disappear")));  // always NULL

- (instancetype) retain;
- (void) release;
- (instancetype) autorelease;
- (NSUInteger) retainCount;

// some mulle additions for AAO mode and complete ObjectGraph support

// AAO suport
+ (instancetype) instantiate;
- (instancetype) immutableInstance;

// ObjectGraph support
- (void) _becomeRootObject;
- (void) _pushToParentAutoreleasePool;

@end

//
//  MulleObjC.h
//  MulleObjC
//
//  Created by Nat! on 21/10/15.
//  Copyright © 2015 Mulle kybernetiK. All rights reserved.
//

// because standalone versions must define FASTIDs

#ifdef MULLE_OBJC_RUNTIME_VERSION
# error "do not include mulle_objc_runtime.h before MulleObjC.h"
#endif


#import "ns_objc.h"

// objects
#import "NSAutoreleasePool.h"
#import "NSCoder.h"
#import "NSInvocation.h"
#import "NSMethodSignature.h"
#import "NSObject.h"
#import "NSLock.h"
#import "NSRecursiveLock.h"
#import "NSProxy.h"
#import "NSThread.h"


// protocols
#import "MulleObjCClassCluster.h"
#import "MulleObjCException.h"
#import "MulleObjCSingleton.h"
#import "NSCopying.h"
#import "NSCoding.h"
#import "NSFastEnumeration.h"
#import "NSLocking.h"
#import "NSObjectProtocol.h"

// categories
#import "NSObject+NSCoding.h"

// functions
#import "MulleObjCAllocation.h"
#import "MulleObjCFunctions.h"


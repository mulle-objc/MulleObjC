//
//  MulleObjCRoot.h
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

#import "NSAllocation.h"

#import "NSObjectProtocol.h"
#import "NSCopying.h"

#import "NSAutoreleasePool.h"
#import "NSObject.h"
#import "NSProxy.h"
#import "NSThread.h"

#import "NSAutoreleasePool.h"

#import "NSMethodSignature.h"
#import "NSInvocation.h"

//
//  MulleObjCClassCluster.h
//  MulleObjCFoundation
//
//  Created by Nat! on 18.03.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#include "ns_type.h"


//
// this protocol adds an +alloc mechanism to the
// +instantiate mechanism. It also exposes a method, you
// may need in your class to change the instantiate placeholder
//
// use it like this:
//  <your class> : MulleObjCClassCluster  , will alloc placeholder
//  <your subclass> : <your class>,         will NSAllocateObject
//
// When you call +alloc you get a retained placeholder back. In your
// init method, you should release it.
//
@protocol MulleObjCClassCluster 

@optional
+ (mulle_objc_classid_t) __instantiatePlaceholderClassid;

@end



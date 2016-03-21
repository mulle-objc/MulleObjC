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
// +instantiate mechanism. It also exposes two methods, you
// use in your class to change the placeholder
//
// use it like this:
//  <your class> : MulleObjCClassCluster  , will alloc placeholder
//  <your subclass> : <your class>,         will NSAllocateObject
//
@protocol MulleObjCClassCluster

+ (mulle_objc_classid_t) __classClusterPlaceholderClassid;
@optional
+ (mulle_objc_classid_t) __instantiatePlaceholderClassid;

@end



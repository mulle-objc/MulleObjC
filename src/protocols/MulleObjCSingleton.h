//
//  NSObject+MulleObjCSingleton.h
//  MulleObjC
//
//  Created by Nat! on 21.03.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSObjectProtocol.h"

//
// singletons are expected to be created through "sharedInstance"
// and not through alloc, if you use alloc you get another instance
//
@protocol MulleObjCSingleton < NSObject>

@optional  // MulleObjCSingleton implements this for you
+ (instancetype) sharedInstance;

@end

// for subclasses, who don't use sharedInstance
id  MulleObjCSingletonCreate( Class self);


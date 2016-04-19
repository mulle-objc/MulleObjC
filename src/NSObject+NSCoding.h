//
//  NSObject+NSCoding.h
//  MulleObjC
//
//  Created by Nat! on 17.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSObject.h"

#import "NSCoding.h"

@class NSCoder;

@interface NSObject (NSCoding)

+ (NSInteger) version;
+ (void) setVersion:(NSInteger) aVersion;
+ (Class) classForCoder;
- (id) replacementObjectForCoder:(NSCoder *) coder;
- (id) awakeAfterUsingCoder:(NSCoder *) decoder;

@end

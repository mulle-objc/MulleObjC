//
//  MulleObjCException.m
//  MulleObjC
//
//  Created by Nat! on 20.03.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "MulleObjCException.h"


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-root-class"


@interface MulleObjCException < MulleObjCException>

// don't use __attribute(( noreturn)), the compiler will produce
// wrong code for
// exception = nil;
// ...
// [exception raise];
//
- (void) raise;

@end


@implementation MulleObjCException

- (void) raise
{
   _mulle_objc_runtime_throw( mulle_objc_get_runtime(), self);
}

@end


#pragma clang diagnostic pop

//
//  MulleObjCException.m
//  MulleObjC
//
//  Created by Nat! on 20.03.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "MulleObjCException.h"


@interface MulleObjCException < MulleObjCException>

- (void) raise  __attribute__((noreturn));

@end


@implementation MulleObjCException

- (void) raise
{
   _mulle_objc_runtime_throw( mulle_objc_get_runtime(), self);
}

@end

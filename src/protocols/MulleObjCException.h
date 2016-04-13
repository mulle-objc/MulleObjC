//
//  MulleObjCException.h
//  MulleObjC
//
//  Created by Nat! on 20.03.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSObject.h"


// base your exception subclass on this

@protocol MulleObjCException

@optional  // MulleObjCException implements this for you
- (void) raise  __attribute__((noreturn));

@end

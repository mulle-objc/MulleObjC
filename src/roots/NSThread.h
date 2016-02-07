//
//  NSThread.h
//  MulleObjC
//
//  Created by Nat! on 15/10/15.
//  Copyright © 2015 Mulle kybernetiK. All rights reserved.
//

#import "NSObject.h"


@interface NSThread : NSObject
{
   id   target;
   SEL  sel;
   id   argument;
}

+ (NSThread *) currentThread;

+ (void) detachNewThreadSelector:(SEL) sel
                        toTarget:(id) target
                      withObject:(id) argument;

+ (void) exit;

- (NSThread *) makeRuntimeThread;
+ (NSThread *) makeRuntimeThread;

@end

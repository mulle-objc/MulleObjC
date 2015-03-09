//
//  NSThread.h
//  mulle-objc-foundation
//
//  Created by Nat! on 15/10/15.
//  Copyright © 2015 Mulle kybernetiK. All rights reserved.
//

#import "NSObjectProtocol.h"

//
// why isn't it a subclass of NSObject ?
// basically for sporting reasons, start with something useful that is
// protocol based.
//
@interface NSThread <NSObject>
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

// use:
// [[NSThread newRoot] makeRuntimeThread];
- (NSThread *) makeRuntimeThread;

@end

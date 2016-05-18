//
//  NSThread.h
//  MulleObjC
//
//  Created by Nat! on 15/10/15.
//  Copyright © 2015 Mulle kybernetiK. All rights reserved.
//
#import "NSObject.h"


@class NSAutoreleasePool;
@class NSThread;
struct MulleObjCAutoreleasePoolConfiguration;


@interface NSThread : NSObject
{
   id               _target;
   SEL              _selector;
   id               _argument;
   mulle_thread_t   _thread;
   BOOL             _isDetached;
}

@property( retain) id     userInfo;  // used for thread dictionary

- (id) initWithTarget:(id) target
             selector:(SEL) sel
               object:(id) argument;

+ (NSThread *) currentThread;

+ (void) detachNewThreadSelector:(SEL) sel
                        toTarget:(id) target
                      withObject:(id) argument;

+ (void) exit;

- (void) start;
- (void) main;


// mulle additons

+ (BOOL) isMultiThreaded;   // __attribute__((availability(mulleobjc,introduced=0.2)));

// don't call join on a detached thread
- (void) join;              // __attribute__((availability(mulleobjc,introduced=0.2)));
- (void) detach;            // __attribute__((availability(mulleobjc,introduced=0.2)));
- (void) startUndetached;   // __attribute__((availability(mulleobjc,introduced=0.2)));

//
// a pthread or C11 thread that wants to call ObjC functions must minimally call
// _mulle_become_objc_runtime_thread beforehand and must call
// _mulle_resignas_objc_runtime_thread before exiting
//
void  _mulle_become_objc_runtime_thread( void);
void  _mulle_resignas_objc_runtime_thread( void);       // NSThread object should be gone already


#pragma mark -
#pragma mark Internal

// don't call these functions yourself
NSThread  *_NSThreadNewRuntimeThread( void);
void       _NSThreadResignAsRuntimeThreadAndDeallocate( NSThread *self);

NSThread  *_NSThreadNewMainThread( void);
void  _NSThreadResignAsMainThread( void);

@end

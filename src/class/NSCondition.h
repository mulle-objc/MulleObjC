/*
 *  MulleFoundation - the mulle-objc class library
 *
 *  NSCondition.h is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "import.h"

#ifndef _WIN32
#include <pthread.h>
#endif

#import "NSObject.h"

#import "NSLocking.h"
#import "MulleObjCProtocol.h"

//
// This is the basis for NSConditionLock. On its own its just a thin wrapper
// around pthreads. Its super lowlevel and you really must have read the
// pthread dox, otherwise you'll be deadlocking left and right.
// TODO: move platform specifica to a C library
// Hint: Use NSConditionLock or pthreads directly if possible.
//
@interface NSCondition : NSObject < NSLocking, MulleObjCThreadSafe>
{
#ifndef _WIN32
   pthread_mutex_t   _lock;
   pthread_cond_t    _condition;
#endif
}

// it's an NSString, but we don't have it here
@property( copy) id   name;

// this is only useful for debugging printing
@property( assign, readonly) BOOL  mulleIsLocked;


- (void) signal;
- (void) broadcast;

// these two can spuriously return, even if the condition was signaled
// enter locked
- (void) wait;

- (BOOL) tryLock;

@end



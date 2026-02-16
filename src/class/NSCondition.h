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

#include <mulle-thread/mulle-thread.h>

#import "NSObject.h"

#import "NSLocking.h"
#import "MulleObjCProtocol.h"

//
// This is the basis for NSConditionLock. On its own its just a thin wrapper
// around mulle-thread condition variables. Its super lowlevel and you really
// must have read the condition variable docs, otherwise you'll be deadlocking
// left and right.
// Hint: Use NSConditionLock or mulle-thread directly if possible.
//
@interface NSCondition : NSObject < NSLocking, MulleObjCThreadSafe>
{
   mulle_thread_mutex_t   _lock;
   mulle_thread_cond_t    _condition;
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


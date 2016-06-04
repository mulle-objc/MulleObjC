/*
 *  MulleFoundation - the mulle-objc class library
 *
 *  NSLock.h is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSObject.h"

#import "NSLocking.h"

// it's in MulleObjC because
//  a) NSThread and NSLock kinda go hand in hand
//  b) no POSIX dependency
//  c) no real C stdlib dependency (just mulle_thread)
//
@interface NSLock : NSObject < NSLocking>
{
   mulle_thread_mutex_t    _lock;
}

- (void) lock;
- (void) unlock;
- (BOOL) tryLock;

@end


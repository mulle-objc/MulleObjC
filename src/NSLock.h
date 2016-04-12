/*
 *  MulleFoundation - A tiny Foundation replacement
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


@interface NSLock : NSObject < NSLocking>
{
   mulle_thread_mutex_t    _lock;
}

- (void) lock;
- (void) unlock;
- (BOOL) tryLock;

@end


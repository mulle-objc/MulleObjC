/*
 *  MulleFoundation - the mulle-objc class library
 *
 *  NSRecursiveLock.h is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSLock.h"


@interface NSRecursiveLock : NSLock
{
   mulle_thread_t   _thread;
}

@end


/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSRecursiveLock.m is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSRecursiveLock.h"

// other files in this library

// other libraries of MulleObjCFoundation

// std-c and dependencies



@implementation NSRecursiveLock

- (void) lock
{
   void   *this_thread;
   
   this_thread = mulle_thread_self();
   
   if( [super tryLock])
   {
      _thread = this_thread;
      return;
   }

   if( this_thread == _thread)
      return;
   
   [super lock];

   _thread = this_thread;
}


- (BOOL) tryLock
{
   void   *this_thread;
   
   this_thread = mulle_thread_self();
   
   if( [super tryLock])
   {
      _thread = this_thread;
      return( YES);
   }

   if( this_thread == _thread)
      return( YES);
      
   return( NO);
}

@end


/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSLock.m is a part of MulleFoundation
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

// other files in this library

// other libraries of MulleObjCFoundation

// std-c and dependencies


@implementation NSLock

- (id) init
{
   mulle_thread_mutex_init( &self->_lock);
   return( self);
}


- (void) dealloc
{
   mulle_thread_mutex_done( &self->_lock);
   [super dealloc];
}


- (void) lock
{
   mulle_thread_mutex_lock( &self->_lock);
}


- (void) unlock
{
   mulle_thread_mutex_unlock( &self->_lock);
}


- (BOOL) tryLock
{
   return( ! mulle_thread_mutex_trylock( &self->_lock));
}

@end




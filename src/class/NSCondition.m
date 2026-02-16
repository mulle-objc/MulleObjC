/*
 *  MulleFoundation - the mulle-objc class library
 *
 *  NSCondition.m is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "import-private.h"

#import "NSCondition.h"

// other files in this library

// std-c and dependencies
#include <stdio.h>


// TODO: look at rval and abort ?
#define USE_FOR_DUMB_COMPILER( x)  ((void)(x))

@implementation NSCondition

- (instancetype) init
{
   mulle_thread_mutex_init( &self->_lock);
   mulle_thread_cond_init( &self->_condition);
   return( self);
}


#if MULLE_THREAD_MUTEX_NEEDS_DONE || MULLE_THREAD_COND_NEEDS_DONE
- (void) dealloc
{
   mulle_thread_cond_done( &self->_condition);
   mulle_thread_mutex_done( &self->_lock);
   [super dealloc];
}
#endif


static void  rval_perror_abort( char *s, int rval)
{
   errno = rval;
   perror( s);
   abort();
}


- (void) signal
{
   int   rval;

   rval = mulle_thread_cond_signal( &self->_condition);
   assert( ! rval);
   USE_FOR_DUMB_COMPILER( rval);
}


- (void) broadcast
{
   int   rval;

   rval = mulle_thread_cond_broadcast( &self->_condition);
   USE_FOR_DUMB_COMPILER( rval);
}


- (void) wait
{
   int   rval;
   // It is important to note that when mulle_thread_cond_wait()
   // returns without error, the associated predicate may still be false
   // (associated predicate -> -[NSConditionLock condition])
   //
   _mulleIsLocked = NO;
   rval = mulle_thread_cond_wait( &self->_condition, &self->_lock);
   if( rval)
      rval_perror_abort( "mulle_thread_cond_wait", rval);
   _mulleIsLocked = YES;
}


#pragma mark - NSLocking

- (void) lock
{
   int   rval;

   rval = mulle_thread_mutex_lock( &self->_lock);
   assert( ! rval);
   USE_FOR_DUMB_COMPILER( rval);

   _mulleIsLocked = YES;
}


- (void) unlock
{
   int   rval;

   _mulleIsLocked = NO;

   rval = mulle_thread_mutex_unlock( &self->_lock);
   assert( ! rval);
   USE_FOR_DUMB_COMPILER( rval);
}


- (BOOL) tryLock
{
   int    rval;

   rval = mulle_thread_mutex_trylock( &self->_lock);
   if( rval)
   {
      if( rval == EBUSY)
         return( NO);

      rval_perror_abort( "mulle_thread_mutex_trylock", rval);
   }
   _mulleIsLocked = YES;
   return( YES);
}

@end


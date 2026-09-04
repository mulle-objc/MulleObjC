//
//  NSCondition.m
//  MulleObjC
//
//  Copyright (c) 2024 Nat! - Mulle kybernetiK.
//  All rights reserved.
//
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//
//  Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  Neither the name of Mulle kybernetiK nor the names of its contributors
//  may be used to endorse or promote products derived from this software
//  without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.
//
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


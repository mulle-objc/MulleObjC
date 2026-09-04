//
//  NSConditionLock.m
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
#define _GNU_SOURCE

#import "NSConditionLock.h"

// other files in this library
#import "NSThread.h"

// std-c and dependencies
#include <math.h>  // for infinity


#ifdef MULLE_TEST
//# define LOCK_DEBUG
#endif


@implementation NSConditionLock

- (instancetype) initWithCondition:(NSInteger) value
{
   [super init];

   _mulle_atomic_pointer_nonatomic_write( &_currentCondition, (void *) value);

#ifdef LOCK_DEBUG
   mulle_fprintf( stderr, "%@: %@ init -> %td\n",
                           [NSThread currentThread], self, [self condition]);
#endif
   return( self);
}


- (NSInteger) condition
{
   return( (NSUInteger) _mulle_atomic_pointer_read( &_currentCondition));
}


- (void) lockWhenCondition:(NSInteger) value
{
#ifdef LOCK_DEBUG
   mulle_fprintf( stderr, "%@: %@ lockWhenCondition:%td (%td)\n",
                           [NSThread currentThread], self, value, [self condition]);
#endif

   [self lock];

   while( value != (NSUInteger) _mulle_atomic_pointer_nonatomic_read( &_currentCondition))
      [self wait];

#ifdef LOCK_DEBUG
   mulle_fprintf( stderr, "%@: %@ lockWhenCondition:%td == success\n",
                           [NSThread currentThread], self, value);
#endif
}


- (void) mulleLockWhenNotCondition:(NSInteger) value
{
#ifdef LOCK_DEBUG
   mulle_fprintf( stderr, "%@: %@ mulleLockWhenNotCondition:%td (%td)\n",
                           [NSThread currentThread], self, value, [self condition]);
#endif

   [self lock];

   while( value == (NSUInteger) _mulle_atomic_pointer_nonatomic_read( &_currentCondition))
      [self wait];

#ifdef LOCK_DEBUG
   mulle_fprintf( stderr, "%@: %@ mulleLockWhenNotCondition:%td == success\n",
                           [NSThread currentThread], self, value);
#endif
}


- (BOOL) tryLockWhenCondition:(NSInteger) value
{
#ifdef LOCK_DEBUG
   mulle_fprintf( stderr, "%@: %@ tryLockWhenCondition:%td (%td)\n",
                           [NSThread currentThread], self, value, [self condition]);
#endif
   if( ! [self tryLock])
   {
#ifdef LOCK_DEBUG
      mulle_fprintf( stderr, "%@: %@ tryLockWhenCondition:%td == failed, no lock acquired\n",
                              [NSThread currentThread], self, value);
#endif
      return( NO);
   }

   if( value == (NSInteger) _mulle_atomic_pointer_nonatomic_read( &_currentCondition))
   {
#ifdef LOCK_DEBUG
      mulle_fprintf( stderr, "%@: %@ tryLockWhenCondition:%td == success, condition matched (locked)\n",
                              [NSThread currentThread], self, value);
#endif
      return( YES);
   }

   [self unlock];
#ifdef LOCK_DEBUG
   mulle_fprintf( stderr, "%@: %@ tryLockWhenCondition:%td == failed, condition did not matched (unlocked)\n",
                           [NSThread currentThread], self, value);
#endif
   return( NO);
}


- (BOOL) mulleTryLockWhenNotCondition:(NSInteger) value
{
#ifdef LOCK_DEBUG
   mulle_fprintf( stderr, "%@: %@ mulleTryLockWhenNotCondition: %td (%td)\n",
                           [NSThread currentThread], self, value, [self condition]);
#endif
   if( ! [self tryLock])
   {
#ifdef LOCK_DEBUG
      mulle_fprintf( stderr, "%@: %@ mulleTryLockWhenNotCondition:%td == failed, no lock acquired\n",
                              [NSThread currentThread], self, value);
#endif
      return( NO);
   }

   if( value != (NSInteger) _mulle_atomic_pointer_nonatomic_read( &_currentCondition))
   {
#ifdef LOCK_DEBUG
      mulle_fprintf( stderr, "%@: %@ mulleTryLockWhenNotCondition:%td == success, condition didn't match (locked)\n",
                              [NSThread currentThread], self, value);
#endif
      return( YES);
   }

   [self unlock];
#ifdef LOCK_DEBUG
   mulle_fprintf( stderr, "%@: %@ mulleTryLockWhenNotCondition:%td == failed, condition did match (unlocked)\n",
                           [NSThread currentThread], self, value);
#endif
   return( NO);
}



- (void) unlockWithCondition:(NSInteger) value
{
#ifdef LOCK_DEBUG
   mulle_fprintf( stderr, "%@: %@ unlockWithCondition:%td\n",
                           [NSThread currentThread], self, value);
#endif

   _mulle_atomic_pointer_nonatomic_write( &_currentCondition, (void *) value);

   //
   // so we broadcast here, because if we only signal we could signal a thread
   // that doesn't really care and then nothing goes anymore ?
   //
   [self broadcast];
   [self unlock];
}


- (void) mulleUnlockWithCondition:(NSInteger) value
                        broadcast:(BOOL) broadcast
{
#ifdef LOCK_DEBUG
   mulle_fprintf( stderr, "%@: %@ mulleUnlockWithCondition:broadacst: %td\n",
                           [NSThread currentThread], self, value);
#endif

   _mulle_atomic_pointer_nonatomic_write( &_currentCondition, (void *) value);

   //
   // so we broadcast here, because if we only signal we could signal a thread
   // that doesn't really care and then nothing goes anymore ?
   //
   if( broadcast)
      [self broadcast];
   else
      [self signal];
   [self unlock];
}

@end



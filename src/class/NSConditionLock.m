/*
 *  MulleFoundation - the mulle-objc class library
 *
 *  NSConditionLock.m is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
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



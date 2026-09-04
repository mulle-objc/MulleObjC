//
//  NSConditionLock.h
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
#import "NSCondition.h"

#import "NSLocking.h"


//
// You use a NSConditionLock to synchronize threads. The actual workload
// inside the lock should be **extremely** minimal as other threads may
// deadlock otherwise in lockWhenCondition:beforeDate:. To protect
// datastructures use a regular lock in conjunction with NSConditionLock.
//
// NSCondition is the OS interface and this makes things easier. It is a
// bit confusing that the integer value, that is basically the actual
// value being locked is also called condition. Also note that this is not
// really a NSLock but a synchronization tool, Depending on how things are
// setup two threads that wait for the same condition may run!
//
@interface NSConditionLock : NSCondition
{
   mulle_atomic_pointer_t   _currentCondition;
}

- (instancetype) initWithCondition:(NSInteger) condition;

- (NSInteger) condition;

- (void) lockWhenCondition:(NSInteger) condition;

// this contrary to the documentation will NOT call
// -lockWhenCondition:beforeDate:. Instead its like lockWhenCondition
// but using tryLock to immediately bail if unsuccessful
- (BOOL) tryLockWhenCondition:(NSInteger) condition;
- (void) unlockWithCondition:(NSInteger) condition;

// choose between signal or broadcast to wake up threads
// see pthread_cond_signal dox
- (void) mulleUnlockWithCondition:(NSInteger) value
                        broadcast:(BOOL) broadcast;

// only lock if condition does not match
- (void) mulleLockWhenNotCondition:(NSInteger) value;
- (BOOL) mulleTryLockWhenNotCondition:(NSInteger) value;

@end


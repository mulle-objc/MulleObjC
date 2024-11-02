//
//  NSLocking.h
//  MulleObjC
//
//  Copyright (c) 2011 Nat! - Mulle kybernetiK.
//  Copyright (c) 2011 Codeon GmbH.
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
#import "import.h"


@protocol NSLocking

- (void) lock     MULLE_OBJC_THREADSAFE_METHOD;
- (void) unlock   MULLE_OBJC_THREADSAFE_METHOD;

// no default implementations for these, these just declare that if those
// methods exist, their signatures and that they are threadsafe
@optional
- (BOOL) tryLock                                                     MULLE_OBJC_THREADSAFE_METHOD;
- (BOOL) lockBeforeTimeInterval:(mulle_timeinterval_t) timeInterval  MULLE_OBJC_THREADSAFE_METHOD;

@end


//
// Use:
//
// NSLock   *lock;
//
// lock = [NSLock object];
// MulleObjCLockingDo( lock)
// {
//    // do stuff while locked
// }
// // lock is now unlocked
// If lock is nil, this will run one time, regardless.
#define MulleObjCLockDo( name)                                         \
   for( int name ## __i = ([(name) lock], 0);                          \
        ! name ## __i;                                                 \
        name ## __i =  ([(name) unlock], 1                             \
        )                                                              \
      )                                                                \
      for( int  name ## __j = 0;    /* break protection */             \
           name ## __j < 1;                                            \
           name ## __j++)

#define MulleObjCLockingDo( name)   MulleObjCLockDo( name)

// kinda prefer these now
#define NSLockDo( name)     MulleObjCLockDo( name)
#define NSLockingDo( name)  MulleObjCLockDo( name)

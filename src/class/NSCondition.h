//
//  NSCondition.h
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
#import "import.h"

#include <mulle-thread/mulle-thread.h>

#import "NSObject.h"

#import "NSLocking.h"
#import "MulleObjCProtocol.h"

//
// This is the basis for NSConditionLock. On its own its just a thin wrapper
// around mulle-thread condition variables. Its super lowlevel and you really
// must have read the condition variable docs, otherwise you'll be deadlocking
// left and right.
// Hint: Use NSConditionLock or mulle-thread directly if possible.
//
@interface NSCondition : NSObject < NSLocking, MulleObjCThreadSafe>
{
   mulle_thread_mutex_t   _lock;
   mulle_thread_cond_t    _condition;
}

// it's an NSString, but we don't have it here
@property( copy) id   name;

// this is only useful for debugging printing
@property( assign, readonly) BOOL  mulleIsLocked;


- (void) signal;
- (void) broadcast;

// these two can spuriously return, even if the condition was signaled
// enter locked
- (void) wait;

- (BOOL) tryLock;

@end


//
//  MulleProxy.m
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
#ifdef __has_include
# if __has_include( "NSProxy.h")
#  import "NSProxy.h"
# endif
#endif

#import "import.h"

@class NSRecursiveLock;
@class MulleObject;


// another experiment
@interface MulleProxy : NSProxy
{
   NSRecursiveLock   *__lock;        // use __ to "hide" it (keep here to stay compatible with MulleObject)

   id                __target;
   IMP               __gain_imp;
   IMP               __relinquish_imp;
   NSUInteger        __taoStrategy;
}

//
// the idea here is to create a locking front for a target
//
+ (instancetype) proxyWithObject:(id) target;
- (instancetype) initWithObject:(id) target;

+ (instancetype) locklessProxyWithObject:(id) target;
- (instancetype) initNoLockWithObject:(id) target;


- (BOOL) tryLock                                            MULLE_OBJC_THREADSAFE_METHOD;


- (void) didShareRecursiveLock:(NSRecursiveLock *) lock     MULLE_OBJC_THREADSAFE_METHOD;
- (void) shareRecursiveLock:(NSRecursiveLock *) other       MULLE_OBJC_THREADSAFE_METHOD;

// this is a little fake
- (void) shareRecursiveLockWithObject:(MulleObject *) other MULLE_OBJC_THREADSAFE_METHOD;
- (void) shareRecursiveLockWithProxy:(MulleProxy *) other   MULLE_OBJC_THREADSAFE_METHOD;

@end

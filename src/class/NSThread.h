//
//  NSThread.h
//  MulleObjC
//
//  Copyright (c) 2015 Nat! - Mulle kybernetiK.
//  Copyright (c) 2015 Codeon GmbH.
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
#import "NSObject.h"


@class NSAutoreleasePool;
@class NSThread;
struct MulleObjCAutoreleasePoolConfiguration;


@interface NSThread : NSObject
{
   id               _target;
   SEL              _selector;
   id               _argument;
   mulle_thread_t   _thread;
   BOOL             _isDetached;
   id               _userInfo;
}

- (instancetype) initWithTarget:(id) target
                       selector:(SEL) sel
                         object:(id) argument;

+ (NSThread *) currentThread;

+ (void) detachNewThreadSelector:(SEL) sel
                        toTarget:(id) target
                      withObject:(id) argument;

+ (void) exit;

- (void) start;
- (void) main;


+ (BOOL) isMultiThreaded;   // __attribute__((availability(mulleobjc,introduced=0.2)));

// mulle additons for tests

// don't call join on a detached thread
- (void) join;              // __attribute__((availability(mulleobjc,introduced=0.2)));
- (void) detach;            // __attribute__((availability(mulleobjc,introduced=0.2)));
- (void) startUndetached;   // __attribute__((availability(mulleobjc,introduced=0.2)));

//
// a pthread or C11 thread that wants to call ObjC functions must minimally call
// _mulle_objc_thread_become_universethread beforehand and must call
// _mulle_objc_thread_resignas_universethread before exiting
//
void  _mulle_objc_thread_become_universethread( struct _mulle_objc_universe *universe);
void  _mulle_objc_thread_resignas_universethread( struct _mulle_objc_universe *universe);       // NSThread object should be gone already


#pragma mark -
#pragma mark Internal

// don't call these functions yourself
NSThread  *_NSThreadNewUniverseThreadObject( struct _mulle_objc_universe *universe);
NSThread  *_NSThreadNewMainThreadObject( struct _mulle_objc_universe *universe);
void       _NSThreadResignAsMainThreadObject( struct _mulle_objc_universe *universe);

// this will autorelease the threadDictionary, this must be called before
// the last autoreleasepool dies
void       _NSThreadFinalizeMainThreadObject( struct _mulle_objc_universe *universe);

@end

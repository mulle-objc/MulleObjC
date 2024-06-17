//
//  NSLock.m
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
#define _GNU_SOURCE

#import "NSLock.h"
#import "NSLock-Private.h"

// other files in this library

// std-c and dependencies


// TODO: look at rval and abort ?

@implementation NSLock

- (instancetype) init
{
   return( _MulleObjCLockInit( self));
}

// TODO: check if we this is really needed on a per platform basis
//       mulle_thread should know this...
//
#if MULLE_THREAD_MUTEX_NEEDS_DONE
- (void) dealloc
{
   _MulleObjCLockDone( self);
   [super dealloc];
}
#endif


- (void) lock
{
   return( _MulleObjCLockLock( self));
}


- (void) unlock
{
   return( _MulleObjCLockUnlock( self));
}


- (BOOL) tryLock
{
   return( _MulleObjCLockTryLock( self));
}


- (BOOL) lockBeforeTimeInterval:(mulle_timeinterval_t) timeInterval
{
   for(;;)
   {
      if( mulle_timeinterval_now() >= timeInterval)
         return( NO);

      if( [self tryLock])
         return( YES);

      // TODO: why not use nanosleep or select and move this
      //       to OS ? Because there is no "good" nanosleep value
      //       in my opinion. What is too small, what is too large ?
      mulle_thread_yield();
   }
}


@end

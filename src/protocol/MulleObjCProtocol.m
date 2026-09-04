//
//  MulleObjCProtocol.m
//  MulleObjC
//
//  Copyright (c) 2019 Nat! - Mulle kybernetiK.
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
#import "MulleObjCProtocol.h"

#import "NSObjectProtocol.h"
#import "NSCopying.h"
#import "MulleObjCException.h"


@implementation MulleObjCThreadSafe

// here it comes in handy, that initialize is called by subclasses
+ (void) initialize
{
   struct _mulle_objc_class  *cls;

   cls = _mulle_objc_infraclass_as_class( (struct _mulle_objc_infraclass *) self);
   _mulle_objc_class_set_state_bit( cls, MULLE_OBJC_CLASS_IS_NOT_THREAD_AFFINE);
}


- (BOOL) mulleIsThreadSafe   MULLE_OBJC_THREADSAFE_METHOD
{
   return( YES);
}


- (id) mulleThreadSafeCopy
{
   return( MulleObjCObjectRetain( self)); // is a little unclean
}


//
// this is needed so our object does not get removed from the AutoreleasePool
//
- (MulleObjCTAOStrategy) mulleTAOStrategy  MULLE_OBJC_THREADSAFE_METHOD
{
   return( MulleObjCTAOKnownThreadSafe);
}

@end



@implementation MulleObjCThreadUnsafe

+ (void) initialize
{
   struct _mulle_objc_class  *cls;

   cls = _mulle_objc_infraclass_as_class( (struct _mulle_objc_infraclass *) self);
   _mulle_objc_class_clear_state_bit( cls, MULLE_OBJC_CLASS_IS_NOT_THREAD_AFFINE);
}

- (BOOL) mulleIsThreadSafe   MULLE_OBJC_THREADSAFE_METHOD
{
   return( NO);
}


- (instancetype) mulleThreadSafeCopy
{
   return( nil);
}


// This may be superfluous, since coming from MulleObjCThreadSafe there
// is no change in the implementation (as the method wont get called). And if
// some subclass, wants to extend, why would we clobber ? Though, if someone
// mistakenly "fixed" this in his MulleObjCThreadSafe class, he might be
// surprised that putting on MulleObjCThreadSafe in his subclass doesn't fix
//problems....
//
// So ensure that the strategy is back to the default
//

- (MulleObjCTAOStrategy) mulleTAOStrategy  MULLE_OBJC_THREADSAFE_METHOD
{
   return( MulleObjCTAOCallerRemovesFromCurrentPool);
}

@end


@implementation MulleObjCImmutable

- (id) copy
{
   return( [self retain]);
}


@method_implementation -immutableCopy = -copy;

@end



@implementation MulleObjCPlaceboRetainCount

- (void) dealloc
{
}


// all do nothing
@method_implementation -finalize = -dealloc;
@method_implementation -release  = -dealloc;



- (instancetype) retain
{
   return( self);
}

// all return self
@method_implementation -autorelease = -retain;


- (NSUInteger) retainCount
{
   return( MULLE_OBJC_NEVER_RELEASE);
}

@end


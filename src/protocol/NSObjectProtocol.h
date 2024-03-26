//
//  NSObjectProtocol.h
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
#import "MulleObjCRuntimeObject.h"


#ifdef TRACE_INCLUDE_MULLE_FOUNDATION
# warning NSObject protocol included
#endif


// implement this on classes which use `observable` properties, it will
// get triggered on setters. You often want to make a snapshot of your
// object at this time to be able to undo the change.
//
// @property( observable) int   x;
//
// The compiler will generate a setter like this:
// - (void) setX:(int) x
// {
//    [self willChange];
//    _x = x;
// }
//

@protocol MullePropertyObserving

- (void) willChange;

@end



_PROTOCOLCLASS_INTERFACE( NSObject, MulleObjCRuntimeObject)

// used by faults, not necessarily threadsafe
- (instancetype) self;

- (Class) superclass                              MULLE_OBJC_THREADSAFE_METHOD;
- (Class) class                                   MULLE_OBJC_THREADSAFE_METHOD;
+ (Class) class                                   MULLE_OBJC_THREADSAFE_METHOD;

- (BOOL) isProxy                                  MULLE_OBJC_THREADSAFE_METHOD;
- (BOOL) isKindOfClass:(Class) cls                MULLE_OBJC_THREADSAFE_METHOD;
- (BOOL) isMemberOfClass:(Class) cls              MULLE_OBJC_THREADSAFE_METHOD;

// AAO suport
+ (instancetype) instantiate;
// these are not in the traditional NSObject protocol

+ (instancetype) new;
+ (instancetype) alloc;
- (instancetype) init;
- (void) dealloc;
- (void) finalize;

- (instancetype) autorelease                      MULLE_OBJC_THREADSAFE_METHOD;

- (BOOL) conformsToProtocol:(PROTOCOL) protocol   MULLE_OBJC_THREADSAFE_METHOD;
- (BOOL) respondsToSelector:(SEL) sel             MULLE_OBJC_THREADSAFE_METHOD;
- (void) _pushToParentAutoreleasePool;


- (NSZone *) zone   __attribute__((deprecated("zones have no meaning and will eventually disappear")));  // always NULL

// this is ... questionable
- (instancetype) immutableInstance;

// these methods are threadsafe, but the called methods may not be
// its performSelector duty to check that
- (id) performSelector:(SEL) sel                  MULLE_OBJC_THREADSAFE_METHOD;
- (id) performSelector:(SEL) sel
            withObject:(id) obj                   MULLE_OBJC_THREADSAFE_METHOD;
- (id) performSelector:(SEL) sel
            withObject:(id) obj
            withObject:(id) other                 MULLE_OBJC_THREADSAFE_METHOD;

// for collections. isEqual: determines set membership
- (NSUInteger) hash;
- (BOOL) isEqual:(id) obj;

// like -description, but returns char *. Later on there will be a category
// on NSObject that implements this as [[self description] UTF8String]
// Having this on NSObject is a mulle extension!
- (char *) UTF8String;

// this is a mulle addition
- (void) mullePerformFinalize                      MULLE_OBJC_THREADSAFE_METHOD;
- (BOOL) mulleIsFinalized                          MULLE_OBJC_THREADSAFE_METHOD;

// some mulle additions for AAO mode and complete ObjectGraph support


PROTOCOLCLASS_END()


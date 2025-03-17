//
//  MulleProtocol.h
//  MulleObjC
//
//  Copyright (c) 2019 Nat! - Mulle kybernetiK.
//  Copyright (c) 2019 Codeon GmbH.
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


// This introduces a hierarchy of robustness of objects
//
// | Protocol                | Description
// |-------------------------|------------------------------------
// | `MulleObjCThreadUnsafe` | The default, only message from one thread concurrently. Protect code with an outside lock if needed.
// | `MulleObjCThreadSafe`   | Can be messaged from multiple threads concurrently. Protected by an inside lock or has atomic code.
// | `MulleObjCImmutable`    | Internal state does not change after -init. Can be messaged from multiple threads concurrently. No internal lock needed. Can return MulleObjCThreadUnsafe objects though.
// | `MulleObjCValue`        | Does not return `MulleObjCThreadUnsafe` objects (or unsafe pointers) from methods. Can be messaged from multiple threads concurrently. No internal lock needed.
//
// To adopt MulleObjCValue say: @interface Foo < MulleObjCValue, MulleObjCImmutable, MulleObjCThreadSafe>
// To adopt MulleObjCImmutable say: @interface Foo < MulleObjCImmutable, MulleObjCThreadSafe>
// To adopt MulleObjCThreadSafe say: @interface Foo < MulleObjCThreadSafe>
//
// Once a class has become <MulleObjCImmutable> or <MulleObjCValue> you can not
// make a subclass mutable again (since you can't remove protocols)
//
// You **can** turn a MulleObjCThreadUnsafe into MulleObjCThreadUnsafe and
// vice versa over the inheritance chain.
//
// A thread safe object, can be messaged from multiple threads, therefore a
// thread safe object is not checked for thread affinity. The return values
// of a thread safe object may not be thread safe though! The thread safety
// of the return value can not be determined by the type (e.g. NSString).
// Since you can return a NSMutableString as NSString.
//




// "MulleObjCThreadSafe" object can be messaged from multiple threads, may
// return objects that are not thread safe though.
//
// Only use -mulleIsThreadSafe to test for thread safety.
// DO NOT test for thread safety by -conformsToProtocol: since a class maybe
// marked both MulleObjCThreadSafe and MulleObjCThreadUnsafe in its
// inheritance chain. The last marker wins!
//
// Example: NSArray : NSObject < MulleObjCThreadSafe>
// -> MulleObjCThreadSafe
//
// Example: NSMutableArray : NSArray < MulleObjCThreadUnsafe>
// -> MulleObjCThreadUnsafe
//
// You don't have to marker you classes with MulleObjCThreadUnsafe,
// as this will be the default. But it's also not a bad self-documenting idea.
//
//
_PROTOCOLCLASS_INTERFACE0( MulleObjCThreadSafe)

@optional
- (BOOL) mulleIsThreadSafe    MULLE_OBJC_THREADSAFE_METHOD;
- (id) mulleThreadSafeCopy; // returns self retained

PROTOCOLCLASS_END()


_PROTOCOLCLASS_INTERFACE0( MulleObjCThreadUnsafe)

@optional
- (BOOL) mulleIsThreadSafe    MULLE_OBJC_THREADSAFE_METHOD;

// conceivably this method could be wrap a mutableCopy into a
// locking object (like MulleThreadSafeObject at time of writing)
- (id) mulleThreadSafeCopy;  // will return nil (!) this is useful so you can change affinity

PROTOCOLCLASS_END()


//
// "MulleImmutable" objects are inherently thread safe. But you need to
// declare this separately with MulleObjCThreadSafe. The tangible benefit of
// this protocol class is that you get the -copy operator for free.
//
// -conformsToProtocol:@selector( MulleObjCImmutable) must be a valid test.
//
//
_PROTOCOLCLASS_INTERFACE( MulleObjCImmutable, MulleObjCRuntimeObject)

@optional
- (id) copy;           // protocol return type is too tedious
- (id) immutableCopy;  // protocol return type is too tedious

PROTOCOLCLASS_END()


//
// A "MulleObjCInvariant" object, as an example is any immutable base type
// like one of the value classes like NSString, NSDate. The main promise of a
// "value" object is that it itself is immutable and that it only returns
// immutable return values. Therefore a regular NSArray can't be
// "MulleObjCInvariant". A NSValue is not a MulleObjCInvariant, because it
// can return arbitrary pointers. It's OK to return `char *` as long as its
// understood that the receiver won't modify or free it (needs to be
// autoreleased or static)
//
// So if any method returns a pointer to a mutable state (C or ObjC) --> NO.
//
// Note: Inherently you can't "prove" this, when you have a function like
// objc_setAssociatedObject...
//
// You MUST not subclass a MulleObjCInvariant and add mutable state unto it.
// Use composition for such setups.
//
// -conformsToProtocol:@selector( MulleObjCInvariant) must be a valid test.
//
// DON'T place MulleObjCInvariant on your value class cluster, but instead
// place it on each concrete subclass.
//
@protocol MulleObjCInvariant
@end



// Its expected that you can serialize a value.
@protocol MulleObjCValue
@end

// its expected that you can serialize a container
@protocol MulleObjCContainer
@end


@protocol MulleObjCContainerProperty

- (void) addObject:(id) object;
- (void) removeObject:(id) object;

@end


@protocol MulleObjCImmutableCopying;


// convenience declaration to put on concrete immutable value subclasses
// order is important here
// we can add MulleObjCImmutableCopying here
#define MulleObjCValueProtocols             MulleObjCRuntimeObject,   \
                                            MulleObjCValue,           \
                                            MulleObjCInvariant,       \
                                            MulleObjCImmutable,       \
                                            MulleObjCThreadSafe,      \
                                            MulleObjCImmutableCopying

// convenience declaration to put on concrete mutable value subclasses
// if your object is MutableValue it must not support deriving a
#define MulleObjCMutableValueProtocols      MulleObjCRuntimeObject,  \
                                            MulleObjCValue,          \
                                            MulleObjCThreadUnsafe


// convenience declaration to put on concrete immutable container subclasses
// we can add MulleObjCImmutableCopying here
#define MulleObjCContainerProtocols         MulleObjCRuntimeObject,  \
                                            MulleObjCContainer,      \
                                            MulleObjCImmutable,      \
                                            MulleObjCThreadSafe,     \
                                            MulleObjCImmutableCopying

// convenience declaration to put on concrete mutable container subclasses
// generally we don't like -mutableCopy and don't want to prolong its existence
#define MulleObjCMutableContainerProtocols  MulleObjCRuntimeObject,  \
                                            MulleObjCContainer,      \
                                            MulleObjCThreadUnsafe

// convenience declaration to put on all other immutable objects
// we can add MulleObjCImmutableCopying here
#define MulleObjCImmutableProtocols         MulleObjCRuntimeObject,   \
                                            MulleObjCImmutable,       \
                                            MulleObjCThreadSafe,      \
                                            MulleObjCImmutableCopying


// convenience declaration to *optionally* put on all other objects
#define MulleObjCMutableProtocols           MulleObjCRuntimeObject,  \
                                            MulleObjCThreadUnsafe


_PROTOCOLCLASS_INTERFACE0( MulleObjCPlaceboRetainCount)

@optional
- (instancetype) retain          MULLE_OBJC_THREADSAFE_METHOD;
- (instancetype) autorelease     MULLE_OBJC_THREADSAFE_METHOD;
- (void) release                 MULLE_OBJC_THREADSAFE_METHOD;

- (NSUInteger) retainCount       MULLE_OBJC_THREADSAFE_METHOD;

- (void) finalize;
- (void) dealloc;

@end

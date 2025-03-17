//
//  NSCopying.h
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

#import "mulle-objc-type.h"
#import "MulleObjCIntegralType.h"
#import "MulleObjCProtocol.h"
#import "NSZone.h"



//
// a -copy with respect to NSCopying is another instance of the receiver
// which is initialized to be as indistinguishable from the receiver as
// possible. If the receiver is immutable, you will just receive a retained
// instance of the receiver. The use of `-copy` is for creation of snapshots
// or creating instances from prototypes. `NSCopying` is used by properties.
// It's not used by NSDictionary, which uses `MulleObjCImmutableCopying` for keys.
//
// To copy an object to another allocator scheme (use NSCoypingWithAllocator)
//
// no longer a protocolclass!
//
@protocol NSCopying

- (id) copy;

//
// the old copyWithZone: is gone. If you have copyWithZone: methods,
// code a method -copy that calls your -copyWithZone:
//

@end



// MulleObjCImmutableCopying
//
// **Must** return an instance that is immutable. The general `isKindOfClass:`
// semantics should work on the returned instance, so if self is a
// NSString then the return value should also be a NSString.
// The instance is supposed to react to the same methods as the original, so
// returning a NSDictionary from a random object is not a `-copy`.
//
// Does not return an instancetype (e.g. NSMutableSet returns NSSet).
// If it isn't immutable, you should be using constructors to copy.
//
@protocol MulleObjCImmutableCopying < NSCopying>

- (id) immutableCopy;

@end




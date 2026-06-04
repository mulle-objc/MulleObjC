//
//  NSValue.h
//  MulleObjCValueFoundation
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
#import "NSObject.h"

#import "MulleObjCClassCluster.h"
#import "NSCopying.h"
#import "MulleObjCProtocol.h"
#import "MulleObjCRuntimeObject.h"

@class MulleObject;

// used by MulleObject
#define NSVALUE_DEFINED



// This is here, because BasicAnimation depends on it. And a NSValue is
// "pure C" enough, to warrant being included here. OK...
//
// a NSNumber is known to be invariant, but a NSValue could contain a
// pointer to something... Nevertheless all values are "copied" in and
// the whole object is thread safe.
//
@interface NSValue : NSObject < MulleObjCClassCluster, MulleObjCImmutable, MulleObjCThreadSafe>
{
}

+ (instancetype) value:(void *) bytes
          withObjCType:(char *) type;
+ (instancetype) valueWithBytes:(void *) bytes
                       objCType:(char *) type;
+ (instancetype) valueWithPointer:(void *) pointer;
+ (instancetype) valueWithRange:(NSRange) range;

+ (instancetype) valueWithNonretainedObject:(id) obj;

- (BOOL) isEqual:(id) other;
- (BOOL) isEqualToValue:(id) other;

- (NSRange) rangeValue;
- (void *) pointerValue;
- (id) nonretainedObjectValue;

- (void) getValue:(void *) value
             size:(NSUInteger) size;
@end


@interface NSValue ( SubclassesFuture)

// subclass must implement a compatible hash
// see _MulleObjCConcreteValue.h for details
- (NSUInteger) hash;
- (char *) objCType;
- (instancetype) initWithBytes:(void *) bytes
                      objCType:(char *) type;
- (void) getValue:(void *) bytes;

@end

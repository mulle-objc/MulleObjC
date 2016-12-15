//
//  NSCoder.h
//  MulleObjC
//
//  Copyright (c) 2016 Nat! - Mulle kybernetiK.
//  Copyright (c) 2016 Codeon GmbH.
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

#include "ns_type.h"
#include "ns_range.h"


@class NSString;
@class NSData;
@class NSSet;

//
// this class structure is historic ...
// people implement:
//
// - (void) encodeWithCoder:(NSCoder *) coder
//
// so NSArchiver and NSKeyesArchiver must subclass NSCoder.
//
// Your NSCoder object will either support keyed
// archiving or regular archiving but not both
// in this Foundation.
//
@interface NSCoder : NSObject

- (BOOL) allowsKeyedCoding;
- (NSInteger) systemVersion;

@end


@interface NSCoder ( Common)

- (NSInteger) versionForClassName:(NSString *) className;

@end

// future support
@interface NSCoder ( UnkeyedArchivingUnarchiving)

- (void) encodeDecodeValueOfObjCType:(char *) type
                                  at:(void *) addr;
- (void) encodeDecodeObject:(id) obj;
- (void) encodeDecodeConditionalObject:(id) obj;
- (void) encodeDecodeValuesOfObjCTypes:(char *) types, ...;

@end


@interface NSCoder ( UnkeyedArchiving)

- (void) encodeValueOfObjCType:(char *) type
                            at:(void *) addr;
- (void) encodeObject:(id) obj;
- (void) encodeRootObject:(id) obj;
- (void) encodeBycopyObject:(id) obj;
- (void) encodeByrefObject:(id) obj;
- (void) encodeConditionalObject:(id) obj;
- (void) encodeValuesOfObjCTypes:(char *) types, ...;
- (void) encodeArrayOfObjCType:(char *) type
                         count:(NSUInteger) count
                            at:(void *) array;
- (void) encodeBytes:(void *) bytes
              length:(NSUInteger) length;
- (void) encodePropertyList:(id) aPropertyList;

@end


@interface NSCoder ( UnkeyedUnarchiving)

- (void) decodeValueOfObjCType:(char *) type
                            at:(void *)data;
- (id) decodeObject;
- (void) decodeValuesOfObjCTypes:(char *) types, ...;
- (void) decodeArrayOfObjCType:(char *) itemType
                         count:(NSUInteger) count
                            at:(void *) array;

- (void *) decodeBytesWithReturnedLength:(NSUInteger *) len_p;

- (id)  decodePropertyList;

@end


@interface NSCoder ( KeyedArchiving)

- (void) encodeObject:(id)obj
               forKey:(NSString *) key;

- (void) encodeConditionalObject:(id)obj
                          forKey:(NSString *) key;
- (void) encodeBool:(BOOL) value
             forKey:(NSString *) key;
- (void) encodeInt:(int)value forKey:(NSString *) key;
- (void) encodeInt32:(int32_t)value
              forKey:(NSString *) key;
- (void) encodeInt64:(int64_t)value
              forKey:(NSString *) key;
- (void) encodeFloat:(float)value
              forKey:(NSString *) key;
- (void) encodeDouble:(double)value
               forKey:(NSString *) key;
- (void) encodeBytes:(void *) bytes
              length:(NSUInteger) len
              forKey:(NSString *) key;

- (void) encodeInteger:(NSInteger)value
                forKey:(NSString *) key;
@end


@interface NSCoder ( KeyedUnarchiving)

- (BOOL) containsValueForKey:(NSString *) key;

- (id) decodeObjectForKey:(NSString *) key;
- (BOOL) decodeBoolForKey:(NSString *) key;
- (int) decodeIntForKey:(NSString *) key;
- (int32_t) decodeInt32ForKey:(NSString *) key;
- (int64_t) decodeInt64ForKey:(NSString *) key;
- (float) decodeFloatForKey:(NSString *) key;
- (double) decodeDoubleForKey:(NSString *) key;
- (void *) decodeBytesForKey:(NSString *) key
              returnedLength:(NSUInteger *) len_p;

- (NSInteger) decodeIntegerForKey:(NSString *) key;

@end



#pragma mark -
#pragma mark Default methods for sublasses to pick

//
// these protocols supply implementations
//
@protocol MulleObjCUnkeyedArchiver

@optional
- (void) encodeObject:(id) obj;
- (void) encodeBycopyObject:(id) obj;
- (void) encodeByrefObject:(id) obj;
- (void) encodeConditionalObject:(id) obj;
- (void) encodeValuesOfObjCTypes:(char *) types, ...;
- (void) encodeArrayOfObjCType:(char *)type
                         count:(NSUInteger) count
                            at:(void *) array;

- (void) encodeBytes:(void *)bytes
              length:(NSUInteger)length;
@end


@protocol MulleObjCUnkeyedUnarchiver

@optional
- (id) decodeObject;
- (void) decodeValuesOfObjCTypes:(char *) types, ...;
- (void) decodeArrayOfObjCType:(char *) itemType
                         count:(NSUInteger) count
                            at:(void *) array;

- (void *) decodeBytesWithReturnedLength:(NSUInteger *) len_p;

- (void) encodePropertyList:(id) aPropertyList;
- (id)  decodePropertyList;

@end

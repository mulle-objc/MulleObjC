//
//  NSCoder.h
//  MulleObjC
//
//  Created by Nat! on 20/4/16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSObject.h"

#include "ns_type.h"
#include "ns_range.h"
#include <mulle_container/mulle_container.h>


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

- (NSInteger) systemVersion;
- (BOOL) allowsKeyedCoding;

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
// this protocols supplies the default implementations
// one would expect
//
@protocol NSUnkeyedArchiver

@optional
- (void) encodeObject:(id) obj;
- (void) encodeRootObject:(id) obj;
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


@protocol NSUnkeyedUnarchiver

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



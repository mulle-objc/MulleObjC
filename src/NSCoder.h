/* Copyright (c) 2006-2007 Christopher J. W. Lloyd

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */

#import "NSObject.h"

#include "ns_type.h"
#include "ns_range.h"
#include <mulle_container/mulle_container.h>


@class NSString,NSData;


@interface NSCoder : NSObject

-(NSUInteger)systemVersion;

-(void)setObjectZone:(NSZone *)zone;
-(NSZone *)objectZone;

-(BOOL)allowsKeyedCoding;


-(void)encodeObject:object;
-(void)encodePropertyList:propertyList;
-(void)encodeRootObject:rootObject;
-(void)encodeBycopyObject:object;
-(void)encodeByrefObject:object;

-(void)encodeConditionalObject:object;
-(void)encodeValuesOfObjCTypes:(char *)types,...;
-(void)encodeArrayOfObjCType:(char *)type count:(NSUInteger)count at:(void *)ptr;
-(void)encodeBytes:(void *)ptr length:(NSUInteger)length;

-(void)encodeBool:(BOOL)value forKey:(NSString *)key;
-(void)encodeConditionalObject:object forKey:(NSString *)key;
-(void)encodeDouble:(double)value forKey:(NSString *)key;
-(void)encodeFloat:(float)value forKey:(NSString *)key;
-(void)encodeInt:(int)value forKey:(NSString *)key;
-(void)encodeObject:object forKey:(NSString *)key;

-(void)encodeInt32:(int32_t)value forKey:(NSString *)key;
-(void)encodeInt64:(int64_t)value forKey:(NSString *)key;
-(void)encodeInteger:(NSInteger)value forKey:(NSString *)key;

-(void)encodeBytes:(void *)bytes length:(NSUInteger)length forKey:(NSString *)key;

-(id) decodeObject;
-(id) decodePropertyList;
-(void)decodeValuesOfObjCTypes:(char *)types,...;
-(void)decodeArrayOfObjCType:(char *)type count:(NSUInteger)count at:(void *)array;
-(void *)decodeBytesWithReturnedLength:(NSUInteger *)lengthp;

-(void *)decodeBytesForKey:(NSString *)key returnedLength:(NSUInteger *)lengthp;

-(BOOL)decodeBoolForKey:(NSString *)key;
-(double)decodeDoubleForKey:(NSString *)key;
-(float)decodeFloatForKey:(NSString *)key;
-(int)decodeIntForKey:(NSString *)key;
-(id) decodeObjectForKey:(NSString *)key;

-(int32_t)decodeInt32ForKey:(NSString *)key;
-(int64_t)decodeInt64ForKey:(NSString *)key;
-(NSInteger)decodeIntegerForKey:(NSString *)key;

@end


@interface NSCoder( Subclasses)

-(void)encodeDataObject:(NSData *)data;
-(NSData *)decodeDataObject;

-(NSInteger)versionForClassName:(NSString *)className;
-(void)decodeValueOfObjCType:(char *)type at:(void *)ptr;
-(void)encodeValueOfObjCType:(char *)type at:(void *)ptr;

-(BOOL)containsValueForKey:(NSString *)key;

@end



//-(void)encodePoint:(NSPoint)point;
//-(void)encodeSize:(NSSize)size;
//-(void)encodeRect:(NSRect)rect;
//
//-(void)encodePoint:(NSPoint)value forKey:(NSString *)key;
//-(void)encodeRect:(NSRect)value forKey:(NSString *)key;
//-(void)encodeSize:(NSSize)value forKey:(NSString *)key;
//
//
//-(NSPoint)decodePoint;
//-(NSSize)decodeSize;
//-(NSRect)decodeRect;
//
//
//-(NSPoint)decodePointForKey:(NSString *)key;
//-(NSRect)decodeRectForKey:(NSString *)key;
//-(NSSize)decodeSizeForKey:(NSString *)key;


/* Copyright (c) 2006-2007 Christopher J. W. Lloyd
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */

// Original - Christopher Lloyd <cjwl@objc.net>
#import "NSCoder.h"

#import "MulleObjCAllocation.h"
#import "MulleObjCFunctions.h"

#include <string.h>
#include <stdio.h>


@implementation NSCoder

-(NSUInteger )systemVersion {
   return 0;
}

-(void)setObjectZone:(NSZone *)zone {
   // do nothing
}


-(NSZone *)objectZone {
   return NSDefaultMallocZone();
}

-(BOOL)allowsKeyedCoding {
   return NO;
}


// the mulle scheme only wor
-(void)encodeObject:object
{
   [self encodeValueOfObjCType:@encode(id) at:&object];
}


-(void)encodePropertyList:propertyList {
   [self encodeValueOfObjCType:@encode(id) at:&propertyList];
}

-(void)encodeRootObject:rootObject {
   [self encodeObject:rootObject];
}


-(void)encodeBycopyObject:object {
   [self encodeObject:object];
}

-(void)encodeByrefObject:object {
   [self encodeObject:object];
}

-(void)encodeConditionalObject:object {
   [self encodeObject:object];
}



- (void) encodeArrayOfObjCType:(char *) itemType
                         count:(NSUInteger) count
                            at:(void *) ptr
{
   char   *typeBuf;
   
   typeBuf = alloca( 128 + strlen( itemType));
   
   sprintf(typeBuf, "[%lu%s]",  (unsigned long) count, itemType);
   [self encodeValueOfObjCType:typeBuf
                            at:ptr];
}


- (void)encodeBytes:(void *) byteaddr
             length:(NSUInteger)length
{
   char   typeBuf[ 128];
   
   sprintf( typeBuf, "[%luc]", (unsigned long) length);
   
   [self encodeValueOfObjCType:@encode(NSUInteger)
                            at:&length];
   [self encodeValueOfObjCType:typeBuf at:byteaddr];
}


-(void)encodeBool:(BOOL)value forKey:(NSString *)key {
   [self encodeValueOfObjCType:@encode(BOOL) at:&value];
}

-(void)encodeConditionalObject:object forKey:(NSString *)key {
   [self encodeConditionalObject:object];
}

-(void)encodeDouble:(double)value forKey:(NSString *)key {
   [self encodeValueOfObjCType:@encode(double) at:&value];
}

-(void)encodeFloat:(float)value forKey:(NSString *)key {
   [self encodeValueOfObjCType:@encode(float) at:&value];
}

-(void)encodeInt:(int)value forKey:(NSString *)key {
   [self encodeValueOfObjCType:@encode(int) at:&value];
}

-(void)encodeObject:object forKey:(NSString *)key {
   [self encodeObject:object];
}

-(void)encodeInt32:(int32_t)value forKey:(NSString *)key {
   [self encodeValueOfObjCType:@encode(int32_t) at:&value];
}

-(void)encodeInt64:(int64_t)value forKey:(NSString *)key {
   [self encodeValueOfObjCType:@encode(int64_t) at:&value];
}

-(void)encodeInteger:(NSInteger)value forKey:(NSString *)key {
   [self encodeValueOfObjCType:@encode(NSInteger) at:&value];
}

-(void)encodeBytes:(void *)bytes length:(NSUInteger)length forKey:(NSString *)key {
   [self encodeBytes:bytes length:length];
}


- (id) decodeObject {
   id object=nil;
   [self decodeValueOfObjCType:@encode(id) at:&object];
   return [object autorelease];
}


-(id)  decodePropertyList {
   id object=nil;
   [self decodeValueOfObjCType:@encode(id) at:&object];
   return [object autorelease];
}


static void   codecValuesOfObjCTypes( NSCoder *self,
                                      char *types,
                                      mulle_vararg_list arguments,
                                      SEL sel)
{
   IMP    imp;
   struct
   {
      char  *types;
      void  *ptr;
   } param;
   
   imp = [self methodForSelector:sel];
   
   while( types)
   {
      param.ptr   = mulle_vararg_next_pointer( arguments, void *);
      param.types = types;

      (*imp)( self, sel, &param);

      types = NSGetSizeAndAlignment( types, NULL, NULL);
   }
}


- (void) encodeValuesOfObjCTypes:(char *) types, ...
{
   mulle_vararg_list     arguments;

   mulle_vararg_start(arguments,types);

   codecValuesOfObjCTypes( self, types, arguments, @selector(encodeValueOfObjCType:at:));

   mulle_vararg_end(arguments);
}


- (void) decodeValuesOfObjCTypes:(char *) types, ...
{
   mulle_vararg_list     arguments;

   mulle_vararg_start(arguments,types);

   codecValuesOfObjCTypes( self, types, arguments, @selector(decodeValueOfObjCType:at:));

   mulle_vararg_end(arguments);
}


- (void)decodeArrayOfObjCType:(char *)itemType count:(NSUInteger)count at:(void *)ptr
{
    char *typeBuf;
   
    typeBuf = alloca( 128 + strlen(itemType));

    sprintf(typeBuf, "[%lu%s]", (unsigned long) count, itemType);
    [self decodeValueOfObjCType:typeBuf at:ptr];
}


- (void *)decodeBytesWithReturnedLength:(NSUInteger *)lengthp
{
    char typeBuf[ 128];
    void *byteaddr;

    [self decodeValueOfObjCType:@encode(NSUInteger) at:lengthp];

    byteaddr = NSZoneCalloc(NULL, *lengthp, sizeof(char));
    sprintf(typeBuf, "[%luc]", (unsigned long) *lengthp);
    [self decodeValueOfObjCType:typeBuf at:byteaddr];
    return byteaddr;
}


-(void *)decodeBytesForKey:(NSString *)key returnedLength:(NSUInteger *)lengthp {
   *lengthp=0;
   return NULL;
}

-(BOOL)decodeBoolForKey:(NSString *)key {
   BOOL result;
   [self decodeValueOfObjCType:@encode(BOOL) at:&result];
   return result;
}

-(double)decodeDoubleForKey:(NSString *)key {
   double result;
   [self decodeValueOfObjCType:@encode(double) at:&result];
   return result;
}

-(float)decodeFloatForKey:(NSString *)key {
   float result;
   [self decodeValueOfObjCType:@encode(float) at:&result];
   return result;
}

-(int)decodeIntForKey:(NSString *)key {
   int result;
   [self decodeValueOfObjCType:@encode(int) at:&result];
   return result;
}

-decodeObjectForKey:(NSString *)key {
   return [self decodeObject];
}

-(int32_t)decodeInt32ForKey:(NSString *)key {
   int32_t result;
   [self decodeValueOfObjCType:@encode(int32_t) at:&result];
   return result;
}

-(int64_t)decodeInt64ForKey:(NSString *)key {
   int64_t result;
   [self decodeValueOfObjCType:@encode(int64_t) at:&result];
   return result;
}

-(NSInteger)decodeIntegerForKey:(NSString *)key {

   NSInteger result;
   [self decodeValueOfObjCType:@encode(NSInteger) at:&result];
   return result;
}

@end


//-(void)encodePoint:(NSPoint)point {
//   [self encodeValueOfObjCType:@encode(NSPoint) at:&point];
//}
//
//-(void)encodeSize:(NSSize)size {
//   [self encodeValueOfObjCType:@encode(NSSize) at:&size];
//}
//
//-(void)encodeRect:(NSRect)rect {
//   [self encodeValueOfObjCType:@encode(NSRect) at:&rect];
//}
//
//-(void)encodePoint:(NSPoint)value forKey:(NSString *)key {
//   [self encodeValueOfObjCType:@encode(NSPoint) at:&value];
//}
//
//-(void)encodeRect:(NSRect)value forKey:(NSString *)key {
//   [self encodeValueOfObjCType:@encode(NSRect) at:&value];
//}
//
//-(void)encodeSize:(NSSize)value forKey:(NSString *)key {
//   [self encodeValueOfObjCType:@encode(NSSize) at:&value];
//}
//
//-(NSPoint)decodePoint {
//   NSPoint point;
//   [self decodeValueOfObjCType:@encode(NSPoint) at:&point];
//   return point;
//}
//
//-(NSSize)decodeSize {
//   NSSize size;
//   [self decodeValueOfObjCType:@encode(NSSize) at:&size];
//   return size;
//}
//
//-(NSRect)decodeRect {
//   NSRect rect;
//   [self decodeValueOfObjCType:@encode(NSRect) at:&rect];
//   return rect;
//}
//
//-(NSPoint)decodePointForKey:(NSString *)key {
//   NSPoint result;
//   [self decodeValueOfObjCType:@encode(NSPoint) at:&result];
//   return result;
//}
//
//-(NSRect)decodeRectForKey:(NSString *)key {
//   NSRect result;
//   [self decodeValueOfObjCType:@encode(NSRect) at:&result];
//   return result;
//}
//
//-(NSSize)decodeSizeForKey:(NSString *)key {
//   NSSize result;
//   [self decodeValueOfObjCType:@encode(NSSize) at:&result];
//   return result;
//}
//



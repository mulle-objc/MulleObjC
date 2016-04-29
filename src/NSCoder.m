//
//  NSCoder.h
//  MulleObjC
//
//  Created by Nat! on 20/4/16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//
#import "NSCoder.h"

// other files in this library
#import "MulleObjCFunctions.h"

// std-c and dependencies


/*
Copyright (c) 2006-2007 Christopher J. W. Lloyd
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

@implementation NSCoder


- (NSInteger) systemVersion
{
   return( MULLE_OBJC_VERSION);
}


-(void) setObjectZone:(NSZone *)zone
{
}


- (NSZone *) objectZone
{
   return( NULL);
}


- (BOOL) allowsKeyedCoding
{
   return( NO);
}

@end


#pragma mark -
#pragma mark NSUnkeyedArchiver Protocol with default implementations


@interface NSUnkeyedArchiver
@end


@interface NSUnkeyedArchiver ( UnkeyedArchiving)

- (void) encodeValueOfObjCType:(char *) type
                            at:(void *) addr;
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
- (void) encodePropertyList:(id) aPropertyList;

@end


@implementation NSUnkeyedArchiver

- (void) encodeObject:(id)object
{
   [self encodeValueOfObjCType:@encode( id)
                            at:&object];
}


- (void) encodePropertyList:(id) propertyList
{
   [self encodeValueOfObjCType:@encode( id)
                            at:&propertyList];
}


- (void) encodeRootObject:(id) rootObject
{
   [self encodeObject:rootObject];
}


- (void) encodeBycopyObject:(id) object
{
   [self encodeObject:(id) object];
}


- (void) encodeByrefObject:(id) object
{
   [self encodeObject:(id) object];
}


- (void) encodeConditionalObject:(id) object
{
   [self encodeObject:(id) object];
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


- (void) encodeBytes:(void *) byteaddr
              length:(NSUInteger)length
{
   char   typeBuf[ 128];
   
   sprintf( typeBuf, "[%luc]", (unsigned long) length);
   
   [self encodeValueOfObjCType:@encode(NSUInteger)
                            at:&length];
   [self encodeValueOfObjCType:typeBuf at:byteaddr];
}

#pragma mark -
#pragma mark coding / decoding

static void   codecValuesOfObjCTypes( NSCoder< NSObject> *self,
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
   
   codecValuesOfObjCTypes( (NSCoder< NSObject> *) self, types, arguments, @selector(encodeValueOfObjCType:at:));
   
   mulle_vararg_end(arguments);
}

@end


#pragma mark -
#pragma mark NSUnkeyedUnarchiver Protocol with default implementations

@interface NSUnkeyedUnarchiver
@end


@interface NSUnkeyedUnarchiver ( KeyedUnarchiving)

- (void) decodeValueOfObjCType:(char *) type
                            at:(void *)data;
- (id) decodeObject;
- (void) decodeValuesOfObjCTypes:(char *) types, ...;
- (void) decodeArrayOfObjCType:(char *) itemType
                         count:(NSUInteger) count
                            at:(void *) array;

- (void *) decodeBytesWithReturnedLength:(NSUInteger *) len_p;

- (id) decodePropertyList;

@end


@implementation NSUnkeyedUnarchiver

- (void) decodeValuesOfObjCTypes:(char *) types, ...
{
   mulle_vararg_list     arguments;
   
   mulle_vararg_start(arguments,types);
   
   codecValuesOfObjCTypes( (NSCoder< NSObject> *) self, types, arguments, @selector(decodeValueOfObjCType:at:));
   
   mulle_vararg_end(arguments);
}


#pragma mark -
#pragma mark decoding


- (id) decodeObject
{
   id   object;
   
   [self decodeValueOfObjCType:@encode(id)
                            at:&object];
   return( [object autorelease]);
}


- (id) decodePropertyList
{
   id   object;
   
   [self decodeValueOfObjCType:@encode(id)
                            at:&object];
   return( [object autorelease]);
}


- (void) decodeArrayOfObjCType:(char *) itemType
                         count:(NSUInteger) count
                            at:(void *)ptr
{
   char   *typeBuf;
   
   typeBuf = alloca( 128 + strlen(itemType));
   
   sprintf(typeBuf, "[%lu%s]", (unsigned long) count, itemType);
   [self decodeValueOfObjCType:typeBuf at:ptr];
}


- (void *) decodeBytesWithReturnedLength:(NSUInteger *) len_p
{
   char    typeBuf[ 128];
   void    *buf;
   
   [self decodeValueOfObjCType:@encode(NSUInteger)
                            at:len_p];
   
   buf = MulleObjCAllocateMemory( *len_p);

   sprintf( typeBuf, "[%luc]", (unsigned long) *len_p);
   [self decodeValueOfObjCType:typeBuf
                            at:buf];
   return( buf);
}

@end



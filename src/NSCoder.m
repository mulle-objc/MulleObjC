//
//  NSCoder.m
//  MulleObjC
//
//  Copyright (c) 2007 Nat! - Mulle kybernetiK.
//  Copyright (c) 2007 Codeon GmbH.
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
#import "NSCoder.h"

// other files in this library
#import "MulleObjCFunctions.h"
#import "MulleObjCAllocation.h"

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


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-root-class"


#pragma mark -
#pragma mark MulleObjCUnkeyedArchiver Protocol with default implementations


@interface MulleObjCUnkeyedArchiver < MulleObjCUnkeyedArchiver>
@end


@interface MulleObjCUnkeyedArchiver ( Declarations)

- (void) encodeValueOfObjCType:(char *) type
                            at:(void *) addr;
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
- (void) encodePropertyList:(id) aPropertyList;

@end


#pragma clang diagnostic pop


@implementation MulleObjCUnkeyedArchiver

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
                            at:(void *) bytes
{
   char   typeBuf[ 64 + strlen( itemType)];

   sprintf(typeBuf, "[%lu%s]",  (unsigned long) count, itemType);
   [self encodeValueOfObjCType:typeBuf
                            at:bytes];
}


- (void) encodeBytes:(void *) bytes
              length:(NSUInteger) length
{
   char   typeBuf[ 64];

   sprintf( typeBuf, "[%luc]", (unsigned long) length);

   [self encodeValueOfObjCType:@encode( NSUInteger)
                            at:&length];
   [self encodeValueOfObjCType:typeBuf
                            at:bytes];
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

   while( *types)
   {
      param.types = types;
      param.ptr   = mulle_vararg_next_pointer( arguments, void *);

      (*imp)( self, sel, &param);

      types = NSGetSizeAndAlignment( types, NULL, NULL); // skip over current
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


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-root-class"


#pragma mark -
#pragma mark MulleObjCUnkeyedUnarchiver Protocol with default implementations

@interface MulleObjCUnkeyedUnarchiver < MulleObjCUnkeyedUnarchiver>
@end


@interface MulleObjCUnkeyedUnarchiver ( Declarations)

- (void) decodeValueOfObjCType:(char *) type
                            at:(void *)data;
- (void) decodeValuesOfObjCTypes:(char *) types, ...;
- (void) decodeArrayOfObjCType:(char *) itemType
                         count:(NSUInteger) count
                            at:(void *) array;

- (void *) decodeBytesWithReturnedLength:(NSUInteger *) len_p;

- (id) decodeObject;
- (id) decodePropertyList;

@end


#pragma clang diagnostic pop


@implementation MulleObjCUnkeyedUnarchiver

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

   object = nil;  // important for leak detection
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
   char   typeBuf[ 128 + strlen( itemType)];

   //   typeBuf = alloca( 128 + strlen( itemType));

   sprintf(typeBuf, "[%lu%s]", (unsigned long) count, itemType);
   [self decodeValueOfObjCType:typeBuf at:ptr];
}


- (void *) decodeBytesWithReturnedLength:(NSUInteger *) len_p
{
   char    typeBuf[ 128];
   void    *buf;

   [self decodeValueOfObjCType:@encode(NSUInteger)
                            at:len_p];

   buf = MulleObjCObjectAllocateMemory( self, *len_p);

   sprintf( typeBuf, "[%luc]", (unsigned long) *len_p);
   [self decodeValueOfObjCType:typeBuf
                            at:buf];
   return( buf);
}

@end

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


// TODO: rename to MulleObjCMutableCopyingWithAllocator or just move
//       to NSMutableCopying

// MEMO: scheme needs to remember allocator in the instance header or ?

// NSCopyingWithAllocator is supposed to be used to transfer an object and
// it's ivars/properties to another allocator. If it can be determined that
// the object is already there, then this will just retain.
// Otherwise the default implementation will copy all integer/fp ivars
// harmless, deep/copy char * as strings and copyWithAlloator: all properties
// that is an object and not marked as assign:
//
// @interface Foo : NSObject
// {
//    int  _a;                      // copied
//    struct { int a; int b};  _b;  // copied (dangerous if struct contains id)
//    char *_c;                     // strduped
//    void *_d;                     // zeroed!
//    id   _e;                      // zeroed!
// }
// @property( assign) id  f;        // zeroed
// @property( copy)   id  f;        // copied
// @property( retain) id  f;        // zeroed
//
@protocol NSCopyingWithAllocator

@optional
- (id) copyWithAllocator:(struct mulle_allocator *) allocator;

@end


@class NSCopyingWithAllocator; // needed for the compiler to understand this is
                               // protocol class

MULLE_OBJC_GLOBAL
id   NSCopyObjectWithAllocator( id object,
                                NSUInteger extraBytes,
                                struct mulle_allocator *allocator);

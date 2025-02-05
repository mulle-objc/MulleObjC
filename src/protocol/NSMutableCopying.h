//
//  NSMutableCopying.h
//  MulleObjCContainerFoundation
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
#import "MulleObjCProtocol.h"

struct NSZone;


//
// Using -mutableCopy breaks the possibilty of returning nil for empty mutable 
// containers. 
//
//  NSMutableArray   *array;
//  array = [foo mutableArray];
//  [array addObject:@"foo"];
//  assert( [array count] >= 1);  // BOOM
//

@protocol NSMutableCopying

//
// Does not retun an instancetype (e.g. NSMutableSet returns NSSet).
// Should return an instance that is immutable.
// If it isn't immutable, you should be using -mutableCopy (which is
// deprecated), or simply use constructors to copy.
//
@optional  // only optional, if derived from NSObject
- (id) mutableCopy;

//
// if YES, then all properties that are marked "copy" or "retain" are
// copyied and retained during -copy (using NSCopyObject)
//
+ (BOOL) mulleCopyRetainsProperties;  // default YES!

@end


@class NSMutableCopying; // needed for the compiler to understand this is
                        // protocol class


MULLE_OBJC_GLOBAL
id   MulleObjCInstanceCopy( id object, NSUInteger extraBytes, NSZone *zone);

static inline id   NSCopyObject( id object, NSUInteger extraBytes, NSZone *zone)
{
    return( MulleObjCInstanceCopy( object, extraBytes, zone));
}


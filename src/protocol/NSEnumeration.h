//
//  NSFastEnumeration.h
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


//
// The object that is enumerated needs to be retained by the enumerator for
// the duration of the enumeration, which can be forever.
//
@protocol NSEnumeration

- (id) nextObject;

@end


typedef struct
{
   NSUInteger   state;
   id           *itemsPtr;
   NSUInteger   *mutationsPtr;
   NSUInteger   extra[5];
} NSFastEnumerationState;


//
// One principal advantage of NSFastEnumeration over NSEnumeration is,
// that it is specified for `for` `in` loops. That means that the object
// that gets enumerated need not be retained.
//
@protocol NSFastEnumeration

- (NSUInteger) count;  // exerimentally added, this way
                       // NSFastEnumeration is basically NSContainer (if it existed)
- (NSUInteger) countByEnumeratingWithState:(NSFastEnumerationState *) state
                                   objects:(id *) objects
                                     count:(NSUInteger) count;
@end

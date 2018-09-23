//
//  ns_fastclassids.h
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

// included in "include.h" and nowhere else

#ifndef mulle_objc_fastclassid_h__
#define mulle_objc_fastclassid_h__

//
// we define some fastclasses, where the hash MUST be an integer constant
// A fastclass makes sense, where there are lots of class method calls
//
#define MULLE_OBJC_FASTCLASS_0    MULLE_OBJC_CLASSID( 0x233490fe)   // "NSArray"
#define MULLE_OBJC_FASTCLASS_1    MULLE_OBJC_CLASSID( 0x58bb178a)   // "NSAutoreleasePool"
#define MULLE_OBJC_FASTCLASS_2    MULLE_OBJC_CLASSID( 0xb8742fcb)   // "NSCalendarDate"
#define MULLE_OBJC_FASTCLASS_3    MULLE_OBJC_CLASSID( 0xbb258d72)   // "NSCharacterSet"
#define MULLE_OBJC_FASTCLASS_4    MULLE_OBJC_CLASSID( 0x8fce7861)   // "NSData"
#define MULLE_OBJC_FASTCLASS_5    MULLE_OBJC_CLASSID( 0xcfcedd21)   // "NSDate"
#define MULLE_OBJC_FASTCLASS_6    MULLE_OBJC_CLASSID( 0x4a91670d)   // "NSDecimalNumber"
#define MULLE_OBJC_FASTCLASS_7    MULLE_OBJC_CLASSID( 0x8b2abcad)   // "NSDictionary"
#define MULLE_OBJC_FASTCLASS_8    MULLE_OBJC_CLASSID( 0xf5e6dbdd)   // "NSMutableArray"
#define MULLE_OBJC_FASTCLASS_9    MULLE_OBJC_CLASSID( 0x5d7fdc81)   // "NSMutableData"
#define MULLE_OBJC_FASTCLASS_10   MULLE_OBJC_CLASSID( 0x1225d451)   // "NSMutableDictiona"
#define MULLE_OBJC_FASTCLASS_11   MULLE_OBJC_CLASSID( 0x1fa72100)   // "NSMutableSet"
#define MULLE_OBJC_FASTCLASS_12   MULLE_OBJC_CLASSID( 0x63662493)   // "NSMutableString"
#define MULLE_OBJC_FASTCLASS_13   MULLE_OBJC_CLASSID( 0x8ba34f39)   // "NSNumber"
#define MULLE_OBJC_FASTCLASS_14   MULLE_OBJC_CLASSID( 0x9f69e3e4)   // "NSSet"
#define MULLE_OBJC_FASTCLASS_15   MULLE_OBJC_CLASSID( 0x1994a171)   // "NSString"

// room for 16 more ATM, leave it for user programs

#endif /* ns_fastclassids_h */

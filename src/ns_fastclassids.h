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

#ifndef ns_fastclassids_h__
#define ns_fastclassids_h__

//
// we define some fastclasses, where the hash MUST be an integer constant
// A fastclass makes sense, where there are lots of class method calls
//
#define MULLE_OBJC_FASTCLASSHASH_0    0x55e6335f  // NSArray
#define MULLE_OBJC_FASTCLASSHASH_1    0x5b791fc6  // NSAutoreleasePool
#define MULLE_OBJC_FASTCLASSHASH_2    0x732630c6  // NSCalendarDate
#define MULLE_OBJC_FASTCLASSHASH_3    0xb452f5f7  // NSCharacterSet
#define MULLE_OBJC_FASTCLASSHASH_4    0x7d1455e8  // NSData
#define MULLE_OBJC_FASTCLASSHASH_5    0x7d1455ec  // NSDate
#define MULLE_OBJC_FASTCLASSHASH_6    0x8be1d472  // NSDecimalNumber
#define MULLE_OBJC_FASTCLASSHASH_7    0xca46313c  // NSDictionary

#define MULLE_OBJC_FASTCLASSHASH_8    0x33fb2e49  // NSMutableArray
#define MULLE_OBJC_FASTCLASSHASH_9    0x80af06be  // NSMutableData
#define MULLE_OBJC_FASTCLASSHASH_10   0xedeb2f5a  // NSMutableDictionary
#define MULLE_OBJC_FASTCLASSHASH_11   0xe6cae1ee  // NSMutableSet
#define MULLE_OBJC_FASTCLASSHASH_12   0xfcaa2a91  // NSMutableString
#define MULLE_OBJC_FASTCLASSHASH_13   0x1fa441bb  // NSNumber
#define MULLE_OBJC_FASTCLASSHASH_14   0x9a5ad940  // NSSet
#define MULLE_OBJC_FASTCLASSHASH_15   0x85e3fa43  // NSString

// room for 16 more ATM, leave it for user programs

#endif /* ns_fastclassids_h */

//
//  ns_fastmethodids.h
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

#ifndef ns_fastmethodids_h__
#define ns_fastmethodids_h__

// we define some fastmethods, where the id MUST be a constant integer
//
// a good candidate is a method, which is called often AND
// few instructions are executed (i.e. the overhead of
// the call is most noticable). e.g. objectForKey: is NOT that
// great, -class is though.
// https://www.mulle-kybernetik.com/weblog/2015/mulle_objc_selector_statistics.html
//
#define MULLE_OBJC_FASTMETHODHASH_8     0x55075535  // length
#define MULLE_OBJC_FASTMETHODHASH_9     0xaf289042  // count
#define MULLE_OBJC_FASTMETHODHASH_10    0x31e0a06b  // self [^1]
#define MULLE_OBJC_FASTMETHODHASH_11    0xd7918815  // hash
#define MULLE_OBJC_FASTMETHODHASH_12    0x215a792f  // nextObject
#define MULLE_OBJC_FASTMETHODHASH_13    0x1446ae6c  // timeIntervalSinceReferenceDate [^1]
#define MULLE_OBJC_FASTMETHODHASH_14    0x1d2fd708  // lock
#define MULLE_OBJC_FASTMETHODHASH_15    0xff3a51ed  // unlock

#define MULLE_OBJC_FASTMETHODHASH_16    0x5e8533db  // class
#define MULLE_OBJC_FASTMETHODHASH_17    0x0f5af8fe  // isKindOfClass:
#define MULLE_OBJC_FASTMETHODHASH_18    0x583757c5  // objectAtIndex:
#define MULLE_OBJC_FASTMETHODHASH_19    0xe7e69dc3  // characterAtIndex:
#define MULLE_OBJC_FASTMETHODHASH_20    0x3e6d60be  // methodForSelector:
#define MULLE_OBJC_FASTMETHODHASH_21    0x65c6a26b  // respondsToSelector:

// candidates:
// methodForSelector:
// performSelector:
// sharedInstance

#endif /* ns_fastmethodids_h */

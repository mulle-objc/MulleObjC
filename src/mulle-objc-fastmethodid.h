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

// included in "include.h" and nowhere else

#ifndef mulle_objc_fastmethodid__h__
#define mulle_objc_fastmethodid__h__

// we define some fastmethods, where the id MUST be a constant integer
//
// A good candidate is a method, which is called often AND
// few instructions are executed (i.e. the overhead of
// the call is most noticable). e.g. objectForKey: is NOT that
// great, -class is though. objectForKey: could be good, if is used very often
// for space saving.
//
// https://www.mulle-kybernetik.com/weblog/2015/mulle_objc_selector_statistics.html
//
//#define MULLE_OBJC_FASTMETHODHASH_0    MULLE_OBJC_METHODID( 0x3d036158)   // "alloc"
//#define MULLE_OBJC_FASTMETHODHASH_1    MULLE_OBJC_METHODID( 0x3d036158)   // "init"
//#define MULLE_OBJC_FASTMETHODHASH_2    MULLE_OBJC_METHODID( 0x3d036158)   // "finalize"
//#define MULLE_OBJC_FASTMETHODHASH_3    MULLE_OBJC_METHODID( 0x3d036158)   // "dealloc"
//#define MULLE_OBJC_FASTMETHODHASH_4    MULLE_OBJC_METHODID( 0x8c60cbab)   // "object"
//#define MULLE_OBJC_FASTMETHODHASH_5    MULLE_OBJC_METHODID( 0x3d036158)   // "autorelease"
#define MULLE_OBJC_FASTMETHODHASH_6    MULLE_OBJC_METHODID( 0x3d036158)   // "length"
#define MULLE_OBJC_FASTMETHODHASH_7    MULLE_OBJC_METHODID( 0x9b1ddf43)   // "count"
#define MULLE_OBJC_FASTMETHODHASH_8    MULLE_OBJC_METHODID( 0x45ba2776)   // "self"
#define MULLE_OBJC_FASTMETHODHASH_9    MULLE_OBJC_METHODID( 0xec577d1c)   // "hash"
#define MULLE_OBJC_FASTMETHODHASH_10   MULLE_OBJC_METHODID( 0x6de415fe)   // "nextObject"
#define MULLE_OBJC_FASTMETHODHASH_11   MULLE_OBJC_METHODID( 0x0d59b56e)   // "timeIntervalSinceReferenceDate"
#define MULLE_OBJC_FASTMETHODHASH_12   MULLE_OBJC_METHODID( 0xf0d7842e)   // "lock"
#define MULLE_OBJC_FASTMETHODHASH_13   MULLE_OBJC_METHODID( 0x6661f555)   // "unlock"
#define MULLE_OBJC_FASTMETHODHASH_14   MULLE_OBJC_METHODID( 0xb3e0bffa)   // "class"
#define MULLE_OBJC_FASTMETHODHASH_15   MULLE_OBJC_METHODID( 0x33db2a40)   // "isKindOfClass:"
#define MULLE_OBJC_FASTMETHODHASH_16   MULLE_OBJC_METHODID( 0x1cc541d5)   // "objectAtIndex:"
#define MULLE_OBJC_FASTMETHODHASH_17   MULLE_OBJC_METHODID( 0x331e633c)   // "characterAtIndex:"
#define MULLE_OBJC_FASTMETHODHASH_18   MULLE_OBJC_METHODID( 0xf6bec249)   // "methodForSelector:"
#define MULLE_OBJC_FASTMETHODHASH_19   MULLE_OBJC_METHODID( 0xcf4a54f0)   // "respondsToSelector:"
#define MULLE_OBJC_FASTMETHODHASH_20   MULLE_OBJC_METHODID( 0x12976ce9)   // "objectForKey:"
#define MULLE_OBJC_FASTMETHODHASH_21   MULLE_OBJC_METHODID( 0xf0cb86d3)   // ":"

// candidates:
// performSelector:
// sharedInstance

#endif /* ns_fastmethodids_h */

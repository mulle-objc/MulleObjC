//
//  ns_fastmethodids.h
//  MulleObjC
//
//  Created by Nat! on 06.02.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
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
// respondsToSelector: !

#endif /* ns_fastmethodids_h */

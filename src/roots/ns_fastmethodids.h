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
#define MULLE_OBJC_FASTMETHODHASH_8     0x2fa47f7c65fec19c  // length
#define MULLE_OBJC_FASTMETHODHASH_9     0xe2942a04780e223b  // count
#define MULLE_OBJC_FASTMETHODHASH_10    0x590f53e8699817c6  // self [^1]
#define MULLE_OBJC_FASTMETHODHASH_11    0x0800fc577294c34e  // hash
#define MULLE_OBJC_FASTMETHODHASH_12    0x6ceb43ffc1176cf9  // isEqual:
#define MULLE_OBJC_FASTMETHODHASH_13    0xa0d32c96ace2fe85  // timeIntervalSinceReferenceDate [^1]
#define MULLE_OBJC_FASTMETHODHASH_14    0xdce7c4174ce93239  // lock
#define MULLE_OBJC_FASTMETHODHASH_15    0x474f3c5e4e32cc95  // unlock

#define MULLE_OBJC_FASTMETHODHASH_16    0xa2f2ed4f8ebc2cbb  // class
#define MULLE_OBJC_FASTMETHODHASH_17    0x3838e21c79bfd8ce  // isKindOfClass:
#define MULLE_OBJC_FASTMETHODHASH_18    0x395aeda846bc6bee  // objectAtIndex:
#define MULLE_OBJC_FASTMETHODHASH_19    0x1b24725408b990ce  // characterAtIndex:


#endif /* ns_fastmethodids_h */

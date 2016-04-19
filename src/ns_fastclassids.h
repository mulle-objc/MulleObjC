//
//  ns_fastclassids.h
//  MulleObjC
//
//  Created by Nat! on 06.02.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
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

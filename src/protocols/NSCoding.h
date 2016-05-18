//
//  NSCoding.h
//  MulleObjCPosixFoundation
//
//  Created by Nat! on 16.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

@class NSCoder;


@protocol NSCoding


- (void) encodeWithCoder:(NSCoder *) aCoder;
- (instancetype) initWithCoder:(NSCoder *) aDecoder;

// class clusters! you must decode during decodeWithCoder:
// subsitute your instance in -initWithCoder and do nothing else
// (you may look at pure data, but not at references)
// example: NSData can do it all in -initWithCoder:, NSArray can
// not. But both MUST implement decodeWithCoder:

@optional
- (Class) classForCoder;  // you get this for free
- (void) decodeWithCoder:(NSCoder *) aDecoder;

// tired of writing basically the same code in encodeWithCoder:
// and decodeWithCoder: ? use encodeDecodeWithCoder:
// FUTURE:
//@optional
//- (void) encodeDecodeWithCoder:(NSCoder *) aDecoder;

@end


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
// subsitute your instance in -initWithCoder and nothing else
// (you may look at the data)

@optional
- (void) decodeWithCoder:(NSCoder *) aDecoder;

// sick and tired of writing basically the same code in encodeWithCoder:
// and decodeWithCoder: ? use encodeDecodeWithCoder:
@optional
- (void) encodeDecodeWithCoder:(NSCoder *) aDecoder;

@end


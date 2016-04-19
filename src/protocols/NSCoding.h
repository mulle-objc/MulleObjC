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

@end


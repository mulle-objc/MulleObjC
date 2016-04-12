//
//  NSCopying.m
//  MulleObjC
//
//  Created by Nat! on 31.03.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSCopying.h"



@interface NSCopying < NSCopying>
@end


//
// that's what the default implementation assumes
// it should be harmless IMO
//
@interface NSCopying( NSObjectProtocolAssumed)

- (instancetype) retain;

@end


@implementation NSCopying

- (instancetype) copy
{
   return( [self retain]);
}

- (instancetype) copyWithZone:(NSZone *) zone
{
   return( [self copy]);
}

@end

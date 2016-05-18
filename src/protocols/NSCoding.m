//
//  NSCoding.m
//  MulleObjC
//
//  Created by Nat! on 14.05.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSCoding.h"

#import "NSObjectProtocol.h"


@interface NSCoding <NSCoding>
@end


@implementation NSCoding

- (Class) classForCoder
{
   return( [(id< NSObject>) self class]);
}

@end

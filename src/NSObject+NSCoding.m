//
//  NSObject+NSCoding.m
//  MulleObjC
//
//  Created by Nat! on 17.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSObject+NSCoding.h"


@implementation NSObject (NSCoding)

+ (NSInteger) version
{
   return( _mulle_objc_class_get_coderversion( self));
}


+ (void) setVersion:(NSInteger) value
{
   if( ! _mulle_objc_class_set_coderversion( self, value))
      abort();  // how likely is that ?
}


+ (Class) classForCoder
{
   return( self);
}


- (id) replacementObjectForCoder:(NSCoder *) coder
{
   return( self);
}


- (id) awakeAfterUsingCoder:(NSCoder *) decoder
{
   return( self);
}

@end

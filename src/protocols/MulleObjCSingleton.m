//
//  NSObject+MulleObjCSingleton.m
//  MulleObjC
//
//  Created by Nat! on 21.03.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "MulleObjCSingleton.h"

#import "MulleObjCAllocation.h"

#include "ns_type.h"


@interface MulleObjCSingleton < NSObject>
@end


@implementation MulleObjCSingleton

+ (instancetype) sharedInstance
{
   id< NSObject>  singleton;
   
   assert( _mulle_objc_class_get_state_bit( self, MULLE_OBJC_IS_SINGLETON));
   assert( ! _mulle_objc_class_get_state_bit( self, MULLE_OBJC_IS_CLASSCLUSTER));
   
   singleton = (id) _mulle_objc_class_get_auxplaceholder( self);
   if( ! singleton)
   {
      singleton = [[[self alloc] init] autorelease];
      [singleton becomeRootObject];
      _mulle_objc_class_get_auxplaceholder( self);
   }
   return( (id) singleton);
}

@end

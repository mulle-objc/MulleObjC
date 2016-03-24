//
//  MulleObjCClassCluster.m
//  MulleObjCFoundation
//
//  Created by Nat! on 18.03.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "MulleObjCClassCluster.h"

// other files in this library
#include "MulleObjCAllocation.h"

// std-c and dependencies

#define MulleObjCClassClusterHash    0x05202825d261fbb7  // MulleObjCClassCluster


@interface MulleObjCClassCluster
@end


@implementation MulleObjCClassCluster

+ (mulle_objc_classid_t) __classClusterPlaceholderClassid
{
   return( MULLE_OBJC_NO_CLASSID);
}


+ (id) alloc
{
   extern struct _mulle_objc_object   *MulleObjCCreatePlaceholder( struct _mulle_objc_class  *, mulle_objc_classid_t);
   
   struct _mulle_objc_object   *placeholder;
   struct _mulle_objc_class    *supercls;
   
   
   //
   // only the class marked as MulleObjCClassCluster gets the
   // placeholder, subclasses use regular alloc
   // the class being a classcluster marks itself during
   // +initialize
   //
   if( ! _mulle_objc_class_get_state_bit( self, MULLE_OBJC_IS_CLASSCLUSTER))
      return( NSAllocateObject( self, 0, NULL));
   
   assert( ! _mulle_objc_class_get_state_bit( self, MULLE_OBJC_IS_SINGLETON));
   
   placeholder = _mulle_objc_class_get_auxplaceholder( self);
   if( ! placeholder)
   {
      placeholder = MulleObjCCreatePlaceholder( self, [self __classClusterPlaceholderClassid]);
      [(id) placeholder becomePlaceholder];
      _mulle_objc_class_set_auxplaceholder( self, placeholder);
   }
   return( (id) placeholder);
}

@end

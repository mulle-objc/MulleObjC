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


@interface MulleObjCClassCluster < NSObject, MulleObjCClassCluster>
@end


@implementation MulleObjCClassCluster

//
// this gets inherited by the class, that implements the protocol
// but JUST that class
//
+ (void) initialize
{
   _mulle_objc_class_set_state_bit( self, MULLE_OBJC_IS_CLASSCLUSTER);
}


static id   MulleObjCNewClassClusterPlaceholder( struct _mulle_objc_class  *self)
{
   struct _mulle_objc_method    *method;
   id                           placeholder;
   
   placeholder = NSAllocateObject( self, 0, NULL);
   method      = _mulle_objc_class_search_method( self,
                                                  @selector( __initPlaceholder),
                                                 NULL,
                                                 _mulle_objc_class_get_inheritance( self));
   if( method)
      (*method->implementation)( placeholder, @selector( __initPlaceholder), NULL);

   return( placeholder);
}


+ (nonnull instancetype) alloc
{
   struct _mulle_objc_object   *placeholder;
   
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
      placeholder = (struct _mulle_objc_object *) MulleObjCNewClassClusterPlaceholder( self);
      _ns_add_placeholder( placeholder);
      _mulle_objc_class_set_auxplaceholder( self, placeholder);
   }
   
   // retain the placeholder
   return( [(id) placeholder retain]);
}


+ (nonnull instancetype) new
{
   return( [[self alloc] init]);
}

@end

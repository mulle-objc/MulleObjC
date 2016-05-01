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


@interface MulleObjCSingleton < NSObject, MulleObjCSingleton>
@end


@implementation MulleObjCSingleton

+ (void) initialize
{
   _mulle_objc_class_set_state_bit( self, MULLE_OBJC_IS_SINGLETON);
}



id  MulleObjCSingletonCreate( Class self)
{
   id <NSObject>  singleton;
   Class          cls;
   
   assert( ! _mulle_objc_class_get_state_bit( self, MULLE_OBJC_IS_CLASSCLUSTER));

#if 0
   for( cls = self; cls; cls = [cls superclass])
      if( _mulle_objc_class_get_state_bit( cls, MULLE_OBJC_IS_SINGLETON))
         break;
#endif

   cls = self;
   if( ! _mulle_objc_class_get_state_bit( cls, MULLE_OBJC_IS_SINGLETON))
      mulle_objc_throw_internal_inconsistency_exception( "missing MULLE_OBJC_IS_CLASSCLUSTER bit on class %p", self);
   
   singleton = (id) _mulle_objc_class_get_auxplaceholder( cls);
   if( ! singleton)
   {
      // avoid +alloc here so that subclass can "abort" on alloc if desired
      singleton = [NSAllocateObject( self, 0, NULL) init];
      _ns_add_singleton( singleton);
      _mulle_objc_class_set_auxplaceholder( cls, (void *) singleton);
   }

   return( (id) singleton);
}


//
// a subclass can be installed and, when it's sharedInstance message is called
// it will override the superclass (and be stored in the superclass) provided
// that the subclass does not declare the protocol MulleObjCSingleton again
//
+ (instancetype) sharedInstance
{
   return( MulleObjCSingletonCreate( self));
}


@end

//
//  MulleObjCTaggedPointer.m
//  MulleObjC
//
//  Created by Nat! on 11.07.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "MulleObjCTaggedPointer.h"

#include "ns_exception.h"

#include <mulle_objc/mulle_objc.h>


@interface MulleObjCTaggedPointer < MulleObjCTaggedPointer>
@end


@implementation MulleObjCTaggedPointer

- (void) dealloc
{
   abort();
}


- (id) retain
{
   return( self);
}


- (id) autorelease
{
   return( self);
}


- (void) release
{
}


- (id) copy
{
   return( self);
}



/* 
   MEMO:
 
   If the compiler doesn't produce tagged pointers. It's not a problem.
   The compiler must produce tagged pointer aware method calls, when inlining
   code.
*/
+ (BOOL) isTaggedPointerEnabled
{
   struct _mulle_objc_runtime  *runtime;
   
   runtime = _mulle_objc_class_get_runtime( self);
   return( ! runtime->config.no_tagged_pointers);
}


int   MulleObjCTaggedPointerRegisterClassAtIndex( Class cls, unsigned int index)
{
   struct _mulle_objc_runtime  *runtime;
   int                         rval;
   
   if( ! cls)
   {
      errno = EINVAL;
      return( -1);
   }
   
   runtime = _mulle_objc_class_get_runtime( cls);
   if( ! index)
      MulleObjCThrowInvalidIndexException( index);
   
   rval = _mulle_objc_runtime_set_taggedpointerclass_at_index( runtime, cls, index);
   if( ! rval)
      _mulle_objc_class_set_taggedpointerindex( cls, index);
   return( rval);
}

@end

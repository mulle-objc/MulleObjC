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
 
   If the compiler doesn't produce tagged pointer strings. It's not a problem.
   The compiler must produce tagged pointer aware method calls, when inlining
   code. Code compiled with -O0 is tagged-pointer compatible, even if not
   compiled with tagged pointers.
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
   
   runtime = _mulle_objc_class_get_runtime( cls);
   if( ! index)
      MulleObjCThrowInvalidIndexException( index);
   
   return( _mulle_objc_runtime_set_taggedpointerclass_at_index( runtime, cls, index));
}

@end

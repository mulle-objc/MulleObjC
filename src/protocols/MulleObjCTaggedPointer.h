//
//  MulleObjCTaggedPointer.h
//  MulleObjC
//
//  Created by Nat! on 11.07.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#include "ns_type.h"


@protocol MulleObjCTaggedPointer

@optional
+ (BOOL) isTaggedPointerEnabled;

@end

int  MulleObjCTaggedPointerRegisterClassAtIndex( Class cls, unsigned int index);


static inline void   *MulleObjCCreateTaggedPointerWithValueAndIndex( NSUInteger value, NSUInteger index)
{
   return( mulle_objc_create_taggedpointer( value, (unsigned int) index));
}


static inline NSUInteger  MulleObjCTaggedPointerGetValue( void *pointer)
{
   return( mulle_objc_taggedpointer_get_value( pointer));
}


static inline NSUInteger  MulleObjCTaggedPointerGetIndex( void *pointer)
{
   return( mulle_objc_taggedpointer_get_index( pointer));
}

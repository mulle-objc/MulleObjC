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


static inline int   MulleObjCTaggedPointerClassGetIndex( Class cls)
{
   if( ! cls)
   {
      errno = EINVAL;
      return( -1);
   }

   return( (int) _mulle_objc_class_get_taggedpointerindex( cls));
}


static inline BOOL   MulleObjCTaggedPointerIsIntegerValue( NSInteger value)
{
   return( (BOOL) mulle_objc_taggedpointer_is_valid_signed_value( value));
}


static inline BOOL   MulleObjCTaggedPointerIsUnsignedIntegerValue( NSUInteger value)
{
   return( (BOOL) mulle_objc_taggedpointer_is_valid_unsigned_value( value));
}


static inline void   *MulleObjCCreateTaggedPointerWithIntegerValueAndIndex( NSInteger value, NSUInteger index)
{
   return( mulle_objc_create_signed_taggedpointer( value, (unsigned int) index));
}


static inline void   *MulleObjCCreateTaggedPointerWithUnsignedIntegerValueAndIndex( NSUInteger value, NSUInteger index)
{
   return( mulle_objc_create_unsigned_taggedpointer( value, (unsigned int) index));
}


static inline NSInteger  MulleObjCTaggedPointerGetIntegerValue( void *pointer)
{
   return( mulle_objc_taggedpointer_get_signed_value( pointer));
}


static inline NSUInteger  MulleObjCTaggedPointerGetUnsignedIntegerValue( void *pointer)
{
   return( mulle_objc_taggedpointer_get_unsigned_value( pointer));
}


static inline NSUInteger  MulleObjCTaggedPointerGetIndex( void *pointer)
{
   return( mulle_objc_taggedpointer_get_index( pointer));
}

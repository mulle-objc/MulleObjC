//
//  MulleObjCTaggedPointer.h
//  MulleObjC
//
//  Copyright (c) 2016 Nat! - Mulle kybernetiK.
//  Copyright (c) 2016 Codeon GmbH.
//  All rights reserved.
//
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//
//  Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  Neither the name of Mulle kybernetiK nor the names of its contributors
//  may be used to endorse or promote products derived from this software
//  without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.
//
#import "import.h"

#import "mulle-objc-type.h"
#import "MulleObjCIntegralType.h"
#import "MulleObjCRuntimeObject.h"
#import "MulleObjCProtocol.h"


_PROTOCOLCLASS_INTERFACE( MulleObjCTaggedPointer, MulleObjCImmutable)

+ (BOOL) isTaggedPointerEnabled;

@optional
- (instancetype) retain          MULLE_OBJC_THREADSAFE_METHOD;
- (instancetype) autorelease     MULLE_OBJC_THREADSAFE_METHOD;
- (void) release                 MULLE_OBJC_THREADSAFE_METHOD;
- (NSUInteger) retainCount       MULLE_OBJC_THREADSAFE_METHOD;

PROTOCOLCLASS_END()



// -1 is error, errno tells the tale
// EINVAL: cls is nil
// ENOENT: index not available due to architecture
// will abort if another class already squats
MULLE_OBJC_GLOBAL
int  MulleObjCTaggedPointerRegisterClassAtIndex( Class cls,
                                                 unsigned int index);


MULLE_C_CONST_RETURN
static inline int   MulleObjCTaggedPointerClassGetIndex( Class cls)
{
   if( ! cls)
   {
      errno = EINVAL;
      return( -1);
   }

   return( (int) _mulle_objc_infraclass_get_taggedpointerindex( cls));
}


MULLE_C_CONST_RETURN
static inline BOOL   MulleObjCTaggedPointerIsIntegerValue( NSInteger value)
{
   return( (BOOL) mulle_objc_taggedpointer_is_valid_signed_value( value));
}


MULLE_C_CONST_RETURN
static inline BOOL
   MulleObjCTaggedPointerIsUnsignedIntegerValue( NSUInteger value)
{
   return( (BOOL) mulle_objc_taggedpointer_is_valid_unsigned_value( value));
}


MULLE_C_CONST_RETURN
static inline BOOL
   MulleObjCTaggedPointerIsFloatValue( float value)
{
   return( (BOOL) mulle_objc_taggedpointer_is_valid_float_value( value));
}


MULLE_C_CONST_RETURN
static inline BOOL
   MulleObjCTaggedPointerIsDoubleValue( double value)
{
   return( (BOOL) mulle_objc_taggedpointer_is_valid_double_value( value));
}


MULLE_C_CONST_RETURN
static inline void   *
   MulleObjCCreateTaggedPointerWithIntegerValueAndIndex( NSInteger value,
                                                         NSUInteger index)
{
   return( mulle_objc_create_signed_taggedpointer( value, (unsigned int) index));
}


MULLE_C_CONST_RETURN
static inline void   *
   MulleObjCCreateTaggedPointerWithUnsignedIntegerValueAndIndex( NSUInteger value,
                                                                 NSUInteger index)
{
   return( mulle_objc_create_unsigned_taggedpointer( value, (unsigned int) index));
}


MULLE_C_CONST_RETURN
static inline void   *
   MulleObjCCreateTaggedPointerWithFloatValueAndIndex( float value,
                                                       NSUInteger index)
{
   return( mulle_objc_create_float_taggedpointer( value, (unsigned int) index));
}


MULLE_C_CONST_RETURN
static inline void   *
   MulleObjCCreateTaggedPointerWithDoubleValueAndIndex( double value,
                                                        NSUInteger index)
{
   return( mulle_objc_create_double_taggedpointer( value, (unsigned int) index));
}



MULLE_C_CONST_RETURN
static inline NSInteger  MulleObjCTaggedPointerGetIntegerValue( void *pointer)
{
   return( mulle_objc_taggedpointer_get_signed_value( pointer));
}


MULLE_C_CONST_RETURN
static inline NSUInteger
   MulleObjCTaggedPointerGetUnsignedIntegerValue( void *pointer)
{
   return( mulle_objc_taggedpointer_get_unsigned_value( pointer));
}



MULLE_C_CONST_RETURN
static inline float  MulleObjCTaggedPointerGetFloatValue( void *pointer)
{
   return( mulle_objc_taggedpointer_get_float_value( pointer));
}


MULLE_C_CONST_RETURN
static inline double
   MulleObjCTaggedPointerGetDoubleValue( void *pointer)
{
   return( mulle_objc_taggedpointer_get_double_value( pointer));
}


MULLE_C_CONST_RETURN
static inline NSUInteger  MulleObjCTaggedPointerGetIndex( void *pointer)
{
   return( mulle_objc_taggedpointer_get_index( pointer));
}

//
//  MulleObjCFunctions.h
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
#ifndef MulleObjCFunctions_h__
#define MulleObjCFunctions_h__

#include "minimal.h"



#pragma mark - accessor shortcuts

// BOOL
static inline void   MulleObjCObjectSetBOOL( id obj, SEL sel, BOOL value)
{
   mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, (id) value);
}


static inline BOOL   MulleObjCObjectGetBOOL( id obj, SEL sel)
{
   return( (BOOL) (intptr_t) mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, obj));
}


// char
static inline void   MulleObjCObjectSetChar( id obj, SEL sel, char value)
{
   mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, (id) (intptr_t) value);
}


static inline char   MulleObjCObjectGetChar( id obj, SEL sel)
{
   return( (char) (intptr_t) mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, obj));
}


static inline void   MulleObjCObjectSetUnsignedChar( id obj, SEL sel, unsigned char value)
{
   mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, (id) (uintptr_t) value);
}


static inline unsigned char   MulleObjCObjectGetUnsignedChar( id obj, SEL sel)
{
   return( (unsigned char) (uintptr_t) mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, obj));
}


// short
static inline void   MulleObjCObjectSetShort( id obj, SEL sel, short value)
{
   mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, (id) (intptr_t) value);
}


static inline short   MulleObjCObjectGetShort( id obj, SEL sel)
{
   return( (short) (intptr_t) mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, obj));
}


static inline void   MulleObjCObjectSetUnsignedShort( id obj, SEL sel, unsigned short value)
{
   mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, (id) (uintptr_t) value);
}


static inline unsigned short   MulleObjCObjectGetUnsignedShort( id obj, SEL sel)
{
   return( (unsigned short) (uintptr_t) mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, obj));
}


// int
static inline void   MulleObjCObjectSetInt( id obj, SEL sel, int value)
{
   mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, (id) (intptr_t) value);
}


static inline int   MulleObjCObjectGetInt( id obj, SEL sel)
{
   return( (int) (intptr_t) mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, obj));
}


static inline void   MulleObjCObjectSetUnsignedInt( id obj, SEL sel, unsigned int value)
{
   mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, (id) (uintptr_t) value);
}


static inline unsigned int   MulleObjCObjectGetUnsignedInt( id obj, SEL sel)
{
   return( (unsigned int) (uintptr_t) mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, obj));
}


// long
static inline void   MulleObjCObjectSetLong( id obj, SEL sel, long value)
{
   mulle_metaabi_union_voidptr_return( struct { long a;})  param;

   if( sizeof( long) <= sizeof( intptr_t))
      mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, (id) (intptr_t) value);
   else
   {
      param.p.a = value;
      mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, (id) &param);
   }
}


static inline long   MulleObjCObjectGetLong( id obj, SEL sel)
{
   mulle_metaabi_union_voidptr_parameter( struct { long a; })  param;

   if( sizeof( long) <= sizeof( intptr_t))
      return( (long) (intptr_t) mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, obj));

   mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, (id) &param);
   return( param.r.a);
}


static inline void   MulleObjCObjectSetUnsignedLong( id obj, SEL sel, unsigned long value)
{
   mulle_metaabi_union_voidptr_return( struct { unsigned long a;})  param;

   if( sizeof( unsigned long) <= sizeof( uintptr_t))
      mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, (id) (uintptr_t) value);
   else
   {
      param.p.a = value;
      mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, (id) &param);
   }
}


static inline unsigned long   MulleObjCObjectGetUnsignedLong( id obj, SEL sel)
{
   mulle_metaabi_union_voidptr_parameter( struct { unsigned long a; })  param;

   if( sizeof( unsigned long) <= sizeof( uintptr_t))
      return( (unsigned long) (uintptr_t) mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, obj));

   mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, (id) &param);
   return( param.r.a);
}


// long long
static inline void   MulleObjCObjectSetLongLong( id obj, SEL sel, long long value)
{
   mulle_metaabi_union_voidptr_return( struct { long long a;})  param;

   if( sizeof( long long) <= sizeof( intptr_t))
      mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, (id) (intptr_t) value);
   else
   {
      param.p.a = value;
      mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, (id) &param);
   }
}


static inline long long   MulleObjCObjectGetLongLong( id obj, SEL sel)
{
   mulle_metaabi_union_voidptr_parameter( struct { long long a; })  param;

   if( sizeof( long long) <= sizeof( intptr_t))
      return( (long long) (intptr_t) mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, obj));

   mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, (id) &param);
   return( param.r.a);
}


static inline void   MulleObjCObjectSetUnsignedLongLong( id obj, SEL sel, unsigned long long value)
{
   mulle_metaabi_union_voidptr_return( struct { unsigned long long a;})  param;

   if( sizeof( unsigned long long) <= sizeof( uintptr_t))
      mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, (id) (uintptr_t) value);
   else
   {
      param.p.a = value;
      mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, (id) &param);
   }
}


static inline unsigned long long   MulleObjCObjectGetUnsignedLongLong( id obj, SEL sel)
{
   mulle_metaabi_union_voidptr_parameter( struct { unsigned long long a; })  param;

   if( sizeof( unsigned long long) <= sizeof( intptr_t))
      return( (unsigned long long) (uintptr_t) mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, obj));

   mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, (id) &param);
   return( param.r.a);
}


// NSInteger (known to be intptr_t)
static inline void   MulleObjCObjectSetNSInteger( id obj, SEL sel, NSInteger value)
{
   mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, (id) value);
}


static inline NSInteger   MulleObjCObjectGetNSInteger( id obj, SEL sel)
{
   return( (NSInteger) mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, obj));
}


// float (adhere to C promotion rules)
static inline void   MulleObjCObjectSetFloat( id obj, SEL sel, float value)
{
   mulle_metaabi_union_voidptr_return( struct { float value; })  param;

   param.p.value = value;

   mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, &param);
}


static inline float   MulleObjCObjectGetFloat( id obj, SEL sel)
{
   mulle_metaabi_union_voidptr_parameter( struct { float value; })  param;

   mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, &param);
   return( (float) param.r.value);
}


// double
static inline void   MulleObjCObjectSetDouble( id obj, SEL sel, double value)
{
   mulle_metaabi_union_voidptr_return( struct { double value; })  param;

   param.p.value = value;

  mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, &param);
}


static inline double   MulleObjCObjectGetDouble( id obj, SEL sel)
{
   mulle_metaabi_union_voidptr_parameter( struct { double value; })  param;

   mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, &param);
   return( param.r.value);
}

// long double
static inline void   MulleObjCObjectSetLongDouble( id obj, SEL sel, long double value)
{
   mulle_metaabi_union_voidptr_return( struct { long double value; })  param;

   param.p.value = value;

   mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, &param);
}


static inline double   MulleObjCObjectGetLongDouble( id obj, SEL sel)
{
   mulle_metaabi_union_voidptr_parameter( struct { long double value; })  param;

   mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, &param);
   return( param.r.value);
}


// NSRange
static inline void   MulleObjCObjectSetRange( id obj, SEL sel, NSRange value)
{
   mulle_metaabi_union_voidptr_return( struct { NSRange value; })  param;

   param.p.value = value;
   mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, &param);
}


static inline NSRange   MulleObjCObjectGetRange( id obj, SEL sel)
{
   mulle_metaabi_union_voidptr_parameter( struct { NSRange value; })  param;

   mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, &param);
   return( param.r.value);
}


#pragma mark - imp calling helpers


static inline id   MulleObjCIMPCall0( IMP imp, id obj, SEL sel)
{
   return( (id) mulle_objc_implementation_invoke( (mulle_objc_implementation_t) imp,
                                                  obj,
                                                  (mulle_objc_methodid_t) sel,
                                                  obj));
}


static inline id   MulleObjCIMPCall( IMP imp, id obj, SEL sel, id argument)
{
   return( (id) mulle_objc_implementation_invoke( (mulle_objc_implementation_t) imp,
                                                  obj,
                                                  (mulle_objc_methodid_t) sel,
                                                  argument));
}


static inline id   MulleObjCIMPCall1( IMP imp, id obj, SEL sel, id argument)
{
   return( MulleObjCIMPCall( imp, obj, sel, argument));
}


static inline id   MulleObjCIMPCall2( IMP imp, id obj, SEL sel, id a, id b)
{
   mulle_metaabi_union_voidptr_return( struct { id a; id b;})  param;

   param.p.a = a;
   param.p.b = b;

   return( (id) mulle_objc_implementation_invoke( (mulle_objc_implementation_t) imp,
                                                  obj,
                                                  (mulle_objc_methodid_t) sel,
                                                  &param));
}


static inline id   MulleObjCIMPCall3( IMP imp, id obj, SEL sel, id a, id b, id c)
{
   mulle_metaabi_union_voidptr_return( struct { id a; id b; id c;})  param;

   param.p.a = a;
   param.p.b = b;
   param.p.c = c;

   return( (id) mulle_objc_implementation_invoke( (mulle_objc_implementation_t) imp,
                                                  obj,
                                                  (mulle_objc_methodid_t) sel,
                                                  &param));
}


static inline id   MulleObjCIMPCall4( IMP imp, id obj, SEL sel, id a, id b, id c, id d)
{
   mulle_metaabi_union_voidptr_return( struct { id a; id b; id c; id d;})  param;

   param.p.a = a;
   param.p.b = b;
   param.p.c = c;
   param.p.d = d;

   return( (id) mulle_objc_implementation_invoke( (mulle_objc_implementation_t) imp,
                                                  obj,
                                                  (mulle_objc_methodid_t) sel,
                                                  &param));
}


static inline id   MulleObjCIMPCall5( IMP imp, id obj, SEL sel, id a, id b, id c, id d, id e)
{
   mulle_metaabi_union_voidptr_return( struct { id a; id b; id c; id d; id e;})  param;

   param.p.a = a;
   param.p.b = b;
   param.p.c = c;
   param.p.d = d;
   param.p.e = e;

   return( (id) mulle_objc_implementation_invoke( (mulle_objc_implementation_t) imp,
                                                  obj,
                                                  (mulle_objc_methodid_t) sel,
                                                  &param));
}



#pragma mark - KVC support (write)

static inline id
   MulleObjCIMPCallWithFloat( IMP imp, id obj, SEL sel, float argument)
{
   mulle_metaabi_union_voidptr_return( struct { float a;})  param;

   param.p.a = argument;

   return( (id) mulle_objc_implementation_invoke( (mulle_objc_implementation_t) imp,
                                                  obj,
                                                  (mulle_objc_methodid_t) sel,
                                                  &param));
}


static inline id
   MulleObjCIMPCallWithDouble( IMP imp, id obj, SEL sel, double argument)
{
   mulle_metaabi_union_voidptr_return( struct { double a;})  param;

   param.p.a = argument;

   return( (id) mulle_objc_implementation_invoke( (mulle_objc_implementation_t) imp,
                                                  obj,
                                                  (mulle_objc_methodid_t) sel,
                                                  &param));
}


static inline id
   MulleObjCIMPCallWithLongDouble( IMP imp, id obj, SEL sel, long double argument)
{
   mulle_metaabi_union_voidptr_return( struct { long double a;})  param;

   param.p.a = argument;

   return( (id) mulle_objc_implementation_invoke( (mulle_objc_implementation_t) imp,
                                                  obj,
                                                  (mulle_objc_methodid_t) sel,
                                                  &param));
}


static inline id
   MulleObjCIMPCallWithLong( IMP imp, id obj, SEL sel, long argument)
{
   mulle_metaabi_union_voidptr_return( struct { long a;})  param;

   if( sizeof( long) <= sizeof( void *))
      return( MulleObjCIMPCall( imp, obj, sel, (void *) (intptr_t) argument));

   param.p.a = argument;

   return( (id) mulle_objc_implementation_invoke( (mulle_objc_implementation_t) imp,
                                                  obj,
                                                  (mulle_objc_methodid_t) sel,
                                                  &param));
}


static inline id
   MulleObjCIMPCallWithUnsignedLong( IMP imp, id obj, SEL sel, unsigned long argument)
{
   mulle_metaabi_union_voidptr_return( struct { unsigned long a;})  param;

   if( sizeof( unsigned long) <= sizeof( void *))
      return( MulleObjCIMPCall( imp, obj, sel, (void *) (intptr_t) argument));

   param.p.a = argument;

   return( (id) mulle_objc_implementation_invoke( (mulle_objc_implementation_t) imp,
                                                  obj,
                                                  (mulle_objc_methodid_t) sel,
                                                  &param));
}


static inline id
   MulleObjCIMPCallWithLongLong( IMP imp, id obj, SEL sel, long long argument)
{
   mulle_metaabi_union_voidptr_return( struct { long long a;})  param;

   if( sizeof( long long) <= sizeof( void *))
      return( MulleObjCIMPCall( imp, obj, sel, (void *) (intptr_t) argument));

   param.p.a = argument;

   return( (id) mulle_objc_implementation_invoke( (mulle_objc_implementation_t) imp,
                                                  obj,
                                                  (mulle_objc_methodid_t) sel,
                                                  &param));
}


static inline id
   MulleObjCIMPCallWithUnsignedLongLong( IMP imp,
                                         id obj,
                                         SEL sel,
                                         unsigned long long argument)
{
   mulle_metaabi_union_voidptr_return( struct { unsigned long long a;})  param;

   if( sizeof( unsigned long long) <= sizeof( void *))
      return( MulleObjCIMPCall( imp, obj, sel, (void *) (intptr_t) argument));

   param.p.a = argument;

   return( (id) mulle_objc_implementation_invoke( (mulle_objc_implementation_t) imp,
                                                  obj,
                                                  (mulle_objc_methodid_t) sel,
                                                  &param));
}


#pragma mark - KVC support (read)

static inline float   MulleObjCIMPCall0ReturningFloat( IMP imp, id obj, SEL sel)
{
   mulle_metaabi_union_void_parameter( struct { float a;})  param;

   mulle_objc_implementation_invoke( (mulle_objc_implementation_t) imp,
                                     obj,
                                     (mulle_objc_methodid_t) sel,
                                     &param);
   return( param.r.a);
}


static inline double
   MulleObjCIMPCall0ReturningDouble( IMP imp, id obj, SEL sel)
{
   mulle_metaabi_union_void_parameter( struct { double a;})  param;

   mulle_objc_implementation_invoke( (mulle_objc_implementation_t) imp,
                                     obj,
                                     (mulle_objc_methodid_t) sel,
                                     &param);
   return( param.r.a);
}


static inline long double
   MulleObjCIMPCall0ReturningLongDouble( IMP imp, id obj, SEL sel)
{
   mulle_metaabi_union_void_parameter( struct { long double a;})  param;

   mulle_objc_implementation_invoke( (mulle_objc_implementation_t) imp,
                                     obj,
                                     (mulle_objc_methodid_t) sel,
                                     &param);
   return( param.r.a);
}


static inline long   MulleObjCIMPCall0ReturningLong( IMP imp, id obj, SEL sel)
{
   mulle_metaabi_union_void_parameter( struct { long a;})  param;

   if( sizeof( long) <= sizeof( void *))
      return( (long) MulleObjCIMPCall0( imp, obj, sel));

   mulle_objc_implementation_invoke( (mulle_objc_implementation_t) imp,
                                     obj,
                                     (mulle_objc_methodid_t) sel,
                                     &param);
   return( param.r.a);
}


static inline unsigned long
   MulleObjCIMPCall0ReturningUnsignedLong( IMP imp, id obj, SEL sel)
{
   mulle_metaabi_union_void_parameter( struct { unsigned long a;})  param;

   if( sizeof( unsigned long) <= sizeof( void *))
      return( (unsigned long) MulleObjCIMPCall0( imp, obj, sel));

   mulle_objc_implementation_invoke( (mulle_objc_implementation_t) imp,
                                     obj,
                                     (mulle_objc_methodid_t) sel,
                                     &param);
   return( param.r.a);
}


static inline long long
   MulleObjCIMPCall0ReturningLongLong( IMP imp, id obj, SEL sel)
{
   mulle_metaabi_union_void_parameter( struct { long long a;})  param;

   if( sizeof( long long) <= sizeof( void *))
      return( (long long ) MulleObjCIMPCall0( imp, obj, sel));

   mulle_objc_implementation_invoke( (mulle_objc_implementation_t) imp,
                                     obj,
                                     (mulle_objc_methodid_t) sel,
                                     &param);
   return( param.r.a);
}


static inline unsigned long long
   MulleObjCIMPCall0ReturningUnsignedLongLong( IMP imp, id obj, SEL sel)
{
   mulle_metaabi_union_void_parameter( struct { unsigned long long a;})  param;

   if( sizeof( unsigned long long) <= sizeof( void *))
      return( (unsigned long long ) MulleObjCIMPCall0( imp, obj, sel));


   mulle_objc_implementation_invoke( (mulle_objc_implementation_t) imp,
                                     obj,
                                     (mulle_objc_methodid_t) sel,
                                     &param);
   return( param.r.a);
}


#pragma mark - find overriden or specific methods

//
// slow search routines
// overridden will probably gain it's own keyword
//
MULLE_OBJC_GLOBAL
IMP   MulleObjCObjectSearchSuperIMP( id obj,
                                     SEL sel,
                                     mulle_objc_classid_t classid);

MULLE_OBJC_GLOBAL
IMP   MulleObjCObjectSearchSpecificIMP( id obj,
                                        SEL sel,
                                        mulle_objc_classid_t classid,
                                        mulle_objc_categoryid_t categoryid);

MULLE_OBJC_GLOBAL
IMP   MulleObjCObjectSearchOverriddenIMP( id obj,
                                          SEL sel,
                                          mulle_objc_classid_t classid,
                                          mulle_objc_categoryid_t categoryid);

MULLE_OBJC_GLOBAL
IMP   MulleObjCObjectSearchClobberedIMP( id obj,
                                         SEL sel,
                                         mulle_objc_classid_t classid,
                                         mulle_objc_categoryid_t categoryid);
//
// If called from -bar in Foo(A) this will find the IMP -bar of Foo.
// Unless it doesn't exist.
// Or unless there is an intervening category Foo(B), which its own -bar,
// then you get the IMP for -bar of Foo(B). If there is no implementation of
// -bar in Foo or its categories, you will get 0 back!
// e.g. Foo : NSObject, if you search for -autorelease and Foo doesn't
// implement it but NSObject does, then you get 0.
//
#define MulleObjCClobberedIMP \
   MulleObjCObjectSearchClobberedIMP( (self), (_cmd), __MULLE_OBJC_CLASSID__, __MULLE_OBJC_CATEGORYID__)

//
// With this you can trace chain back through all overridden implementations.
//
#define MulleObjCOverriddenIMP \
   MulleObjCObjectSearchOverriddenIMP( (self), (_cmd), __MULLE_OBJC_CLASSID__, __MULLE_OBJC_CATEGORYID__)

// avoid this, it's very slow
#define MulleObjCSuperIMP \
    MulleObjCObjectSearchSuperIMP( (self), (_cmd), __MULLE_OBJC_CLASSID__)

#define MulleObjCClassCategoryIMP( class, category) \
    MulleObjCObjectSearchSpecificIMP( (self), (_cmd), MULLE_OBJC_MAKE_CLASSID( class), MULLE_OBJC_MAKE_CATEGORYID( category))

#define MulleObjCClassIMP( class) \
    MulleObjCObjectSearchSpecificIMP( (self), (_cmd), MULLE_OBJC_MAKE_CLASSID( class), MULLE_OBJC_NO_CATEGORYID)


// always returns number of IMPs found, the first 'n',
MULLE_OBJC_GLOBAL
unsigned int   _mulle_objc_class_search_clobber_chain( struct _mulle_objc_class *cls,
                                                       SEL sel,
                                                       IMP *array,
                                                       unsigned int n);


static inline unsigned int
   _MulleObjCClassSearchInstanceClobberChain( Class self,
                                              SEL sel,
                                              IMP *array,
                                              unsigned int n)
{
   return( _mulle_objc_class_search_clobber_chain( _mulle_objc_infraclass_as_class( self),
                                                   sel,
                                                   array,
                                                   n));
}


static inline unsigned int   _MulleObjCClassSearchClobberChain( Class self,
                                                                SEL sel,
                                                                IMP *array,
                                                                unsigned int n)
{
   struct _mulle_objc_metaclass   *meta;

   meta = _mulle_objc_infraclass_get_metaclass( self);
   return( _mulle_objc_class_search_clobber_chain( _mulle_objc_metaclass_as_class( meta),
                                                   sel,
                                                   array,
                                                   n));
}


static inline unsigned int
   MulleObjCObjectSearchClobberChain( id obj,
                                      SEL sel,
                                      IMP *array,
                                      unsigned int n)
{
   struct _mulle_objc_class   *cls;

   if( ! obj)
      return( 0);

   cls = _mulle_objc_object_get_isa( obj);
   return( _mulle_objc_class_search_clobber_chain( cls, sel, array, n));
}


#pragma mark - message sending helper

static inline id   MulleObjCObjectPerformSelector0( id obj, SEL sel)
{
   return( (id) mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, obj));
}


// just for completeness
static inline id   MulleObjCObjectPerformSelector1( id obj, SEL sel, id argument)
{
   return( (id) mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, argument));
}


static inline id   MulleObjCObjectPerformSelector( id obj, SEL sel, id argument)
{
   return( (id) mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, argument));
}


static inline id   MulleObjCObjectPerformSelectorDoubleArgument( id obj, SEL sel, double a)
{
   mulle_metaabi_union_voidptr_return( struct { double a; })  param;

   param.p.a = a;

   return( mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, &param));
}


static inline id   MulleObjCObjectPerformSelectorDoubleArgument2( id obj, SEL sel, double a, double b)
{
   mulle_metaabi_union_voidptr_return( struct { double a; double b; })  param;

   param.p.a = a;
   param.p.b = b;

   return( mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, &param));
}


static inline id   MulleObjCObjectPerformSelectorDoubleArgument3( id obj, SEL sel, double a, double b, double c)
{
   mulle_metaabi_union_voidptr_return( struct { double a; double b; double c; })  param;

   param.p.a = a;
   param.p.b = b;
   param.p.c = c;

   return( mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, &param));
}


static inline id   MulleObjCObjectPerformSelectorDoubleArgument4( id obj, SEL sel, double a, double b, double c, double d)
{
   mulle_metaabi_union_voidptr_return( struct { double a; double b; double c; double d; })  param;

   param.p.a = a;
   param.p.b = b;
   param.p.c = c;
   param.p.d = d;

   return( mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, &param));
}



static inline void   MulleObjCMakeObjectsPerformSelector0( id *objects, NSUInteger n, SEL sel)
{
   mulle_objc_objects_call( (void **) objects, (unsigned int) n, (mulle_objc_methodid_t) sel, NULL);
}


static inline void   MulleObjCMakeObjectsPerformSelector( id *objects, NSUInteger n, SEL sel, id a)
{
   mulle_objc_objects_call( (void **) objects, (unsigned int) n, (mulle_objc_methodid_t) sel, a);
}


static inline id   MulleObjCObjectPerformSelector2( id obj, SEL sel, id a, id b)
{
   mulle_metaabi_union_voidptr_return( struct { id a; id b; })  param;

   param.p.a = a;
   param.p.b = b;

   return( mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, &param));
}


static inline id   MulleObjCObjectPerformSelector3( id obj, SEL sel, id a, id b, id c)
{
   mulle_metaabi_union_voidptr_return( struct { id a; id b; id c; })  param;

   param.p.a = a;
   param.p.b = b;
   param.p.c = c;

   return( mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, &param));
}


static inline id   MulleObjCObjectPerformSelector4( id obj, SEL sel, id a, id b, id c, id d)
{
   mulle_metaabi_union_voidptr_return( struct { id a; id b; id c; id d; })  param;

   param.p.a = a;
   param.p.b = b;
   param.p.c = c;
   param.p.d = d;

   return( mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, &param));
}


static inline id   MulleObjCObjectPerformSelector5( id obj, SEL sel, id a, id b, id c, id d, id e)
{
   mulle_metaabi_union_voidptr_return( struct { id a; id b; id c; id d; id e; })  param;

   param.p.a = a;
   param.p.b = b;
   param.p.c = c;
   param.p.d = d;
   param.p.e = e;

   return( mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, &param));
}


static inline BOOL   MulleObjCObjectPerformSelector0ReturningBOOL( id obj, SEL sel)
{
   return( (BOOL) (intptr_t) mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, obj));
}


static inline BOOL   MulleObjCObjectPerformSelectorReturningBOOL( id obj, SEL sel, id argument)
{
   return(  (BOOL) (intptr_t) mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, argument));
}


MULLE_OBJC_GLOBAL
void    MulleObjCMakeObjectsPerformSelector2( id *objects, NSUInteger n, SEL sel, id argument, id argument2);

MULLE_OBJC_GLOBAL
void    MulleObjCMakeObjectsPerformRetain( id *objects, NSUInteger n);

MULLE_OBJC_GLOBAL
void    MulleObjCMakeObjectsPerformRelease( id *objects, NSUInteger n);



/*
 * Spamming a method means calling a method on each category or protocolclass
 * and class along the inheritance chain. This sounds like a good idea to
 * get category initializers and deinitializers going, but things get tricky
 * when you subclass...
 */
struct MulleObjCCollectionInfo
{
   Class          stopClass;
   SEL            selector;
   unsigned int   inheritance;
};


//
// If you leave stopClass as Nil, that's fine.
// Leave inheritance 0 for default inheritance
//
static inline struct MulleObjCCollectionInfo
   MulleObjCCollectionInfoMake( Class stopClass,
                                SEL sel,
                                unsigned int inheritance)
{
   return( (struct MulleObjCCollectionInfo)
   {
      .stopClass   = stopClass,
      .selector    = sel,
      .inheritance = inheritance,
   });
}


static inline struct MulleObjCCollectionInfo
   MulleObjCCollectionInfoMakeCategories( Class cls, SEL sel)
{
   return( (struct MulleObjCCollectionInfo)
   {
      .stopClass   = cls,
      .selector    = sel,
      .inheritance = MULLE_OBJC_CLASS_DONT_INHERIT_PROTOCOLS
                     | MULLE_OBJC_CLASS_DONT_INHERIT_CLASS,
   });
}


MULLE_OBJC_GLOBAL
void   MulleObjCClassCollectImplementations( Class startClass,
                                             struct MulleObjCCollectionInfo *info,
                                             struct mulle_pointerarray *array);



struct MulleObjCIMPArray
{
   struct mulle_pointerarray   imps;
   SEL                         selector;
};


//
// Collected IMPs will be in override order, back to front
//
MULLE_OBJC_GLOBAL
void   MulleObjCIMPArrayInit( struct MulleObjCIMPArray *imps, 
                              Class cls, 
                              Class stopCls, 
                              SEL sel, 
                              unsigned int flags,
                              struct mulle_allocator *allocator);

static inline void 
   MulleObjCIMPArrayInitCategoryOnly( struct MulleObjCIMPArray *imps, 
                                      Class cls, 
                                      SEL sel, 
                                      struct mulle_allocator *allocator)
{
   unsigned int   categories_only;

   categories_only = MULLE_OBJC_CLASS_DONT_INHERIT_PROTOCOLS
                     | MULLE_OBJC_CLASS_DONT_INHERIT_CLASS
                     | MULLE_OBJC_CLASS_DONT_INHERIT_SUPERCLASS
                     | MULLE_OBJC_CLASS_DONT_INHERIT_SUPERCLASS_INHERITANCE;
   MulleObjCIMPArrayInit( imps, cls, Nil, sel, categories_only, allocator);
}


static inline void   MulleObjCIMPArrayDone( struct MulleObjCIMPArray *imps)
{
   mulle_pointerarray_done( &imps->imps);
}


// Collected IMPs will be in override order, but for -init, we'd want to call
// those that are obscured first
static inline void   MulleObjCIMPArrayCallReverse( struct MulleObjCIMPArray *imps, id obj, id argument)
{
   IMP   imp;

   mulle_pointerarray_for_reverse( &imps->imps, imp)
   {
      MulleObjCIMPCall( imp, obj, imps->selector, argument);
   }
}


// conversely this would be good for `-dealloc`
static inline void   MulleObjCIMPArrayCall( struct MulleObjCIMPArray *imps, id obj, id argument)
{
   IMP   imp;

   mulle_pointerarray_for( &imps->imps, imp)
   {
      MulleObjCIMPCall( imp, obj, imps->selector, argument);
   }
}


#include <mulle-objc-runtime/mulle-objc-runtime.h>
#include <stdbool.h>

/*
 * Checks if a method is implemented directly on a class (including categories)
 * but not inherited from any superclass or protocol.
 *
 * @param cls The class to check
 * @param sel The selector of the method to check
 * @return true if the method is directly implemented on the class, false otherwise
 */
static inline BOOL   MulleObjCClassImplementsSelector( Class aClass, SEL sel)
{
   struct _mulle_objc_class             *cls = (struct _mulle_objc_class *) aClass;
   struct _mulle_objc_method            *method;
   struct _mulle_objc_searchresult      result = { 0 };
   struct _mulle_objc_searcharguments   search;
   unsigned int                         inheritance;
   if ( ! cls || ! sel)
     return( 0);

    // Setup search arguments
   search = mulle_objc_searcharguments_make_default( (mulle_objc_methodid_t) sel);

    // Configure inheritance flags to only search in the class itself and its categories
   inheritance = MULLE_OBJC_CLASS_DONT_INHERIT_SUPERCLASS |
                 MULLE_OBJC_CLASS_DONT_INHERIT_PROTOCOLS |
                 MULLE_OBJC_CLASS_DONT_INHERIT_PROTOCOL_CATEGORIES |
                 MULLE_OBJC_CLASS_DONT_INHERIT_PROTOCOL_META;

    // Search for the method with these constraints
    method = mulle_objc_class_search_method( cls, &search, inheritance, &result);
    return( method != NULL);
}


/*
 *
 */
static inline Class   MulleObjCObjectGetClass( id obj)
{
   return( obj ? (Class) _mulle_objc_object_get_isa( obj) : Nil);
}


// common expectation to have this available as well
static inline Class   MulleObjCInstanceGetClass( id obj)
{
   return( MulleObjCObjectGetClass( obj));
}



MULLE_OBJC_GLOBAL
void    MulleObjCInstanceSetClass( id obj, Class cls);


//
// only cheatin' strings should use this
// this must be used in init and nowhere else, as it is
// not atomic
//
static inline void    MulleObjCInstanceSetThreadAffinity( id obj, mulle_thread_t thread)
{
   if( obj)
      _mulle_objc_object_set_thread( (struct _mulle_objc_object *) obj, thread);
}



//
// only cheatin' strings should use this
// this must be used in init and nowhere else, as it is
// not atomic
//
static inline void   MulleObjCInstanceConstantify( id obj)
{
   if( obj)
   {
      assert( MulleObjCObjectIsInstance( obj));
      _mulle_objc_object_constantify_noatomic( obj);
   }
}


static inline Class   NSClassFromObject( id object)
{
   return( MulleObjCObjectGetClass( object));
}


MULLE_OBJC_GLOBAL
char    *MulleObjCClassGetNameUTF8String( Class cls);

static inline char   *MulleObjCClassUTF8String( Class cls)
{
   return( MulleObjCClassGetNameUTF8String( cls));
}


MULLE_OBJC_GLOBAL
char    *MulleObjCSelectorGetNameUTF8String( SEL sel);


static inline char   *MulleObjCSelectorUTF8String( SEL sel)
{
   return( MulleObjCSelectorGetNameUTF8String( sel));
}


MULLE_OBJC_GLOBAL
char    *MulleObjCProtocolGetNameUTF8String( PROTOCOL sel);


static inline char   *MulleObjCProtocolUTF8String( SEL sel)
{
   return( MulleObjCProtocolGetNameUTF8String( sel));
}


MULLE_OBJC_GLOBAL
Class   MulleObjCLookupClassByNameUTF8String( char *name);


static inline SEL   MulleObjCClassGetID( Class cls)
{
   return( cls ? _mulle_objc_infraclass_get_classid( cls) : (SEL) 0);
}


MULLE_OBJC_GLOBAL
Class   MulleObjCLookupClassByClassID( SEL classid);

//MEMO:
// you don't need to lookup protocols or selector, just use @protocol()
// and @selector

MULLE_OBJC_GLOBAL
SEL     MulleObjCCreateSelectorUTF8String( char *name);


MULLE_OBJC_GLOBAL
char   *MulleObjCObjectGetClassNameUTF8String( id obj);


static inline 
char  *MulleObjCInstanceGetClassNameUTF8String( id obj)
{
   assert( MulleObjCObjectIsInstanceOrNil( obj));

   return( MulleObjCObjectGetClassNameUTF8String( obj));
}


static inline void   *MulleObjCInstanceGetExtraBytes( id obj)
{
   assert( MulleObjCObjectIsInstanceOrNil( obj));

   return( obj ? _mulle_objc_object_get_extra( obj) : NULL);
}


// find the address of the structure that defined this class
MULLE_OBJC_GLOBAL
void  *MulleObjCClassGetLoadAddress( Class cls);


//
// In your +load methods, if you cache the class for use in C functions
// you must ensure, that the class is already properly loaded and
// initialized (this will trigger +initialize). You could also
// "just" call [self class]
//
//static void   MulleObjCClassTouch( Class cls)
//{
//   struct _mulle_objc_class  *p;

//   p = _mulle_objc_infraclass_as_class( cls);
//   _mulle_objc_class_setup( p);
//}

static inline struct _mulle_objc_property  *MulleObjCClassSearchProperty( Class cls,
                                                                          SEL propertyid)
{
   if( ! cls)
      return( NULL);

   assert( _mulle_objc_class_is_infraclass( (void *) cls));
   return( _mulle_objc_infraclass_search_property( (struct _mulle_objc_infraclass *) cls,
                                                   (mulle_objc_propertyid_t) propertyid));
}


static inline struct _mulle_objc_property  *MulleObjCInstanceSearchProperty( id obj,
                                                                             SEL propertyid)
{
   struct _mulle_objc_infraclass   *infra;

   assert( MulleObjCObjectIsInstanceOrNil( obj));

   if( ! obj)
      return( NULL);

   infra = (struct _mulle_objc_infraclass *) _mulle_objc_object_get_isa( obj);
   assert( _mulle_objc_class_is_infraclass( (void *) infra));
   return( _mulle_objc_infraclass_search_property( infra,
                                                   (mulle_objc_propertyid_t) propertyid));
}



MULLE_OBJC_GLOBAL
char    *MulleObjCGetSizeAndAlignment( char *type, NSUInteger *size, NSUInteger *alignment);

static inline char    *NSGetSizeAndAlignment( char *type, NSUInteger *size, NSUInteger *alignment)
{
   return( MulleObjCGetSizeAndAlignment( type, size, alignment));
}



// fill buffer with description of memory, that is defined by type which
// is an @encode() string.
//
// example: 
//    double a[ 3] = { 0, 1, 2 };
//    MulleObjCDescribeMemory( buffer, mulle_data_make( a, sizeof( a)), @encode( a));
//
BOOL  MulleObjCDescribeMemory( struct mulle_buffer *buffer, 
                               struct mulle_data data,
                               char *type);

// dump known instance variables of an object
void  MulleObjCDescribeIvars( struct mulle_buffer *buffer, id obj);


#endif

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

#include "minimal.h"


char    *NSGetSizeAndAlignment( char *type, NSUInteger *size, NSUInteger *alignment);


#pragma mark - accessor shortcuts

// BOOL
static inline void   MulleObjCObjectSetBOOL( id obj, SEL sel, BOOL value)
{
   mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, (id) value);
}


static inline BOOL   MulleObjCObjectGetBOOL( id obj, SEL sel)
{
   return( (BOOL) mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, obj));
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
   mulle_objc_metaabi_param_block_voidptr_return( struct { long a;})  param;

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
   mulle_objc_metaabi_param_block_voidptr_parameter( struct { long a; })  param;

   if( sizeof( long) <= sizeof( intptr_t))
      return( (long) (intptr_t) mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, obj));

   mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, (id) &param);
   return( param.r.a);
}


static inline void   MulleObjCObjectSetUnsignedLong( id obj, SEL sel, unsigned long value)
{
   mulle_objc_metaabi_param_block_voidptr_return( struct { unsigned long a;})  param;

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
   mulle_objc_metaabi_param_block_voidptr_parameter( struct { unsigned long a; })  param;

   if( sizeof( unsigned long) <= sizeof( uintptr_t))
      return( (unsigned long) (uintptr_t) mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, obj));

   mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, (id) &param);
   return( param.r.a);
}


// long long
static inline void   MulleObjCObjectSetLongLong( id obj, SEL sel, long long value)
{
   mulle_objc_metaabi_param_block_voidptr_return( struct { long long a;})  param;

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
   mulle_objc_metaabi_param_block_voidptr_parameter( struct { long long a; })  param;

   if( sizeof( long long) <= sizeof( intptr_t))
      return( (long long) (intptr_t) mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, obj));

   mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, (id) &param);
   return( param.r.a);
}


static inline void   MulleObjCObjectSetUnsignedLongLong( id obj, SEL sel, unsigned long long value)
{
   mulle_objc_metaabi_param_block_voidptr_return( struct { unsigned long long a;})  param;

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
   mulle_objc_metaabi_param_block_voidptr_parameter( struct { unsigned long long a; })  param;

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
   mulle_objc_metaabi_param_block_voidptr_return( struct { float value; })  param;

   param.p.value = value;

   mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, &param);
}


static inline float   MulleObjCObjectGetFloat( id obj, SEL sel)
{
   mulle_objc_metaabi_param_block_voidptr_parameter( struct { float value; })  param;

   mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, &param);
   return( (float) param.r.value);
}


// double
static inline void   MulleObjCObjectSetDouble( id obj, SEL sel, double value)
{
   mulle_objc_metaabi_param_block_voidptr_return( struct { double value; })  param;

   param.p.value = value;

  mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, &param);
}


static inline double   MulleObjCObjectGetDouble( id obj, SEL sel)
{
   mulle_objc_metaabi_param_block_voidptr_parameter( struct { double value; })  param;

   mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, &param);
   return( param.r.value);
}

// long double
static inline void   MulleObjCObjectSetLongDouble( id obj, SEL sel, long double value)
{
   mulle_objc_metaabi_param_block_voidptr_return( struct { long double value; })  param;

   param.p.value = value;

   mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, &param);
}


static inline double   MulleObjCObjectGetLongDouble( id obj, SEL sel)
{
   mulle_objc_metaabi_param_block_voidptr_parameter( struct { long double value; })  param;

   mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, &param);
   return( param.r.value);
}


// NSRange
static inline void   MulleObjCObjectSetRange( id obj, SEL sel, NSRange value)
{
   mulle_objc_metaabi_param_block_voidptr_return( struct { NSRange value; })  param;

   param.p.value = value;
   mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, &param);
}


static inline NSRange   MulleObjCObjectGetRange( id obj, SEL sel)
{
   mulle_objc_metaabi_param_block_voidptr_parameter( struct { NSRange value; })  param;

   mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, &param);
   return( param.r.value);
}



#pragma mark - imp calling helpers


static inline id   MulleObjCIMPCall0( IMP imp, id obj, SEL sel)
{
   return( (id) (*imp)( obj, (mulle_objc_methodid_t) sel, obj));
}


static inline id   MulleObjCIMPCall( IMP imp, id obj, SEL sel, id argument)
{
   return( (id) (*imp)( obj, (mulle_objc_methodid_t) sel, argument));
}


static inline id   MulleObjCIMPCall2( IMP imp, id obj, SEL sel, id a, id b)
{
   mulle_objc_metaabi_param_block_voidptr_return( struct { id a; id b;})  param;

   param.p.a = a;
   param.p.b = b;

   return( (id) (*imp)( obj, (mulle_objc_methodid_t) sel, &param));
}

static inline id   MulleObjCIMPCall3( IMP imp, id obj, SEL sel, id a, id b, id c)
{
   mulle_objc_metaabi_param_block_voidptr_return( struct { id a; id b; id c;})  param;

   param.p.a = a;
   param.p.b = b;
   param.p.c = c;

   return( (id) (*imp)( obj, (mulle_objc_methodid_t) sel, &param));
}

static inline id   MulleObjCIMPCall4( IMP imp, id obj, SEL sel, id a, id b, id c, id d)
{
   mulle_objc_metaabi_param_block_voidptr_return( struct { id a; id b; id c; id d;})  param;

   param.p.a = a;
   param.p.b = b;
   param.p.c = c;
   param.p.d = d;

   return( (id) (*imp)( obj, (mulle_objc_methodid_t) sel, &param));
}

static inline id   MulleObjCIMPCall5( IMP imp, id obj, SEL sel, id a, id b, id c, id d, id e)
{
   mulle_objc_metaabi_param_block_voidptr_return( struct { id a; id b; id c; id d; id e;})  param;

   param.p.a = a;
   param.p.b = b;
   param.p.c = c;
   param.p.d = d;
   param.p.e = e;

   return( (id) (*imp)( obj, (mulle_objc_methodid_t) sel, &param));
}



#pragma mark - KVC support (write)

static inline id
   MulleObjCIMPCallWithFloat( IMP imp, id obj, SEL sel, float argument)
{
   mulle_objc_metaabi_param_block_voidptr_return( struct { float a;})  param;

   param.p.a = argument;

   return( (id) (*imp)( obj, (mulle_objc_methodid_t) sel, &param));
}


static inline id
   MulleObjCIMPCallWithDouble( IMP imp, id obj, SEL sel, double argument)
{
   mulle_objc_metaabi_param_block_voidptr_return( struct { double a;})  param;

   param.p.a = argument;

   return( (id) (*imp)( obj, (mulle_objc_methodid_t) sel, &param));
}


static inline id
   MulleObjCIMPCallWithLongDouble( IMP imp, id obj, SEL sel, long double argument)
{
   mulle_objc_metaabi_param_block_voidptr_return( struct { long double a;})  param;

   param.p.a = argument;

   return( (id) (*imp)( obj, (mulle_objc_methodid_t) sel, &param));
}


static inline id
   MulleObjCIMPCallWithLong( IMP imp, id obj, SEL sel, long argument)
{
   mulle_objc_metaabi_param_block_voidptr_return( struct { long a;})  param;

   if( sizeof( long) <= sizeof( void *))
      return( MulleObjCIMPCall( imp, obj, sel, (void *) (intptr_t) argument));

   param.p.a = argument;

   return( (id) (*imp)( obj, (mulle_objc_methodid_t) sel, &param));
}


static inline id
   MulleObjCIMPCallWithUnsignedLong( IMP imp, id obj, SEL sel, unsigned long argument)
{
   mulle_objc_metaabi_param_block_voidptr_return( struct { unsigned long a;})  param;

   if( sizeof( unsigned long) <= sizeof( void *))
      return( MulleObjCIMPCall( imp, obj, sel, (void *) (intptr_t) argument));

   param.p.a = argument;

   return( (id) (*imp)( obj, (mulle_objc_methodid_t) sel, &param));
}


static inline id
   MulleObjCIMPCallWithLongLong( IMP imp, id obj, SEL sel, long long argument)
{
   mulle_objc_metaabi_param_block_voidptr_return( struct { long long a;})  param;

   if( sizeof( long long) <= sizeof( void *))
      return( MulleObjCIMPCall( imp, obj, sel, (void *) (intptr_t) argument));

   param.p.a = argument;

   return( (id) (*imp)( obj, (mulle_objc_methodid_t) sel, &param));
}


static inline id
   MulleObjCIMPCallWithUnsignedLongLong( IMP imp,
                                         id obj,
                                         SEL sel,
                                         unsigned long long argument)
{
   mulle_objc_metaabi_param_block_voidptr_return( struct { unsigned long long a;})  param;

   if( sizeof( unsigned long long) <= sizeof( void *))
      return( MulleObjCIMPCall( imp, obj, sel, (void *) (intptr_t) argument));

   param.p.a = argument;

   return( (id) (*imp)( obj, (mulle_objc_methodid_t) sel, &param));
}

#pragma mark - KVC support (read)

static inline float   MulleObjCIMPCall0ReturningFloat( IMP imp, id obj, SEL sel)
{
   mulle_objc_metaabi_param_block_void_parameter( struct { float a;})  param;

   (*imp)( obj, (mulle_objc_methodid_t) sel, &param);
   return( param.r.a);
}


static inline double
   MulleObjCIMPCall0ReturningDouble( IMP imp, id obj, SEL sel)
{
   mulle_objc_metaabi_param_block_void_parameter( struct { double a;})  param;

   (*imp)( obj, (mulle_objc_methodid_t) sel, &param);
   return( param.r.a);
}


static inline long double
   MulleObjCIMPCall0ReturningLongDouble( IMP imp, id obj, SEL sel)
{
   mulle_objc_metaabi_param_block_void_parameter( struct { long double a;})  param;

   (*imp)( obj, (mulle_objc_methodid_t) sel, &param);
   return( param.r.a);
}


static inline long   MulleObjCIMPCall0ReturningLong( IMP imp, id obj, SEL sel)
{
   mulle_objc_metaabi_param_block_void_parameter( struct { long a;})  param;

   if( sizeof( long) <= sizeof( void *))
      return( (long) MulleObjCIMPCall0( imp, obj, sel));

   (*imp)( obj, (mulle_objc_methodid_t) sel, &param);
   return( param.r.a);
}


static inline unsigned long
   MulleObjCIMPCall0ReturningUnsignedLong( IMP imp, id obj, SEL sel)
{
   mulle_objc_metaabi_param_block_void_parameter( struct { unsigned long a;})  param;

   if( sizeof( unsigned long) <= sizeof( void *))
      return( (unsigned long) MulleObjCIMPCall0( imp, obj, sel));

   (*imp)( obj, (mulle_objc_methodid_t) sel, &param);
   return( param.r.a);
}


static inline long long
   MulleObjCIMPCall0ReturningLongLong( IMP imp, id obj, SEL sel)
{
   mulle_objc_metaabi_param_block_void_parameter( struct { long long a;})  param;

   if( sizeof( long long) <= sizeof( void *))
      return( (long long ) MulleObjCIMPCall0( imp, obj, sel));

   (*imp)( obj, (mulle_objc_methodid_t) sel, &param);
   return( param.r.a);
}


static inline unsigned long long
   MulleObjCIMPCall0ReturningUnsignedLongLong( IMP imp, id obj, SEL sel)
{
   mulle_objc_metaabi_param_block_void_parameter( struct { unsigned long long a;})  param;

   if( sizeof( unsigned long long) <= sizeof( void *))
      return( (unsigned long long ) MulleObjCIMPCall0( imp, obj, sel));

   (*imp)( obj, (mulle_objc_methodid_t) sel, &param);
   return( param.r.a);
}



#pragma mark - find overriden or specific methods

//
// slow search routines
// overridden will probably gain it's own keyword
//
IMP   MulleObjCObjectSearchSuperIMP( id obj,
                                     SEL sel,
                                     mulle_objc_classid_t classid);

IMP   MulleObjCObjectSearchSpecificIMP( id obj,
                                        SEL sel,
                                        mulle_objc_classid_t classid,
                                        mulle_objc_categoryid_t categoryid);
IMP   MulleObjCObjectSearchOverriddenIMP( id obj,
                                          SEL sel,
                                          mulle_objc_classid_t classid,
                                          mulle_objc_categoryid_t categoryid);

//
#define MulleObjCOverriddenIMP \
   MulleObjCObjectSearchOverriddenIMP( (self), (_cmd), __MULLE_OBJC_CLASSID__, __MULLE_OBJC_CATEGORYID__)

#define MulleObjCSpecificIMP \
   MulleObjCObjectSearchSpecificIMP( (self), (_cmd), __MULLE_OBJC_CLASSID__, __MULLE_OBJC_CATEGORYID__)

// avoid this, it's very slow
#define MulleObjCSuperIMP \
    MulleObjCSuperOverriddenIMP( (self), (_cmd), __MULLE_OBJC_CLASSID__)



#pragma mark - message sending helper

static inline id   MulleObjCObjectPerformSelector0( id obj, SEL sel)
{
   return( (id) mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, obj));
}


static inline id   MulleObjCObjectPerformSelector( id obj, SEL sel, id argument)
{
   return( (id) mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, argument));
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
   mulle_objc_metaabi_param_block_voidptr_return( struct { id a; id b; })  param;

   param.p.a = a;
   param.p.b = b;

   return( mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, &param));
}


static inline id   MulleObjCObjectPerformSelector3( id obj, SEL sel, id a, id b, id c)
{
   mulle_objc_metaabi_param_block_voidptr_return( struct { id a; id b; id c; })  param;

   param.p.a = a;
   param.p.b = b;
   param.p.c = c;

   return( mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, &param));
}


static inline id   MulleObjCObjectPerformSelector4( id obj, SEL sel, id a, id b, id c, id d)
{
   mulle_objc_metaabi_param_block_voidptr_return( struct { id a; id b; id c; id d; })  param;

   param.p.a = a;
   param.p.b = b;
   param.p.c = c;
   param.p.d = d;

   return( mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, &param));
}


static inline id   MulleObjCObjectPerformSelector5( id obj, SEL sel, id a, id b, id c, id d, id e)
{
   mulle_objc_metaabi_param_block_voidptr_return( struct { id a; id b; id c; id d; id e; })  param;

   param.p.a = a;
   param.p.b = b;
   param.p.c = c;
   param.p.d = d;
   param.p.e = e;

   return( mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, &param));
}


void    MulleObjCMakeObjectsPerformSelector2( id *objects, NSUInteger n, SEL sel, id argument, id argument2);

void    MulleObjCMakeObjectsPerformRetain( id *objects, NSUInteger n);
void    MulleObjCMakeObjectsPerformRelease( id *objects, NSUInteger n);


static inline Class   MulleObjCObjectGetClass( id obj)
{
   return( obj ? (Class) _mulle_objc_object_get_isa( obj) : Nil);
}


void    MulleObjCObjectSetClass( id obj, Class cls);

//
// only cheatin' strings should use this
// this must be used in init and nowhere else, as it is
// not atomic
//
static inline void   MulleObjCObjectConstantify( id obj)
{
   if( obj)
      _mulle_objc_object_constantify_noatomic( obj);
}

Class   NSClassFromObject( id object);

char    *MulleObjCClassGetName( Class cls);
char    *MulleObjCSelectorGetName( SEL sel);
char    *MulleObjCProtocolGetName( PROTOCOL sel);
Class   MulleObjCLookupClassByName( char *name);
SEL     MulleObjCCreateSelector( char *name);


static inline void   *MulleObjCClassGetExtraBytes( Class cls)
{
   return( cls ? _mulle_objc_infraclass_get_classextra( cls) : NULL);
}


static inline void   *MulleObjCInstanceGetExtraBytes( id obj)
{
   return( obj ? _mulle_objc_object_get_extra( obj) : NULL);
}

NSUInteger   MulleObjCClassGetLoadAddress( Class cls);


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


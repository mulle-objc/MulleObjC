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


#pragma mark - imp calling helpers


static inline id   MulleObjCCallIMP0( IMP imp, id obj, SEL sel)
{
   return( (id) (*imp)( obj, (mulle_objc_methodid_t) sel, obj));
}


static inline id   MulleObjCCallIMP( IMP imp, id obj, SEL sel, id argument)
{
   return( (id) (*imp)( obj, (mulle_objc_methodid_t) sel, argument));
}


static inline id   MulleObjCCallIMP2( IMP imp, id obj, SEL sel, id a, id b)
{
   mulle_objc_metaabi_param_block_void_return( struct { id a; id b;})  _param;

   _param.p.a = a;
   _param.p.b = b;

   return( (id) (*imp)( obj, (mulle_objc_methodid_t) sel, &_param));
}

static inline id   MulleObjCCallIMP3( IMP imp, id obj, SEL sel, id a, id b, id c)
{
   mulle_objc_metaabi_param_block_void_return( struct { id a; id b; id c;})  _param;

   _param.p.a = a;
   _param.p.b = b;
   _param.p.c = c;

   return( (id) (*imp)( obj, (mulle_objc_methodid_t) sel, &_param));
}

static inline id   MulleObjCCallIMP4( IMP imp, id obj, SEL sel, id a, id b, id c, id d)
{
   mulle_objc_metaabi_param_block_void_return( struct { id a; id b; id c; id d;})  _param;

   _param.p.a = a;
   _param.p.b = b;
   _param.p.c = c;
   _param.p.d = d;

   return( (id) (*imp)( obj, (mulle_objc_methodid_t) sel, &_param));
}

static inline id   MulleObjCCallIMP5( IMP imp, id obj, SEL sel, id a, id b, id c, id d, id e)
{
   mulle_objc_metaabi_param_block_void_return( struct { id a; id b; id c; id d; id e;})  _param;

   _param.p.a = a;
   _param.p.b = b;
   _param.p.c = c;
   _param.p.d = d;
   _param.p.e = e;

   return( (id) (*imp)( obj, (mulle_objc_methodid_t) sel, &_param));
}



#pragma mark - KVC support (write)

static inline id
   MulleObjCCallIMPWithFloat( IMP imp, id obj, SEL sel, float argument)
{
   mulle_objc_metaabi_param_block_void_return( struct { float a;})  _param;

   _param.p.a = argument;

   return( (id) (*imp)( obj, (mulle_objc_methodid_t) sel, &_param));
}


static inline id
   MulleObjCCallIMPWithDouble( IMP imp, id obj, SEL sel, double argument)
{
   mulle_objc_metaabi_param_block_void_return( struct { double a;})  _param;

   _param.p.a = argument;

   return( (id) (*imp)( obj, (mulle_objc_methodid_t) sel, &_param));
}


static inline id
   MulleObjCCallIMPWithLongDouble( IMP imp, id obj, SEL sel, long double argument)
{
   mulle_objc_metaabi_param_block_void_return( struct { long double a;})  _param;

   _param.p.a = argument;

   return( (id) (*imp)( obj, (mulle_objc_methodid_t) sel, &_param));
}


static inline id
   MulleObjCCallIMPWithLong( IMP imp, id obj, SEL sel, long argument)
{
   mulle_objc_metaabi_param_block_void_return( struct { long a;})  _param;

   if( sizeof( long) <= sizeof( void *))
      return( MulleObjCCallIMP( imp, obj, sel, (void *) (intptr_t) argument));

   _param.p.a = argument;

   return( (id) (*imp)( obj, (mulle_objc_methodid_t) sel, &_param));
}


static inline id
   MulleObjCCallIMPWithUnsignedLong( IMP imp, id obj, SEL sel, unsigned long argument)
{
   mulle_objc_metaabi_param_block_void_return( struct { unsigned long a;})  _param;

   if( sizeof( unsigned long) <= sizeof( void *))
      return( MulleObjCCallIMP( imp, obj, sel, (void *) (intptr_t) argument));

   _param.p.a = argument;

   return( (id) (*imp)( obj, (mulle_objc_methodid_t) sel, &_param));
}


static inline id
   MulleObjCCallIMPWithLongLong( IMP imp, id obj, SEL sel, long long argument)
{
   mulle_objc_metaabi_param_block_void_return( struct { long long a;})  _param;

   if( sizeof( long long) <= sizeof( void *))
      return( MulleObjCCallIMP( imp, obj, sel, (void *) (intptr_t) argument));

   _param.p.a = argument;

   return( (id) (*imp)( obj, (mulle_objc_methodid_t) sel, &_param));
}


static inline id
   MulleObjCCallIMPWithUnsignedLongLong( IMP imp,
                                         id obj,
                                         SEL sel,
                                         unsigned long long argument)
{
   mulle_objc_metaabi_param_block_void_return( struct { unsigned long long a;})  _param;

   if( sizeof( unsigned long long) <= sizeof( void *))
      return( MulleObjCCallIMP( imp, obj, sel, (void *) (intptr_t) argument));

   _param.p.a = argument;

   return( (id) (*imp)( obj, (mulle_objc_methodid_t) sel, &_param));
}

#pragma mark - KVC support (read)

static inline float   MulleObjCCallIMP0ReturningFloat( IMP imp, id obj, SEL sel)
{
   mulle_objc_metaabi_param_block_void_parameter( struct { float a;})  _param;

   (*imp)( obj, (mulle_objc_methodid_t) sel, &_param);
   return( _param.r.a);
}


static inline double
   MulleObjCCallIMP0ReturningDouble( IMP imp, id obj, SEL sel)
{
   mulle_objc_metaabi_param_block_void_parameter( struct { double a;})  _param;

   (*imp)( obj, (mulle_objc_methodid_t) sel, &_param);
   return( _param.r.a);
}


static inline long double
   MulleObjCCallIMP0ReturningLongDouble( IMP imp, id obj, SEL sel)
{
   mulle_objc_metaabi_param_block_void_parameter( struct { long double a;})  _param;

   (*imp)( obj, (mulle_objc_methodid_t) sel, &_param);
   return( _param.r.a);
}


static inline long   MulleObjCCallIMP0ReturningLong( IMP imp, id obj, SEL sel)
{
   mulle_objc_metaabi_param_block_void_parameter( struct { long a;})  _param;

   if( sizeof( long) <= sizeof( void *))
      return( (long) MulleObjCCallIMP0( imp, obj, sel));

   (*imp)( obj, (mulle_objc_methodid_t) sel, &_param);
   return( _param.r.a);
}


static inline unsigned long
   MulleObjCCallIMP0ReturningUnsignedLong( IMP imp, id obj, SEL sel)
{
   mulle_objc_metaabi_param_block_void_parameter( struct { unsigned long a;})  _param;

   if( sizeof( unsigned long) <= sizeof( void *))
      return( (unsigned long) MulleObjCCallIMP0( imp, obj, sel));

   (*imp)( obj, (mulle_objc_methodid_t) sel, &_param);
   return( _param.r.a);
}


static inline long long
   MulleObjCCallIMP0ReturningLongLong( IMP imp, id obj, SEL sel)
{
   mulle_objc_metaabi_param_block_void_parameter( struct { long long a;})  _param;

   if( sizeof( long long) <= sizeof( void *))
      return( (long long ) MulleObjCCallIMP0( imp, obj, sel));

   (*imp)( obj, (mulle_objc_methodid_t) sel, &_param);
   return( _param.r.a);
}


static inline unsigned long long
   MulleObjCCallIMP0ReturningUnsignedLongLong( IMP imp, id obj, SEL sel)
{
   mulle_objc_metaabi_param_block_void_parameter( struct { unsigned long long a;})  _param;

   if( sizeof( unsigned long long) <= sizeof( void *))
      return( (unsigned long long ) MulleObjCCallIMP0( imp, obj, sel));

   (*imp)( obj, (mulle_objc_methodid_t) sel, &_param);
   return( _param.r.a);
}



#pragma mark - find overriden or specific methods

//
// slow search routines
// overridden will probably gain it's own keyword
//
IMP   MulleObjCSearchSuperIMP( id obj,
                               SEL sel,
                               mulle_objc_classid_t classid);

IMP   MulleObjCSearchSpecificIMP( id obj,
                                 SEL sel,
                                 mulle_objc_classid_t classid,
                                 mulle_objc_categoryid_t categoryid);
IMP   MulleObjCSearchOverriddenIMP( id obj,
                                   SEL sel,
                                   mulle_objc_classid_t classid,
                                   mulle_objc_categoryid_t categoryid);

//
#define MulleObjCOverriddenIMP \
   MulleObjCSearchOverriddenIMP( (self), (_cmd), __MULLE_OBJC_CLASSID__, __MULLE_OBJC_CATEGORYID__)

#define MulleObjCSpecificIMP \
   MulleObjCSearchSpecificIMP( (self), (_cmd), __MULLE_OBJC_CLASSID__, __MULLE_OBJC_CATEGORYID__)

// avoid this, it's very slow
#define MulleObjCSuperIMP \
    MulleObjCSuperOverriddenIMP( (self), (_cmd), __MULLE_OBJC_CLASSID__)



#pragma mark - message sending helper

static inline id   MulleObjCPerformSelector0( id obj, SEL sel)
{
   return( (id) mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, obj));
}


static inline id   MulleObjCPerformSelector( id obj, SEL sel, id argument)
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


static inline id   MulleObjCPerformSelector2( id obj, SEL sel, id a, id b)
{
   mulle_objc_metaabi_param_block_void_return( struct { id a; id b; })  _param;

   _param.p.a = a;
   _param.p.b = b;

   return( mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, &_param));
}


static inline id   MulleObjCPerformSelector3( id obj, SEL sel, id a, id b, id c)
{
   mulle_objc_metaabi_param_block_void_return( struct { id a; id b; id c; })  _param;

   _param.p.a = a;
   _param.p.b = b;
   _param.p.c = c;

   return( mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, &_param));
}


static inline id   MulleObjCPerformSelector4( id obj, SEL sel, id a, id b, id c, id d)
{
   mulle_objc_metaabi_param_block_void_return( struct { id a; id b; id c; id d; })  _param;

   _param.p.a = a;
   _param.p.b = b;
   _param.p.c = c;
   _param.p.d = d;

   return( mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, &_param));
}


static inline id   MulleObjCPerformSelector5( id obj, SEL sel, id a, id b, id c, id d, id e)
{
   mulle_objc_metaabi_param_block_void_return( struct { id a; id b; id c; id d; id e; })  _param;

   _param.p.a = a;
   _param.p.b = b;
   _param.p.c = c;
   _param.p.d = d;
   _param.p.e = e;

   return( mulle_objc_object_call( obj, (mulle_objc_methodid_t) sel, &_param));
}


void    MulleObjCMakeObjectsPerformSelector2( id *objects, NSUInteger n, SEL sel, id argument, id argument2);

void    MulleObjCMakeObjectsPerformRetain( id *objects, NSUInteger n);
void    MulleObjCMakeObjectsPerformRelease( id *objects, NSUInteger n);


static inline Class   MulleObjCGetClass( id obj)
{
   return( obj ? (Class) _mulle_objc_object_get_isa( obj) : Nil);
}


void    MulleObjCSetClass( id obj, Class cls);

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

char   *MulleObjCClassGetName( Class cls);
char   *MulleObjCSelectorGetName( SEL sel);
char   *MulleObjCProtocolGetName( PROTOCOL sel);
Class  MulleObjCLookupClassByName( char *name);
SEL    MulleObjCCreateSelector( char *name);


static inline void   *MulleObjCGetClassExtra( Class cls)
{
   return( cls ? _mulle_objc_infraclass_get_classextra( cls) : NULL);
}


static inline void   *MulleObjCGetInstanceExtra( id obj)
{
   return( obj ? _mulle_objc_object_get_extra( obj) : NULL);
}

//
// allow isa with cpp define
// The cast is not really type correct, as isa can be the metaclass
//
#ifndef MULLE_OBJC_NO_ISA_HACK
# define isa   MulleObjCGetClass( self)
#endif


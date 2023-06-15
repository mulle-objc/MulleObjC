//
//  mulle-objc-type.h
//  MulleObjC
//
//  Copyright (c) 2015 Nat! - Mulle kybernetiK.
//  Copyright (c) 2015 Codeon GmbH.
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

// This header should be includeable by C and must not require inclusion
// or link the runtime

#ifndef mulle_objc_type__h__
#define mulle_objc_type__h__

/*
 * Try to stay minimal here.
 * The minimal stuff provided by the runtime, should not force the user to
 * create a universe. It should keep the namespace as free as possible from
 * dependencies.
 */
#include <mulle-objc-runtime/minimal.h>

#include <string.h>

//
// this should be C readable
// these are here in the header, but they are actually defined by the
// compiler. So you can't really change them.
//
// --- compiler defined begin ---
typedef void                            *id;
typedef struct _mulle_objc_infraclass   *Class;  // the meta-class is not "visible" to Class users



// returns `dst`
MULLE_C_NONNULL_FIRST_SECOND
static inline id   *mulle_id_copy( id *dst, id *src, size_t length)
{
   return( memcpy( dst, src, sizeof( id) * length));
}


// returns `dst`
MULLE_C_NONNULL_FIRST_SECOND
static inline id   *mulle_id_move( id *dst, id *src, size_t length)
{
   return( memmove( dst, src, sizeof( id) * length));
}

// returns `dst`
MULLE_C_NONNULL_FIRST
static inline void  *mulle_id_clear( id *dst, size_t length)
{
   return( memset( dst, 0, sizeof( id) * length));
}


#define mulle_flexarray_do_id( buf, static_len, len) \
   mulle_flexarray_do( buf, id, (static_len), (len))


//
// "Protocol" as a valid keyword and a pseudo-class does not exist
// @protocol( Foo) returns a mulle_objc_protocolid_t, which is an "uint32_t"
// For other compilers say   `typedef Protocol   *PROTOCOL`
// and code will work on both sides.
//
typedef mulle_objc_methodid_t       SEL;
typedef mulle_objc_protocolid_t     PROTOCOL;
typedef struct _mulle_objc_method   *Method;
typedef struct _mulle_objc_ivar     *Ivar;
typedef id                          (*IMP)( id, SEL, void *);

// --- compiler defined end ---

// turn off this warning, because it's wrong for us
#pragma clang diagnostic ignored "-Wcast-of-sel-type"


//
// in AAM define some harmless syntax sugar, so more stuff compiles
//
#ifdef __OBJC_AAM__
# define __bridge
# define __unsafe_unretained
#endif


#define nil   ((id) 0)
#define Nil   ((Class) 0)

// idee ? statt isa
// #define Self  object_getClass( self)

// defined some Apple macros, for easier compilation and porting

#define NS_ASSUME_NONNULL_BEGIN
#define NS_ASSUME_NONNULL_END
#define NS_SWIFT_NAME( unused)
#define NS_SWIFT_UNAVAILABLE( unused)
#define NS_REQUIRES_NIL_TERMINATION

// https://nshipster.com/ns_enum-ns_options/

#ifndef NSENUM

//// precede with typedef like:  typedef NS_ENUM( NSUInteger, foo) { x = 1; }

#define NS_ENUM( type, name)                    \
type   name;                                    \
struct name ## __item { char *s; type value; }; \
enum name

// define an enum in .h:
//
// typedef NS_ENUM( int, Foo) { A, B, C }
//
// Then create an extern reference for the table in .h:
//
// extern NS_ENUM_TABLE( Foo, 3);
//
// In the .c/.m file create the table:
//
// NS_ENUM_TABLE( Foo, 3) = { NS_ENUM_ITEM( A), NS_ENUM_ITEM( B), NS_ENUM_ITEM( C) };
//
// And that's it.
//
#define NS_ENUM_ITEM( name)            { #name, name  }
#define NS_ENUM_ITEM_TYPE( name)       struct name ## __item
#define NS_ENUM_TABLE( name, length)   NS_ENUM_ITEM_TYPE( name) name ## __table[ length]
#define NS_ENUM_PRINT( name, item)                                                       \
   _NS_ENUM_UTF8String( name ## __table,                                         \
                        sizeof( name ## __table) / sizeof( name ## __table[ 0]), \
                        sizeof( name ## __table[ 0]),                            \
                        offsetof( NS_ENUM_ITEM_TYPE( name), value),              \
                        sizeof( name ## __table[ 0].value),                      \
                        item)
#define NS_ENUM_PARSE( name, string)                                                          \
   _NS_ENUM_ParseUTF8String( name ## __table,                                         \
                             sizeof( name ## __table) / sizeof( name ## __table[ 0]), \
                             sizeof( name ## __table[ 0]),                            \
                             offsetof( NS_ENUM_ITEM_TYPE( name), value),              \
                             sizeof( name ## __table[ 0].value),                      \
                             string)

//
//// precede with typedef like:  typedef NS_OPTIONS( NSUInteger, foo) { x = 1; }
//
#define NS_OPTIONS( type, name)                 \
type   name;                                    \
struct name ## __item { char *s; type value; }; \
enum name


//
// Just the same but for options
//
#define NS_OPTIONS_ITEM( name)            { #name, name }
#define NS_OPTIONS_ITEM_TYPE( name)       struct name ## __item
#define NS_OPTIONS_TABLE( name, length)   NS_OPTIONS_ITEM_TYPE( name) name ## __table[ length]
#define NS_OPTIONS_PRINT( name, options)                                                 \
   _NS_OPTIONS_UTF8String( name ## __table,                                         \
                           sizeof( name ## __table) / sizeof( name ## __table[ 0]), \
                           sizeof( name ## __table[ 0]),                            \
                           offsetof( NS_OPTIONS_ITEM_TYPE( name), value),           \
                           sizeof( name ## __table[ 0].value),                      \
                           options)
#define NS_OPTIONS_PARSE( name, string)                                                       \
   _NS_OPTIONS_ParseUTF8String( name ## __table,                                         \
                                sizeof( name ## __table) / sizeof( name ## __table[ 0]), \
                                sizeof( name ## __table[ 0]),                            \
                                offsetof( NS_OPTIONS_ITEM_TYPE( name), value),           \
                                sizeof( name ## __table[ 0].value),                      \
                                string)


unsigned long long   _NS_ENUM_ParseUTF8String( void *table,
                                               size_t len,
                                               size_t line_size,
                                               size_t offset,
                                               size_t item_len,
                                               char *s);

unsigned long long   _NS_OPTIONS_ParseUTF8String( void *table,
                                                  size_t len,
                                                  size_t line_size,
                                                  size_t offset,
                                                  size_t item_len,
                                                  char *s);
char   *_NS_ENUM_UTF8String( void *table,
                             size_t len,
                             size_t line_size,
                             size_t offset,
                             size_t item_len,
                             unsigned long long bits);

char   *_NS_OPTIONS_UTF8String( void *table,
                                size_t len,
                                size_t line_size,
                                size_t offset,
                                size_t item_len,
                                unsigned long long bits);

#endif

#endif

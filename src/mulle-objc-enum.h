//
//  mulle-objc-enum.h
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

#ifndef mulle_objc_enum__h__
#define mulle_objc_enum__h__

// https://nshipster.com/ns_enum-ns_options/

#ifndef NSENUM

#include <stddef.h>


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
#define NS_ENUM_PRINT( name, item)                                                                \
   _NS_ENUM_UTF8String( name ## __table,                                                          \
                        (unsigned int) (sizeof( name ## __table) / sizeof( name ## __table[ 0])), \
                        sizeof( name ## __table[ 0]),                                             \
                        offsetof( NS_ENUM_ITEM_TYPE( name), value),                               \
                        sizeof( name ## __table[ 0].value),                                       \
                        item)
#define NS_ENUM_LOOKUP( name, item)                                                                      \
   _NS_table_search_UTF8String( name ## __table,                                                         \
                               (unsigned int) (sizeof( name ## __table) / sizeof( name ## __table[ 0])), \
                               sizeof( name ## __table[ 0]),                                             \
                               offsetof( NS_ENUM_ITEM_TYPE( name), value),                               \
                               sizeof( name ## __table[ 0].value),                                       \
                               item)
#define NS_ENUM_PARSE( name, string)                                                                   \
   _NS_ENUM_ParseUTF8String( name ## __table,                                                          \
                             (unsigned int) (sizeof( name ## __table) / sizeof( name ## __table[ 0])), \
                             sizeof( name ## __table[ 0]),                                             \
                             offsetof( NS_ENUM_ITEM_TYPE( name), value),                               \
                             sizeof( name ## __table[ 0].value),                                       \
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
#define NS_OPTIONS_PRINT( name, options)                                            \
   _NS_OPTIONS_UTF8String( name ## __table,                                         \
                           (unsigned int) (sizeof( name ## __table) / sizeof( name ## __table[ 0])), \
                           sizeof( name ## __table[ 0]),                            \
                           offsetof( NS_OPTIONS_ITEM_TYPE( name), value),           \
                           sizeof( name ## __table[ 0].value),                      \
                           options)
#define NS_OPTIONS_LOOKUP( name, item)                                           \
   _NS_table_search_UTF8String( name ## __table,                                 \
                        (unsigned int) (sizeof( name ## __table) / sizeof( name ## __table[ 0])), \
                        sizeof( name ## __table[ 0]),                            \
                        offsetof( NS_OPTIONS_ITEM_TYPE( name), value),           \
                        sizeof( name ## __table[ 0].value),                      \
                        item)
#define NS_OPTIONS_PARSE( name, string)                                                  \
   _NS_OPTIONS_ParseUTF8String( name ## __table,                                         \
                                (unsigned int) (sizeof( name ## __table) / sizeof( name ## __table[ 0])), \
                                sizeof( name ## __table[ 0]),                            \
                                offsetof( NS_OPTIONS_ITEM_TYPE( name), value),           \
                                sizeof( name ## __table[ 0].value),                      \
                                string)


//MULLE_OBJC_GLOBAL
char   *_NS_table_search_UTF8String( void *table,
                                     unsigned int len,
                                     size_t line_size,
                                     size_t offset,
                                     size_t item_len,
                                     unsigned long long bit);


//MULLE_OBJC_GLOBAL (dont have it here, why ?)
unsigned long long   _NS_ENUM_ParseUTF8String( void *table,
                                               unsigned int len,
                                               size_t line_size,
                                               size_t offset,
                                               size_t item_len,
                                               char *s);

//MULLE_OBJC_GLOBAL
unsigned long long   _NS_OPTIONS_ParseUTF8String( void *table,
                                                  unsigned int len,
                                                  size_t line_size,
                                                  size_t offset,
                                                  size_t item_len,
                                                  char *s);
//MULLE_OBJC_GLOBAL

char   *_NS_ENUM_UTF8String( void *table,
                             unsigned int len,
                             size_t line_size,
                             size_t offset,
                             size_t item_len,
                             unsigned long long bits);

//MULLE_OBJC_GLOBAL

char   *_NS_OPTIONS_UTF8String( void *table,
                                unsigned int len,
                                size_t line_size,
                                size_t offset,
                                size_t item_len,
                                unsigned long long bits);

//MULLE_OBJC_GLOBAL

size_t   _NS_OPTIONS_prefix_length( void *table,
                                    unsigned int len,
                                    size_t line_size);

static inline size_t   _NS_ENUM_prefix_length( void *table,
                                               unsigned int len,
                                               size_t line_size)
{
   return( _NS_OPTIONS_prefix_length( table, len, line_size));
}


#define NS_OPTIONS_PREFIX_LEN( name)                                                                    \
   _NS_OPTIONS_prefix_length( name ## __table,                                                          \
                              (unsigned int) (sizeof( name ## __table) / sizeof( name ## __table[ 0])), \
                              sizeof( name ## __table[ 0]))

#define NS_ENUM_PREFIX_LEN( name)                                                                       \
   _NS_ENUM_prefix_length( name ## __table,                                                             \
                              (unsigned int) (sizeof( name ## __table) / sizeof( name ## __table[ 0])), \
                              sizeof( name ## __table[ 0]))

#endif // ifndef NSENUM

#endif
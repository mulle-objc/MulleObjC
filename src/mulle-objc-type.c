//
//  mulle-objc-type.c
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
#include "mulle-objc-type.h"

#include "include.h"

#include <stdio.h>
#include <ctype.h>


// returns pointer as a convenience
extern char   *MulleObjC_asprintf( char *format, ...);

void   *MulleObjCAutoreleaseAllocation( void *pointer,
                                        struct mulle_allocator *allocator);

char   *_NS_table_search_UTF8String( void *table,
                                     unsigned int len,
                                     size_t line_size,
                                     size_t offset,
                                     size_t item_len,
                                     unsigned long long bit)
{
   unsigned int           i;
   void                   *line;
   unsigned long long     value;

   line = table;
   for( i = 0; i < len; i++)
   {
      switch( item_len)
      {
      case 1  : value = *(uint8_t *)  &((char *) line)[ offset]; break;
      case 2  : value = *(uint16_t *) &((char *) line)[ offset]; break;
      case 4  : value = *(uint32_t *) &((char *) line)[ offset]; break;
      case 8  : value = *(uint64_t *) &((char *) line)[ offset]; break;
      default : abort();
      }

      if( bit == value)
         return( *(char **) line);

      line = &((char *) line)[ line_size];
   }
   return( NULL);
}



char   *_NS_OPTIONS_UTF8String( void *table,
                                unsigned int len,
                                size_t line_size,
                                size_t offset,
                                size_t item_len,
                                unsigned long long bits)
{
   char                   *s;
   unsigned int           i;
   void                   *line;
   unsigned long long     value;
   char                   *empty;

   assert( "the enum table has too few entries" && (! len || *(char **) &((char *) table)[ line_size * (len - 1)]));

   empty = NULL;
   mulle_buffer_do_string( buffer, NULL, s)
   {
      line = table;
      for( i = 0; i < len; i++)
      {
         switch( item_len)
         {
         case 1  : value = *(uint8_t *)  &((char *) line)[ offset]; break;
         case 2  : value = *(uint16_t *) &((char *) line)[ offset]; break;
         case 4  : value = *(uint32_t *) &((char *) line)[ offset]; break;
         case 8  : value = *(uint64_t *) &((char *) line)[ offset]; break;
         default : abort();
         }

         if( ! value)
            empty = *(char **) line;
         else
            if( (bits & value) == value)
            {
               mulle_buffer_add_string_if_not_empty( buffer, "|");
               assert( *(char **) line);
               mulle_buffer_add_string( buffer, *(char **) line);

               bits &= ~value;
            }
         line = &((char *) line)[ line_size];
      }

      if( bits)
      {
         mulle_buffer_add_string_if_not_empty( buffer, "|");
         mulle_buffer_sprintf( buffer, "0x%llx", bits);
      }

      mulle_buffer_add_string_if_empty( buffer, empty ? empty : "0");
   }

   return( MulleObjCAutoreleaseAllocation( s, NULL));
}


// TODO: adapt this to our table, then figure out common prefix for those
//       string entries. This can then be used either for parsing shortened
//       strings or to output shortened strings.
//
// thx AI
size_t   _NS_OPTIONS_prefix_length( void *table,
                                    unsigned int len,
                                    size_t line_size)
{
   void           *line;
   char           *first;
   char           *s;
   size_t         max_len;
   size_t         j;
   unsigned int   i;
   char           c;

   if( ! len)
      return( 0);
   
   line    = table;
   first   = *(char **) line;
   max_len = strlen( first);

   for( j = 0; j < max_len; j++) 
   {
      c    = first[ j];
      line = table;
      for( i = 1; i < len; i++) 
      {
         line = &((char *) line)[ line_size];
         s    = *(char **) line;
         if( ! s[ j] || s[ j] != c) 
            return( j);
      }
   }
   
   return( max_len);
}



char   *_NS_ENUM_UTF8String( void *table,
                             unsigned int len,
                             size_t line_size,
                             size_t offset,
                             size_t item_len,
                             unsigned long long value)
{
   char   *s;

   assert( "the options table has too few entries" && (! len || *(char **) &((char *) table)[ line_size * (len - 1)]));

   s = _NS_table_search_UTF8String( table, len, line_size, offset, item_len, value);
   if( s)
      return( s);
   if( ! value)
      return( "0");
   return( MulleObjC_asprintf( "0x%llx", value));
}


unsigned long long   _NS_OPTIONS_ParseUTF8String( void *table,
                                                  unsigned int len,
                                                  size_t line_size,
                                                  size_t offset,
                                                  size_t item_len,
                                                  char *s)
{
   unsigned int         i;
   void                 *line;
   unsigned long long   value;
   char                 *key;
   size_t               key_len;

   value = 0;

   if( ! s)
      return( value);

   if( isdigit( *s))
      return( atoll( s));

   while( *s)
   {
      line = table;
      for( i = 0; i < len; i++)
      {
         key     = *(char **) line;
         key_len = strlen( key);
         if( ! strncmp( key, s, key_len))
         {
            switch( item_len)
            {
            case 1  : value |= *(uint8_t *)  &((char *) line)[ offset]; break;
            case 2  : value |= *(uint16_t *) &((char *) line)[ offset]; break;
            case 4  : value |= *(uint32_t *) &((char *) line)[ offset]; break;
            case 8  : value |= *(uint64_t *) &((char *) line)[ offset]; break;
            default : abort();
            }
            goto next;
         }
         line = &((char *) line)[ line_size];
      }
      return( 0);

next:
      s = &s[ key_len];
      if( *s == '|' && s[ 1] != 0)
         ++s;
   }
   return( value);
}


unsigned long long   _NS_ENUM_ParseUTF8String( void *table,
                                               unsigned int len,
                                               size_t line_size,
                                               size_t offset,
                                               size_t item_len,
                                               char *s)
{
   unsigned int         i;
   void                 *line;
   unsigned long long   value;
   char                 *key;
   size_t               key_len;

   value = 0;

   if( ! s)
      return( value);

   if( isdigit( *s))
      return( atoll( s));

   line = table;
   for( i = 0; i < len; i++)
   {
      key     = *(char **) line;
      key_len = strlen( key);
      if( ! strncmp( key, s, key_len))
      {
         switch( item_len)
         {
         case 1  : value = *(uint8_t *)  &((char *) line)[ offset]; break;
         case 2  : value = *(uint16_t *) &((char *) line)[ offset]; break;
         case 4  : value = *(uint32_t *) &((char *) line)[ offset]; break;
         case 8  : value = *(uint64_t *) &((char *) line)[ offset]; break;
         default : abort();
         }
         return( value);
      }
      line = &((char *) line)[ line_size];
   }
   return( 0);
}

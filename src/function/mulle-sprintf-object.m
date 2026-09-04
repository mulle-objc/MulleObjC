//
//  mulle-sprintf-object.m
//  MulleObjC
//
//  Copyright (c) 2021 Nat! - Mulle kybernetiK.
//  Copyright (c) 2011 Codeon GmbH.
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
#import "mulle-sprintf-object.h"

// other files in this library
#import "NSObject.h"

// other libraries of MulleObjCValueFoundation

// std-c and dependencies
#import "import-private.h"


#if MULLE__SPRINTF_VERSION < ((0 << 20) | (6 << 8) | 0)
# error "mulle-sprintf is too old"
#endif

struct
{
   BOOL  colorize;
} ClassStatic;

static int  _sprintf_object_conversion( struct mulle_buffer *buffer,
                                        struct mulle_sprintf_formatconversioninfo *info,
                                        struct mulle_sprintf_argumentarray *arguments,
                                        int argc)
{
   union mulle_sprintf_argumentvalue  v;
   char                               *s;

   assert( buffer);
   assert( info);
   assert( arguments);

   v = arguments->values[ argc];
   s = "(nil)";
   if( v.obj)
   {
#ifdef DEBUG
      struct _mulle_objc_class   *cls;

      cls = __mulle_objc_object_get_isa( v.obj);
      if( ! cls)
      {
         // TODO: avoid calling mulle_fprintf recursively within itself
         fprintf( stderr, "The runtime has no string class loaded, so the %%@ format is invalid.\n"
                                "MulleObjC has no string class. Use MulleFoundation for NSString.\n");
         abort();
      }
#endif
      if( info->memory.hash_found)
      {
         if( ClassStatic.colorize && ! info->memory.minus_found)
            s = [(id) v.obj colorizedUTF8String];  // inherently thread safe!
         else
            s = [(id) v.obj nonLockingUTF8String]; // thread safe!
      }
      else
         s = [(id) v.obj UTF8String];              // not thread safe!
   }
   // do not use alternate output on string
   info->memory.hash_found = 0;
   return( _mulle_sprintf_charstring_conversion( buffer, info, s));
}



static mulle_sprintf_argumenttype_t  sprintf_get_object_argumenttype( struct mulle_sprintf_formatconversioninfo *info)
{
   return( mulle_sprintf_object_argumenttype);
}


static struct mulle_sprintf_function   sprintf_object_function =
{
   sprintf_get_object_argumenttype,
   _sprintf_object_conversion
};


void   mulle_sprintf_register_object_functions( struct mulle_sprintf_conversion *tables)
{
   mulle_sprintf_register_functions( tables, &sprintf_object_function, '@');

   // colorizing modifier
   mulle_sprintf_register_modifiers( tables, "#");
}


// taken from
// https://github.com/mulle-nat/mulle-bashfunctions/blob/release/src/mulle-logging.sh#L308
//
static BOOL   colorize( void)
{
   char   *s;
//   FILE   *fp;

   if( getenv( "NO_COLOR"))
      return( NO);

   // check environmen vars
   s = getenv( "MULLE_NO_COLOR");
   if( s && ! strcmp( s, "YES"))
      return( NO);

   // if TERM is dumb dont
   s = getenv( "TERM");
   if( s && ! strcmp( s, "dumb"))
      return( NO);

// don't want FILE I/O here
//
//   // run with redirection check
//   fp = fopen( "/dev/stderr", "r");
//   if( ! fp)
//      return( NO);
//   fclose( fp);

   return( YES);
}


__attribute__((constructor))
static void  mulle_sprintf_register_default_object_functions()
{
   ClassStatic.colorize = colorize();

   mulle_sprintf_register_object_functions( mulle_sprintf_get_defaultconversion());
}


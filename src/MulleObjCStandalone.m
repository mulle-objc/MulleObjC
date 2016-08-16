//
//  MulleStandaloneObjC.c
//  MulleObjC
//
//  Created by Nat! on 04.02.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//
#include "ns_objc_setup.h"

#include <stdlib.h>


__attribute__((const))  // always returns same value (in same thread)
struct _mulle_objc_runtime  *__get_or_create_objc_runtime( void)
{
   struct _mulle_objc_runtime  *runtime;
   
   runtime = __mulle_objc_get_runtime();
   if( runtime->version)
      return( runtime);
   
   {
      struct _ns_root_setupconfig   config;
      
      memcpy( &config, ns_objc_get_default_setupconfig(), sizeof( config));
      return( ns_objc_create_runtime( &config));
   }
}


//
// see: https://stackoverflow.com/questions/35998488/where-is-the-eprintf-symbol-defined-in-os-x-10-11/36010972#36010972
//
__attribute__((visibility("hidden")))
void __eprintf( const char* format, const char* file,
               unsigned line, const char *expr)
{
   fprintf( stderr, format, file, line, expr);
   abort();
}

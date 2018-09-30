// std-c and other dependencies
#include <stdlib.h>


static void   bang( struct _mulle_objc_universe *universe,
                    void *userinfo)
{
   struct _mulle_objc_universeconfiguration   config;

   memcpy( &config, mulle_objc_global_get_default_universeconfiguration(), sizeof( config));
   mulle_objc_universe_configure( universe, &config);
}


// always returns same value (in same thread)
MULLE_C_CONST_RETURN struct _mulle_objc_universe  *
   __register_mulle_objc_universe( mulle_objc_universeid_t universeid,
   										  char *universename)
{
   struct _mulle_objc_universe   *universe;

   universe = __mulle_objc_global_get_universe( universeid, universename);
   if( ! _mulle_objc_universe_is_initialized( universe))
      _mulle_objc_universe_bang( universe, bang, NULL);

   return( universe);
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

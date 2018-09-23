// std-c and other dependencies
#include <stdlib.h>


static void   bang( struct _mulle_objc_universe *universe,
                    void (*crunch)( void),
                    void *userinfo)
{
   struct _mulle_objc_setupconfig   config;

   memcpy( &config, ns_objc_get_default_setupconfig(), sizeof( config));
   mulle_objc_universe_setup( universe, &config);
}


MULLE_C_CONST_RETURN  // always returns same value (in same thread)
struct _mulle_objc_universe  *__get_or_create_mulle_objc_universe( void)
{
   struct _mulle_objc_universe   *universe;
   extern void   ns_obj_universe_tear_down();

   universe = __mulle_objc_get_universe();
   if( ! _mulle_objc_universe_is_initialized( universe))
      _mulle_objc_universe_bang( universe, bang, NULL, NULL);

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

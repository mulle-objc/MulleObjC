
// clang speciality
#ifdef __has_include
# if __has_include( <dlfcn.h>)
#  include <dlfcn.h>
#  define HAVE_DLSYM  1
# endif
#endif


static void   bang( struct _mulle_objc_universe *universe,
                    struct mulle_allocator *allocator,
                    void *userinfo);


static inline void   MulleObjCBang( struct _mulle_objc_universe *universe,
                                    struct mulle_allocator *allocator,
                                    struct _mulle_objc_universeconfiguration *config)
{
   //
   // allocator not used in this bang, it's already
   // set in the universe
   //
   mulle_objc_universe_configure( universe, config);
}


// always returns same value (in same thread)
MULLE_C_CONST_RETURN struct _mulle_objc_universe  *
   __register_mulle_objc_universe( mulle_objc_universeid_t universeid,
                                   char *universename)
{
   struct _mulle_objc_universe   *universe;
   struct mulle_allocator        *allocator;

   allocator = NULL;
   if( mulle_objc_environment_get_yes_no( "MULLE_OBJC_TESTALLOCATOR_ENABLED"))
   {
#if HAVE_DLSYM
      allocator = dlsym( RTLD_DEFAULT, "mulle_testallocator");
      if( ! allocator)
      {
         fprintf( stderr, "warning: testallocator not available. Is \
mulle-testallocator linked to the executable ?\n");
      }
#else
      fprintf( stderr, "warning: testallocator not available. This platform \
does not support dlsym\n");
#endif
   }

   universe = __mulle_objc_global_get_universe( universeid, universename);
   if( ! _mulle_objc_universe_is_initialized( universe))
      _mulle_objc_universe_bang( universe, bang, allocator, NULL);

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

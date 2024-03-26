#import <MulleObjC/MulleObjC.h>


int   main( int argc, char *argv[])
{
   struct _mulle_objc_universe  *universe;

   universe = mulle_objc_global_get_defaultuniverse();
   mulle_objc_universe_fail_generic( universe, "%s %s %s", "Just", "fail", "here");
   return( 0);
}


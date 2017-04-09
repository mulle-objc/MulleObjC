#include <mulle_objc/mulle_objc.h>


int   main( int argc, char *argv[])
{
   mulle_objc_check_runtimewaitqueues();
   // just look for +load output
   return( 0);
}

#import <MulleObjC/MulleObjC.h>
#import <MulleObjC/NSDebug.h>

#include "class-system.inc"


int   main( int argc, char *argv[])
{
   MulleObjCDotdumpMetaHierarchy( "B");

   [A overridden];
   printf( "\n");
   [B overridden];
   return( 0);
}


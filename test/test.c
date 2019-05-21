#include <stdio.h>


main( int argc, char **argv)
{
   if( argc & 0x1)
      printf( "odd\n");

   if( argc & 0x3)
	printf( "very odd\n");
}


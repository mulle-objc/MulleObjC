#include <mulle_objc/mulle_objc.h>


#include <stdio.h>


main()
{
   SEL  sel;

   sel = (SEL) 0x29682abb;
   if( sel == @selector( vfl))
      printf( "passed\n");
}

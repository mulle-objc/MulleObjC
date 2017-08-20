#include <mulle_objc_runtime/mulle_objc_runtime.h>
#include <stdio.h>


main()
{
   SEL  sel;

   sel = (SEL) 0xd0557652;
   if( sel == @selector( vfl))
      printf( "passed\n");
}

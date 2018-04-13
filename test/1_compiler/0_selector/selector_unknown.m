#include <MulleObjC/dependencies.h>
#include <stdio.h>


main()
{
   printf( "Unknown selectors have no name: %s\n",
      mulle_objc_lookup_methodname( @selector( foo)));
}

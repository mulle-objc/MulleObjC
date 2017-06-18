#include <mulle_objc_runtime/mulle_objc_runtime.h>
#include <stdio.h>


main()
{
   printf( "Unknown selectors have no name: %s\n",
      mulle_objc_lookup_methodname( @selector( foo)));
}

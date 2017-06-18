#include <mulle_objc_runtime/mulle_objc_runtime.h>



main()
{
   static SEL   array[] =
   {
      @selector( Foo) // happy if compiles
   };
   return( 0);
}



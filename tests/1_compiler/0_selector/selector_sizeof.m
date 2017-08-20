#include <MulleObjC/MulleObjC.h>


main()
{
   printf( "%s\n",
      sizeof( mulle_objc_uniqueid_t) == sizeof( SEL) ? "YES" : "NO");
}

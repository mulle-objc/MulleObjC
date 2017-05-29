#include <MulleObjC/MulleObjC.h>


main()
{
   printf( "%s\n",
      sizeof( mulle_objc_protocolid_t) == sizeof( PROTOCOL) ? "YES" : "NO");
}

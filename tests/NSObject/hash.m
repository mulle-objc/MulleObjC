#ifndef __MULLE_RUNTIME__
# import <Foundation/Foundation.h>
#else
# import <MulleStandaloneObjC/MulleStandaloneObjC.h>
#endif


main()
{
   // can only do existance (non-crash) checks
   [NSObject hash];
   [[NSObject new] hash];
}

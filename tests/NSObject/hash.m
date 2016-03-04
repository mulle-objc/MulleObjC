#ifndef __MULLE_OBJC_RUNTIME__
# import <Foundation/Foundation.h>
#else
# import <MulleStandaloneObjC/MulleStandaloneObjC.h>
#endif


main()
{
   id   obj;

   // can only do existance (non-crash) checks
   [NSObject hash];
   obj = [NSObject new];
   [obj hash];
   [obj release];
}

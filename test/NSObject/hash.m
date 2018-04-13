#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjC/MulleObjC.h>
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

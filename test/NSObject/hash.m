#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjC/MulleObjC.h>
#endif


@interface Root
@end


@implementation Root

- (void) hash
{
}

@end

int  main( void)
{
   id   obj;

   obj = [NSObject new];
   [obj hash];
   [obj release];

   [Root hash];

   // can only do existance (non-crash) checks
   [NSObject hash];
}

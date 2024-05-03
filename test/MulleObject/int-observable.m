#import <MulleObjC/MulleObjC.h>

#include <stdio.h>


@interface Foo : MulleObject

@property( dynamic, assign, observable) int  myIntValue;

- (void) willChange;

@end


@implementation Foo

@dynamic myIntValue;

- (void) willChange
{
   printf( "%s\n", __PRETTY_FUNCTION__);
}

@end




int  main()
{
   Foo   *obj;

   obj = [Foo object];
   printf( "%d\n", [obj myIntValue]);
   [obj setMyIntValue:1848];
   printf( "%d\n", [obj myIntValue]);
   return( 0);
}



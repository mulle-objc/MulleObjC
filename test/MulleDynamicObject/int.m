#import <MulleObjC/MulleObjC.h>

#include <stdio.h>


@interface Foo : MulleDynamicObject

@property( dynamic, assign) int  myIntValue;

@end


@implementation Foo

@dynamic myIntValue;

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




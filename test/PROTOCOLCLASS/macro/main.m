#import <MulleObjC/MulleObjC.h>

#import "Foo.h"

#include <stdio.h>


@interface MyClass : NSObject < Foo>
{
  struct FooIvars   ivars;
}
@end


@implementation MyClass

- (struct FooIvars *) getFooIvars
{
   return( &ivars);
}

- (void) print
{
   printf( "%d\n", ivars.a);
}

@end


int   main( void)
{
   MyClass   *obj;

   @autoreleasepool
   {
      obj = [[MyClass new] autorelease];
      [obj doTheFooThing];
      [obj print];
   }
   return( 0);
}


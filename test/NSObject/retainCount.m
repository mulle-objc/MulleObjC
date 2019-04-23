#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjC/MulleObjC.h>
#endif


@interface Foo : NSObject
@end


@implementation Foo
@end


main()
{
   Foo   *foo;

   foo = [Foo new];
   printf( "1: %lu\n", (unsigned long) [foo retainCount]);
   [foo retain];
   printf( "2: %lu\n", (unsigned long) [foo retainCount]);
   [foo release];
   printf( "3: %lu\n", (unsigned long) [foo retainCount]);
   [foo release];

   foo = [Foo new];
   printf( "a: %lu\n", (unsigned long) [foo retainCount]);
   [foo mullePerformFinalize] ;
   printf( "b: %lu\n", (unsigned long) [foo retainCount]);
   [foo release];

   foo = [Foo new];
   [foo retain];
   printf( "A: %lu\n", (unsigned long) [foo retainCount]);
   [foo mullePerformFinalize] ;
   printf( "B: %lu\n", (unsigned long) [foo retainCount]);
   [foo retain];
   printf( "C: %lu\n", (unsigned long) [foo retainCount]);
   [foo release];
   [foo release];
   [foo release];

   return( 0);
}

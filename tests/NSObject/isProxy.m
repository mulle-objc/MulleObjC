#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjC/MulleObjC.h>
#endif


@interface Foo : NSObject
@end


@implementation Foo
@end


static void print_bool( BOOL flag)
{
   printf( "%s\n", flag ? "YES" : "NO");
}


main()
{
   Foo   *foo;
   id    obj;

   print_bool( [NSObject isProxy]);
   obj = [NSObject new];
   print_bool( [obj isProxy]);
   [obj release];

   print_bool( [Foo isProxy]);

   foo = [Foo new];
   print_bool( [foo isProxy]);
   [foo release];

   return( 0);
}

#ifndef __MULLE_RUNTIME__
# import <Foundation/Foundation.h>
#else
# import <MulleStandaloneObjC/MulleStandaloneObjC.h>
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

   print_bool( [NSObject isProxy]);
   print_bool( [[NSObject new] isProxy]);

   print_bool( [Foo isProxy]);
   print_bool( [[Foo new] isProxy]);
}

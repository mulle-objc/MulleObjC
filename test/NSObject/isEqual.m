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
   Foo   *foo1, *foo2;

   print_bool( [NSObject isEqual:[NSObject class]]);

   print_bool( [Foo isEqual:[NSObject class]]);

   foo1 = [Foo new];
   foo2 = [Foo new];
   print_bool( [Foo isEqual:foo1]);
   print_bool( [foo1 isEqual:foo2]);
   print_bool( [foo1 isEqual:foo1]);
   print_bool( [foo2 isEqual:foo2]);

   [foo2 release];
   [foo1 release];
}

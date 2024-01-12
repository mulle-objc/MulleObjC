#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjC/MulleObjC.h>
#endif


@interface Foo : NSObject
@end

@interface Bar : Foo
@end

@implementation Foo
@end

@implementation Bar
@end


static void print_bool( BOOL flag)
{
   printf( "%s\n", flag ? "YES" : "NO");
}

int  main( void)
{
   Foo   *foo;
   Bar   *bar;

   printf("NSObject:\n");
   print_bool( [NSObject isMemberOfClass:Nil]);
   print_bool( [NSObject isMemberOfClass:[NSObject class]]);
   print_bool( [[NSObject class] isMemberOfClass:[NSObject class]]);

   printf("\nFoo:\n");
   print_bool( [Foo isMemberOfClass:[NSObject class]]);
   print_bool( [Foo isMemberOfClass:[Foo class]]);
   print_bool( [Foo isMemberOfClass:[Bar class]]);

   printf("\nBar:\n");
   print_bool( [Bar isMemberOfClass:[NSObject class]]);
   print_bool( [Bar isMemberOfClass:[Foo class]]);
   print_bool( [Bar isMemberOfClass:[Bar class]]);

   foo = [Foo new];

   printf("\nfoo:\n");
   print_bool( [foo isMemberOfClass:[NSObject class]]);
   print_bool( [foo isMemberOfClass:[Foo class]]);
   print_bool( [foo isMemberOfClass:[Bar class]]);

   bar = [Bar new];

   printf("\nbar:\n");
   print_bool( [bar isMemberOfClass:[NSObject class]]);
   print_bool( [bar isMemberOfClass:[Foo class]]);
   print_bool( [bar isMemberOfClass:[Bar class]]);

   print_bool( [bar isMemberOfClass:foo]);

   [bar release];
   [foo release];
}

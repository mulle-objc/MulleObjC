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
   print_bool( [NSObject isKindOfClass:Nil]);
   print_bool( [NSObject isKindOfClass:[NSObject class]]);

   printf("\nFoo:\n");
   print_bool( [Foo isKindOfClass:[NSObject class]]);
   print_bool( [Foo isKindOfClass:[Foo class]]);
   print_bool( [Foo isKindOfClass:[Bar class]]);

   printf("\nBar:\n");
   print_bool( [Bar isKindOfClass:[NSObject class]]);
   print_bool( [Bar isKindOfClass:[Foo class]]);
   print_bool( [Bar isKindOfClass:[Bar class]]);

   foo = [Foo new];

   printf("\nfoo:\n");
   print_bool( [foo isKindOfClass:[NSObject class]]);
   print_bool( [foo isKindOfClass:[Foo class]]);
   print_bool( [foo isKindOfClass:[Bar class]]);

   bar = [Bar new];

   printf("\nbar:\n");
   print_bool( [bar isKindOfClass:[NSObject class]]);
   print_bool( [bar isKindOfClass:[Foo class]]);
   print_bool( [bar isKindOfClass:[Bar class]]);

   print_bool( [bar isKindOfClass:foo]);

   [bar release];
   [foo release];
}

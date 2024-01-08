#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjC/MulleObjC.h>
#endif

@protocol FooBar
@end

@interface Foo : NSObject < FooBar>
@end

@implementation Foo
@end

@interface Bar : Foo
@end

@implementation Bar : Foo
@end


static void print_bool( BOOL flag)
{
   printf( "%s\n", flag ? "YES" : "NO");
}

int  main( void)
{
   id     obj;
   Foo   *foo;
   Bar   *bar;

   printf("NSObject:\n");
   print_bool( [NSObject mulleContainsProtocol:@protocol( FooBar)]);

   printf("\nFoo:\n");
   print_bool( [Foo mulleContainsProtocol:@protocol( FooBar)]);

   printf("\nBar:\n");
   print_bool( [Bar mulleContainsProtocol:@protocol( FooBar)]);


   printf("\nobj:\n");
   obj = [NSObject new];
   print_bool( [obj mulleContainsProtocol:@protocol( FooBar)]);

   printf("\nfoo:\n");
   foo = [Foo new];
   print_bool( [foo mulleContainsProtocol:@protocol( FooBar)]);

   printf("\nbar:\n");
   bar = [Bar new];
   print_bool( [bar mulleContainsProtocol:@protocol( FooBar)]);

   [bar release];
   [foo release];
   [obj release];
}

#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjC/MulleObjC.h>
#endif


@interface Foo : NSObject
@end

@interface Bar : Foo
@end

@interface XXX : NSObject
@end


@implementation Foo
@end

@implementation Bar
@end

@implementation XXX
@end



static void print_bool( BOOL flag)
{
   printf( "%s\n", flag ? "YES" : "NO");
}

int  main( void)
{
   Foo   *foo;
   Bar   *bar;
   XXX   *xxx;

   printf("NSObject:\n");
   print_bool( [NSObject isKindOfClass:Nil]);
   print_bool( [NSObject isKindOfClass:[NSObject class]]);

   printf("\nFoo:\n");
   print_bool( [Foo isKindOfClass:[NSObject class]]);
   print_bool( [Foo isKindOfClass:[Foo class]]);
   print_bool( [Foo isKindOfClass:[Bar class]]);
   print_bool( [Foo isKindOfClass:[XXX class]]);

   printf("\nBar:\n");
   print_bool( [Bar isKindOfClass:[NSObject class]]);
   print_bool( [Bar isKindOfClass:[Foo class]]);
   print_bool( [Bar isKindOfClass:[Bar class]]);
   print_bool( [Bar isKindOfClass:[XXX class]]);

   printf("\nXXX:\n");
   print_bool( [XXX isKindOfClass:[NSObject class]]);
   print_bool( [XXX isKindOfClass:[Foo class]]);
   print_bool( [XXX isKindOfClass:[Bar class]]);
   print_bool( [XXX isKindOfClass:[XXX class]]);

   foo = [Foo new];

   printf("\nfoo:\n");
   print_bool( [foo isKindOfClass:[NSObject class]]);
   print_bool( [foo isKindOfClass:[Foo class]]);
   print_bool( [foo isKindOfClass:[Bar class]]);
   print_bool( [foo isKindOfClass:[XXX class]]);

   bar = [Bar new];

   printf("\nbar:\n");
   print_bool( [bar isKindOfClass:[NSObject class]]);
   print_bool( [bar isKindOfClass:[Foo class]]);
   print_bool( [bar isKindOfClass:[Bar class]]);
   print_bool( [bar isKindOfClass:[XXX class]]);


   xxx = [XXX new];

   printf("\nxxx:\n");
   print_bool( [xxx isKindOfClass:[NSObject class]]);
   print_bool( [xxx isKindOfClass:[Foo class]]);
   print_bool( [xxx isKindOfClass:[Bar class]]);
   print_bool( [xxx isKindOfClass:[XXX class]]);

   printf("\nfails:\n");

   print_bool( [foo isKindOfClass:bar]);
   print_bool( [bar isKindOfClass:foo]);

   print_bool( [foo isKindOfClass:xxx]);
   print_bool( [xxx isKindOfClass:foo]);

   print_bool( [bar isKindOfClass:xxx]);
   print_bool( [xxx isKindOfClass:bar]);


   [xxx release];
   [bar release];
   [foo release];
   return( 0);
}

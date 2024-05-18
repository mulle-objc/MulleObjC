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
   // On Apple this prints NO too
   print_bool( [NSObject isMemberOfClass:Nil]);
   // On Apple this prints NO too
   print_bool( [NSObject isMemberOfClass:[NSObject class]]);

   printf("\nFoo:\n");
   print_bool( [Foo isMemberOfClass:[NSObject class]]);
   print_bool( [Foo isMemberOfClass:[Foo class]]);
   print_bool( [Foo isMemberOfClass:[Bar class]]);
   print_bool( [Foo isMemberOfClass:[XXX class]]);

   printf("\nBar:\n");
   print_bool( [Bar isMemberOfClass:[NSObject class]]);
   print_bool( [Bar isMemberOfClass:[Foo class]]);
   print_bool( [Bar isMemberOfClass:[Bar class]]);
   print_bool( [Bar isMemberOfClass:[XXX class]]);

   printf("\nXXX:\n");
   print_bool( [XXX isMemberOfClass:[NSObject class]]);
   print_bool( [XXX isMemberOfClass:[Foo class]]);
   print_bool( [XXX isMemberOfClass:[Bar class]]);
   print_bool( [XXX isMemberOfClass:[XXX class]]);

   foo = [Foo new];

   printf("\nfoo:\n");
   print_bool( [foo isMemberOfClass:[NSObject class]]);
   print_bool( [foo isMemberOfClass:[Foo class]]);
   print_bool( [foo isMemberOfClass:[Bar class]]);
   print_bool( [foo isMemberOfClass:[XXX class]]);

   bar = [Bar new];

   printf("\nbar:\n");
   print_bool( [bar isMemberOfClass:[NSObject class]]);
   print_bool( [bar isMemberOfClass:[Foo class]]);
   print_bool( [bar isMemberOfClass:[Bar class]]);
   print_bool( [bar isMemberOfClass:[XXX class]]);


   xxx = [XXX new];

   printf("\nxxx:\n");
   print_bool( [xxx isMemberOfClass:[NSObject class]]);
   print_bool( [xxx isMemberOfClass:[Foo class]]);
   print_bool( [xxx isMemberOfClass:[Bar class]]);
   print_bool( [xxx isMemberOfClass:[XXX class]]);

   printf("\nfails:\n");

   print_bool( [foo isMemberOfClass:bar]);
   print_bool( [bar isMemberOfClass:foo]);

   print_bool( [foo isMemberOfClass:xxx]);
   print_bool( [xxx isMemberOfClass:foo]);

   print_bool( [bar isMemberOfClass:xxx]);
   print_bool( [xxx isMemberOfClass:bar]);


   [xxx release];
   [bar release];
   [foo release];
   return( 0);
}

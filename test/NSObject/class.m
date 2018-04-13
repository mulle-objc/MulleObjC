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


main()
{
   Foo   *foo;
   Bar   *bar;

   printf("NSObject:\n");
   print_bool( [NSObject class] != Nil);
   print_bool( [NSObject class] == [NSObject class]);
   print_bool( [[NSObject class] class] == [NSObject class]);

   printf("\nFoo:\n");
   print_bool( [Foo class] != Nil);
   print_bool( [Foo class] != [NSObject class]);
   print_bool( [Foo class] == [Foo class]);

   printf("\nBar:\n");
   print_bool( [Bar class] != Nil);
   print_bool( [Bar class] != [NSObject class]);
   print_bool( [Bar class] != [Foo class]);
   print_bool( [Bar class] == [Bar class]);

   foo = [Foo new];

   printf("\nfoo:\n");
   print_bool( [foo class] != Nil);
   print_bool( [foo class] != [NSObject class]);
   print_bool( [foo class] != [Bar class]);
   print_bool( [foo class] == [Foo class]);

   bar = [Bar new];

   printf("\nbar:\n");
   print_bool( [bar class] != Nil);
   print_bool( [bar class] != [NSObject class]);
   print_bool( [bar class] != [Foo class]);
   print_bool( [bar class] == [Bar class]);

   [bar release];
   [foo release];
}

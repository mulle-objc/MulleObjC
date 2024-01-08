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

   print_bool( [NSObject self] != Nil);
   print_bool( [NSObject self] == [NSObject self]);
   print_bool( [NSObject self] == [NSObject class]);

   print_bool( [Foo self] != Nil);
   print_bool( [Foo self] != [NSObject self]);
   print_bool( [Foo self] == [Foo class]);

   print_bool( [Bar self] != Nil);
   print_bool( [Bar self] != [NSObject self]);
   print_bool( [Bar self] != [Foo self]);
   print_bool( [Bar self] == [Bar class]);

   foo = [Foo new];

   print_bool( [foo self] != Nil);
   print_bool( [foo self] != [NSObject self]);
   print_bool( [foo self] != [Bar self]);
   print_bool( [foo self] != [Foo self]);

   bar = [Bar new];

   print_bool( [bar self] != Nil);
   print_bool( [bar self] != [NSObject self]);
   print_bool( [bar self] != [Foo self]);
   print_bool( [bar self] != [Bar self]);

   [bar release];
   [foo release];
}

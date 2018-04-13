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

   print_bool( [NSObject superclass] == Nil);

   print_bool( [Foo superclass] == [NSObject class]);
   print_bool( [Bar superclass] == [Foo class]);

   foo = [Foo new];

   print_bool( [foo superclass] == [NSObject class]);

   bar = [Bar new];

   print_bool( [bar superclass] == [Foo class]);

   [bar release];
   [foo release];
}

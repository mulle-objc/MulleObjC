#ifndef __MULLE_OBJC_RUNTIME__
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

   print_bool( [NSObject isSubclassOfClass:Nil]);
   print_bool( [NSObject isSubclassOfClass:[NSObject class]]);

   print_bool( [Foo isSubclassOfClass:[NSObject class]]);
   print_bool( [Foo isSubclassOfClass:[Foo class]]);
   print_bool( [Foo isSubclassOfClass:[Bar class]]);

   print_bool( [Bar isSubclassOfClass:[NSObject class]]);
   print_bool( [Bar isSubclassOfClass:[Foo class]]);
   print_bool( [Bar isSubclassOfClass:[Bar class]]);
}

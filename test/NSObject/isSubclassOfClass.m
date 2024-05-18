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
   printf("NSObject:\n");
   print_bool( [NSObject isSubclassOfClass:Nil]);
   print_bool( [NSObject isSubclassOfClass:[NSObject class]]);

   printf("\nFoo:\n");
   print_bool( [Foo isSubclassOfClass:[NSObject class]]);
   print_bool( [Foo isSubclassOfClass:[Foo class]]);
   print_bool( [Foo isSubclassOfClass:[Bar class]]);
   print_bool( [Foo isSubclassOfClass:[XXX class]]);

   printf("\nBar:\n");
   print_bool( [Bar isSubclassOfClass:[NSObject class]]);
   print_bool( [Bar isSubclassOfClass:[Foo class]]);
   print_bool( [Bar isSubclassOfClass:[Bar class]]);
   print_bool( [Bar isSubclassOfClass:[XXX class]]);

   printf("\nXXX:\n");
   print_bool( [XXX isSubclassOfClass:[NSObject class]]);
   print_bool( [XXX isSubclassOfClass:[Foo class]]);
   print_bool( [XXX isSubclassOfClass:[Bar class]]);
   print_bool( [XXX isSubclassOfClass:[XXX class]]);

   return( 0);
}

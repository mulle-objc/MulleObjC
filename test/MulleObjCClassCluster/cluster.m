#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjC/MulleObjC.h>
#endif


@interface Foo : NSObject < MulleObjCClassCluster>
@end


@interface Bar : Foo
@end


@implementation Foo

- (id) init
{
   [self release];
   return( [Bar new]);
}

@end


@implementation  Bar

- (id) init
{
   return( self);
}

@end


static void print_bool( BOOL flag)
{
   printf( "%s\n", flag ? "YES" : "NO");
}


int  main( void)
{
   Foo   *foo;
   id    obj;

   foo = [Foo alloc]; // this alloc makes the placeholder
   print_bool( [foo isKindOfClass:[Foo class]]);
   print_bool( [foo isKindOfClass:[Bar class]]);
   [foo release];

   foo = [Foo new]; // this alloc makes an instance
   print_bool( [foo isKindOfClass:[Foo class]]);
   print_bool( [foo isKindOfClass:[Bar class]]);
   [foo release];

   // no leaks
   return( 0);
}

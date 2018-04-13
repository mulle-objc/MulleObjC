#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjC/MulleObjC.h>
#endif


@interface Foo : NSProxy
@end


@implementation Foo

+ (id) new
{
   return( NSAllocateObject( self, 0, NULL));
}

- (void) dealloc
{
   return( NSDeallocateObject( self));
}

@end


static void print_bool( BOOL flag)
{
   printf( "%s\n", flag ? "YES" : "NO");
}


main()
{
   Foo   *foo;

   print_bool( [NSProxy isProxy]);

   print_bool( [Foo isProxy]);
   foo = [Foo new];
   print_bool( [foo isProxy]);
   [foo release];
}

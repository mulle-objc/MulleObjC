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
   return( _MulleObjCClassAllocateInstance( self, 0));
}

- (void) dealloc
{
   return( _MulleObjCInstanceFree( self));
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

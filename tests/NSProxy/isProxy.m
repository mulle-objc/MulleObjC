#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjC/MulleObjC.h>
#endif


@interface Foo : NSProxy
@end


@implementation Foo

#ifdef __MULLE_OBJC__
+ (id) new
{
   return( (Foo *) _mulle_objc_class_alloc_instance( (void *) self, NULL));
}

- (void) dealloc
{
   _mulle_objc_object_free( (void *) self, NULL);
}
#endif

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

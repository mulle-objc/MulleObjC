#ifndef __MULLE_OBJC_RUNTIME__
# import <Foundation/Foundation.h>
#else
# import <MulleStandaloneObjC/MulleStandaloneObjC.h>
#endif


@interface Foo : NSProxy
@end


@implementation Foo

#ifdef __MULLE_OBJC_RUNTIME__
+ (id) new
{
   return( (Foo *) _mulle_objc_class_unfailing_alloc_instance( (void *) self, calloc));
}

- (void) dealloc
{
   _mulle_objc_object_free( (void *) self, free);
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

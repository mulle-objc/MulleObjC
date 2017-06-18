#include <mulle_objc_runtime/mulle_objc_runtime.h>

@protocol  Baz
@property long baz;
@end


@interface Foo <Baz>
@end


@implementation Foo

// will not get auto-synthesized

- (int) respondsToSelector:(mulle_objc_methodid_t) sel
{
   struct _mulle_objc_class            *cls;
   mulle_objc_methodimplementation_t   imp;

   cls = _mulle_objc_object_get_isa( self);
   imp = _mulle_objc_class_get_cached_methodimplementation( cls, sel);
   if( imp)
      return( 1);
   if( mulle_objc_class_lookup_method( cls, sel))
      return( 1);
   return( 0);
}

@end


main()
{
   Foo     *foo;

   foo = [Foo new];
   printf( "%s\n", [foo respondsToSelector:@selector( baz)] ? "FAIL" : "PASS");
}

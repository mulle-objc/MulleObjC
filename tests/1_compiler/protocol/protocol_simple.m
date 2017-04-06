#include <mulle_objc/mulle_objc.h>

@protocol  Baz
- (void) baz;
@end

@protocol  Bar
- (void) bar;
@end


@interface Foo <Baz>
@end


@implementation Foo

+ (id) new
{
   return( mulle_objc_class_alloc_instance( self, NULL));
}


- (void) baz
{
}

@end


main()
{
   Foo     *foo;
   Class   cls;

   foo = [Foo new];
   cls =  mulle_objc_object_get_class( foo);
   printf( "Baz: %s\n",
       mulle_objc_class_conforms_to_protocol( cls,
                                              @protocol( Baz)) ? "YES" : "NO");
   printf( "Bar: %s\n",
       mulle_objc_class_conforms_to_protocol( cls,
                                              @protocol( Bar)) ? "YES" : "NO");
}

#include <mulle-objc-runtime/mulle-objc-runtime.h>


@interface Foo
@end


@implementation Foo

+ (id) new
{
   return( (Foo *) mulle_objc_infraclass_alloc_instance( self));
}

- (void) dealloc
{
   _mulle_objc_instance_free( self);
}

@end


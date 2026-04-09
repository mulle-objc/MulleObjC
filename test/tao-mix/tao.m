#include <mulle-objc-runtime/mulle-objc-runtime.h>

#pragma clang diagnostic ignored "-Wobjc-root-class"


@interface Bar
@end


@implementation Bar

+ (id) new
{
   return( (Bar *) mulle_objc_infraclass_alloc_instance( (struct _mulle_objc_infraclass *) self));
}

- (void) dealloc
{
   _mulle_objc_instance_free( self);
}

@end


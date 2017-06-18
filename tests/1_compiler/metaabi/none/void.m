#include <mulle_objc_runtime/mulle_objc_runtime.h>


@interface Foo
@end


@implementation Foo

+ (void) void
{
   printf( "void\n");
}

@end


main()
{
   [Foo void];
}

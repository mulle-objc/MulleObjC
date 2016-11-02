#include <mulle_objc/mulle_objc.h>


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

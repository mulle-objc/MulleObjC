#include <MulleObjC/dependencies.h>


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

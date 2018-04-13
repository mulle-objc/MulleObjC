#include <MulleObjC/dependencies.h>


@interface Foo
@end


main()
{
   [Foo char:'V'
        char:'f'];
}


@implementation Foo

+ (void) char:(char) a
         char:(char) b
{
// it shouldn't crash,, but platform dependent
//   printf( "%c%cL\n", a, b);
}

@end



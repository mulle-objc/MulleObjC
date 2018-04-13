#include <MulleObjC/dependencies.h>


@interface Foo
@end


@implementation Foo

+ (void) long:(long) a
          int:(int) b
         char:(char) c
        float:(float) d
{
   printf( "%ld,%d,%c,%.2f\n", a, b, c, d);
}

@end


main()
{
   [Foo long:-100000
         int:100000
        char:'v'
       float:18.48];
}

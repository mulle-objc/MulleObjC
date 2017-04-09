#import "Foo.h"

#include <stdio.h>


@interface Foo( C2)
@end

@implementation Foo( C2)

+ (void) load
{
    printf( "Foo( C2)\n");
}

+ (SEL *) categoryDependencies
{
   static SEL  dependencies[] =
   {
      @selector( C3),
      0
   };

   return( dependencies);
}

@end

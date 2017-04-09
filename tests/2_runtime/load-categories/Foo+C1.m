#import "Foo.h"

#include <stdio.h>


@interface Foo( C1)
@end

@implementation Foo( C1)

+ (void) load
{
    printf( "Foo( C1)\n");
}

+ (SEL *) categoryDependencies
{
   static SEL  dependencies[] =
   {
      @selector( C2),
      0
   };

   return( dependencies);
}

@end

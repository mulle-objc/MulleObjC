#import "Base.h"

#include <stdio.h>


@class ProtoClass1;
@protocol ProtoClass1;

@interface Base( C1) < ProtoClass1>
@end

@implementation Base( C1)

+ (void) load
{
    printf( "Base( C1)\n");
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

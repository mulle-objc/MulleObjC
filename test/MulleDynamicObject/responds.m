#import <MulleObjC/MulleObjC.h>

#include <stdio.h>


// hmm, the selectors must be registered first before they can be
// called, which is spanner to my plans, so we create them here
// but thats not so good in a real life situation

@interface MulleDynamicObject( Foo)

@property( dynamic, assign) int  myIntValue;

@end


@implementation MulleDynamicObject( Foo)

@dynamic myIntValue;

@end


int  main()
{
   return( [MulleDynamicObject instancesRespondToSelector:@selector( myIntValue)] ? 0 : -1);
}





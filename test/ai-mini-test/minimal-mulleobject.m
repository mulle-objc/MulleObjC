#import <MulleObjC/MulleObjC.h>

@interface Foo : MulleObject
@end

@implementation Foo

- (void) doNothing
{
}

@end

int main( void)
{
   [[Foo instance] doNothing];
   return( 0);
}

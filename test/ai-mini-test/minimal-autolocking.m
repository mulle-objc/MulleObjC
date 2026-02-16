#import <MulleObjC/MulleObjC.h>

@interface Foo : MulleObject < MulleAutolockingObjectProtocols>
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

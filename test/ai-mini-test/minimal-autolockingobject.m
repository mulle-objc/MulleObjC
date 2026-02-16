#import <MulleObjC/MulleObjC.h>

@interface Foo : MulleObject < MulleAutolockingObject>
@end

@implementation Foo

- (void) doNothing:(void *) unused
{
}

@end

int main( void)
{
   [[Foo instance] doNothing:NULL];
   return( 0);
}

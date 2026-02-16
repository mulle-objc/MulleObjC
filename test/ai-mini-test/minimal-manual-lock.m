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
   Foo *obj = [Foo instance];
   
   [obj lock];
   [obj doNothing];
   [obj unlock];
   
   return( 0);
}

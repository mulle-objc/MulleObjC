#import <MulleObjC/MulleObjC.h>

@interface Foo : MulleObject
@end

@implementation Foo
- (void) doNothing
{
}
@end

int main(void)
{
   Foo *foo = [Foo new];
   [foo doNothing];
   [foo release];
   return 0;
}

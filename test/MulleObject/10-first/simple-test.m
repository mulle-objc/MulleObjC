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
   [[Foo new] doNothing];
   return 0;
}

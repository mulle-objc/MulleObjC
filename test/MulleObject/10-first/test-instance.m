#import <MulleObjC/MulleObjC.h>
#import <MulleObjC/MulleObjCDebug.h>

@interface Foo : MulleObject < MulleAutolockingObjectProtocols>
@end

@implementation Foo
- (void) doNothing
{
}
@end

int main(void)
{
   Foo *foo = [Foo instance];
   [foo doNothing];
   return 0;
}

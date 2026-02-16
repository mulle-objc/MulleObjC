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
   fprintf(stderr, "Testing new...\n");
   Foo *foo1 = [Foo new];
   fprintf(stderr, "foo1 = %p\n", foo1);
   [foo1 doNothing];
   fprintf(stderr, "doNothing on new worked\n");
   
   fprintf(stderr, "Testing instance...\n");
   Foo *foo2 = [Foo instance];
   fprintf(stderr, "foo2 = %p\n", foo2);
   
   return 0;
}

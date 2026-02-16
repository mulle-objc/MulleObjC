#import <MulleObjC/MulleObjC.h>

@interface Foo : MulleObject < MulleAutolockingObject>
@end

@implementation Foo

- (void) doSomething:(void *) unused
{
   printf("Method called successfully\n");
}

@end

int main( void)
{
   [[Foo instance] doSomething:NULL];
   return( 0);
}

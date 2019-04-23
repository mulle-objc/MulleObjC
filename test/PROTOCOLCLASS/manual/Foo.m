#import "Foo.h"

@implementation Foo

- (void) doTheFooThing
{
  struct FooIvars   *ivars;

  ivars = [self getFooIvars];
  ivars->a += 1848;
}

@end
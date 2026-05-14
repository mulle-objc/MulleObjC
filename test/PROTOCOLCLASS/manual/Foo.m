#import "Foo.h"

#pragma clang diagnostic ignored "-Wprotocol"

@implementation Foo

- (void) doTheFooThing
{
  struct FooIvars   *ivars;

  ivars = [self getFooIvars];
  ivars->a += 1848;
}

@end
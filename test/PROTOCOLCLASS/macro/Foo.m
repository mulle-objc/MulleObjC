#import "Foo.h"


#pragma clang diagnostic ignored "-Wobjc-root-class"
#pragma clang diagnostic ignored "-Wprotocol"


PROTOCOLCLASS_IMPLEMENTATION( Foo)

- (void) doTheFooThing
{
  struct FooIvars   *ivars;

  ivars = [self getFooIvars];
  ivars->a += 1848;
}

PROTOCOLCLASS_END()

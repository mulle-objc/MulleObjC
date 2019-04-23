#import <MulleObjC/MulleObjC.h>


struct FooIvars
{
   int   a;
};

PROTOCOLCLASS_INTERFACE0( Foo)

- (struct FooIvars *) getFooIvars;
@optional
- (void) doTheFooThing;

PROTOCOLCLASS_END()



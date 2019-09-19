#import <MulleObjC/MulleObjC.h>


struct FooIvars
{
   int   a;
};


_PROTOCOLCLASS_INTERFACE0( Foo)

- (void) doTheFooThing;
- (struct FooIvars *) getFooIvars;

PROTOCOLCLASS_END()



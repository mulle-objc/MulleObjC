#import <MulleObjC/MulleObjC.h>


struct FooIvars
{
   int   a;
};


@mixin  Foo

- (void) doTheFooThing;
- (struct FooIvars *) getFooIvars;

@end



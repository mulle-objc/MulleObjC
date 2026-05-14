#import <MulleObjC/MulleObjC.h>


struct FooIvars
{
   int   a;
};

@mixin Foo
- (struct FooIvars *) getFooIvars;
@optional
- (void) doTheFooThing;
@end


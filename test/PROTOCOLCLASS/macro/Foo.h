#import <MulleObjC/MulleObjC.h>


struct FooIvars
{
   int   a;
};


@protocol_interface  Foo

- (void) doTheFooThing;
- (struct FooIvars *) getFooIvars;

@end



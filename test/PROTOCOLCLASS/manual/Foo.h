#import <MulleObjC/MulleObjC.h>


struct FooIvars
{
   int   a;
};

@class Foo;
@protocol Foo
- (struct FooIvars *) getFooIvars;
@optional
- (void) doTheFooThing;
@end

@interface Foo <Foo>
@end


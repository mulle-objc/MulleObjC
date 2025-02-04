#import <MulleObjC/MulleObjC.h>


// A De Re @property test
//
// Check that an property gets implemented. Most basic test ever.
//
// This is a runtime test
//
@interface Foo : NSObject

@property int   value;

@end


@interface Bar : Foo
@end

@implementation Foo
@end

@implementation Bar
@end


int  main( int argc, char *argv[])
{
   return( [Bar instancesRespondToSelector:@selector( value)] ? 0 : 1);
}

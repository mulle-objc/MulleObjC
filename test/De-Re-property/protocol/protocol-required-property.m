#import <MulleObjC/MulleObjC.h>


// A De Re @property test
//
// Check that a required property in a protocol forces the class to
// implement it.
//
// This is just a compile test.
//
@protocol A
@required
@property int   value;
@end

@interface Foo : NSObject < A>
@end

@implementation Foo
@end

int  main( int argc, char *argv[])
{
   return( 1);
}

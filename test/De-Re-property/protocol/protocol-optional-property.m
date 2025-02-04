#import <MulleObjC/MulleObjC.h>


// A De Re @property test
//
// Check that an optional property needs not to be implemented.
//
// This is a runtime test
//
@protocol A
@optional
@property int   value;
@end

@interface Foo : NSObject < A>
@end

@implementation Foo
@end

int  main( int argc, char *argv[])
{
   return( [Foo instancesRespondToSelector:@selector( value)]);
}

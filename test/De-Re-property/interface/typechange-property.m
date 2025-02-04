#import <MulleObjC/MulleObjC.h>


// A De Re @property test
//
// Check that an property can be redeclared. Will produce some harmless
// warnings unless @dynamic is used.
//
// This is a compile test
//
@interface Foo : NSObject

@property int   value;

@end


@interface Bar : Foo

@property double   value;

@end

@implementation Foo
@end

@implementation Bar
@dynamic value;
@end


int  main( int argc, char *argv[])
{
   return( 0);
}

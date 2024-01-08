#import <MulleObjC/MulleObjC.h>


@interface Foo : NSObject
@end

@implementation Foo
@end



int  main( void)
{
    @autoreleasepool
    {
       [[Foo new] autorelease];
    }
}

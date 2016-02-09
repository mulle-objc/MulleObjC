#import <MulleStandaloneObjC/MulleStandaloneObjC.h>


@interface Foo : NSObject
@end

@implementation Foo
@end



main()
{
    @autoreleasepool
    {
       [[Foo new] autorelease];
    }
}

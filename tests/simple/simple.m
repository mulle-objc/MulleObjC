#import <MulleObjC/MulleObjC.h>


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

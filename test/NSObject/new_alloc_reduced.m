#import <mulle-objc-runtime/mulle-objc-runtime.h>

#pragma clang diagnostic ignored "-Wobjc-root-class"


@interface Foo

@property( retain) Foo  *other;

@end

@implementation Foo
@end



int  main( void)
{
   return( 0);
}

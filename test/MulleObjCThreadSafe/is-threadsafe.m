#import <MulleObjC/MulleObjC.h>

@interface Foo : NSObject <MulleObjCThreadUnsafe>
@end


@implementation Foo
@end


@interface Bar : NSObject <MulleObjCThreadSafe>
@end


@implementation Bar
@end


@interface FooBar : Bar <MulleObjCThreadUnsafe>
@end


@implementation FooBar
@end


@interface BarFoo : Foo <MulleObjCThreadSafe>
@end


@implementation BarFoo
@end

// this just inherits Bar and does not modify protocols: threadsafety as Bar
@interface BarKeeper : Bar 
@end


@implementation BarKeeper
@end

static void   test( Class cls)
{
   id  obj;

   mulle_printf( "+[%s mulleIsThreadSafe:] %btd\n",
                  MulleObjCClassGetNameUTF8String( cls),
                  [cls mulleIsThreadSafe]);
   obj = [cls object];
   mulle_printf( "-[%s mulleIsThreadSafe:] %btd\n",
                 MulleObjCClassGetNameUTF8String( cls),
                 [obj mulleIsThreadSafe]);
}


int main( void)
{
   test( [Foo class]);
   test( [Bar class]);
   test( [FooBar class]);
   test( [BarFoo class]);
   test( [BarKeeper class]);

   return( 0);
}
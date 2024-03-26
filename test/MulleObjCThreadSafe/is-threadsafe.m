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

   return( 0);
}
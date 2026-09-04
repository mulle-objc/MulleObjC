//
// Does retainCount work on a plain MulleObject?
//
#import <MulleObjC/MulleObjC.h>


@interface Foo : MulleObject <MulleAutolockingObjectProtocols>

@end


@implementation Foo

@end


int   main( void)
{
   Foo   *foo;

   foo = [Foo new];
   mulle_printf( "%tu\n", [foo retainCount]);
   [foo release];
   return( 0);
}

//
// Control: normal method definition DOES inherit
// MULLE_OBJC_THREADSAFE_METHOD from protocol declaration
//
#import <MulleObjC/MulleObjC.h>


@interface Foo : MulleObject <MulleAutolockingObjectProtocols>

@end


@implementation Foo

- (NSUInteger) retainCount
{
   return( 42);
}

@end


int   main( void)
{
   Foo   *foo;

   foo = [Foo new];
   mulle_printf( "%tu\n", [foo retainCount]);
   [foo release];
   return( 0);
}

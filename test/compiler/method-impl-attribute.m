//
// Reproducer: @method_implementation should inherit
// MULLE_OBJC_THREADSAFE_METHOD attribute from protocol declaration
//
#import <MulleObjC/MulleObjC.h>


static NSUInteger   my_retainCount( id self, SEL _cmd, void *_param)
{
   return( 42);
}


@interface Foo : MulleObject <MulleAutolockingObjectProtocols>

@end


@implementation Foo

@method_implementation -retainCount = my_retainCount;

@end


int   main( void)
{
   Foo   *foo;

   foo = [Foo new];
   mulle_printf( "%tu\n", [foo retainCount]);
   [foo release];
   return( 0);
}

#import <MulleObjC/MulleObjC.h>
#include <stdio.h>

@interface Foo : NSObject
- (int) add:(int) a to:(int) b;
@end

@implementation Foo
- (int) add:(int) a to:(int) b   { return( a + b); }
@end

static void  *my_imp( Foo *self, mulle_objc_methodid_t _cmd, void *_param)
{
   return( (void *) (intptr_t) 9999);
}

int   main( void)
{
   Foo   *foo = [[Foo new] autorelease];

   // Create invocations with IMP, release them to fill pool
   @autoreleasepool
   {
      int i;
      for( i = 0; i < 8; i++)
      {
         NSInvocation *inv = @invocation( foo,
             - (int) add:(int) a to:(int) b, 1, 2) = (IMP) my_imp;
         (void) inv;
      }
   }

   // Now create a plain invocation — should come from pool with _implementation == NULL
   NSInvocation *inv = @invocation( foo, - (int) add:(int) a to:(int) b, 5, 6);
   [inv invoke];
   int r;
   [inv getReturnValue:&r];
   printf( "%d\n", r);

   return( 0);
}

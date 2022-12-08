#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
extern void  *__forward_mulle_objc_object_call( id, SEL, ...);
#else
# import <MulleObjC/MulleObjC.h>
#endif

struct small
{
   char   data[ 5];
   int    value;
};


@interface Foo : NSObject
@end


@implementation Foo

- (void) foo:(struct small) x
            :(struct small) y
            :(BOOL) z
{
   printf( "x=%s %d\n", x.data, x.value);
   printf( "y=%s %d\n", y.data, y.value);
   printf( "z=%d\n", (int) z);
}

@end


int   main( void)
{
   NSInvocation   *invocation;
   Foo            *foo;
   struct small   x =
   {
      { 'V','f','L', 0 },
      1848
   };

   foo = [Foo object];
   invocation = [NSInvocation mulleInvocationWithTarget:foo
                                              selector:@selector( foo:::), x, x, YES];
   [invocation invoke];

   return( 0);
}



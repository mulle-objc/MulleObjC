#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
# pragma message "this test does not work with Apple Foundation"
#else
# import <MulleObjC/MulleObjC.h>
#endif


//
// MEMO: this is not a "test" per se, it shows how owning a thread, running
//       it on yourself  and retaining it, will lead to a retain loop
//
@interface Foo : NSObject
{
   NSThread   *_thread;
}
@end


@implementation Foo

- (void) function:(id) arg
{
   printf( "%s\n", __PRETTY_FUNCTION__);
}


- (void) run
{
   NSInvocation   *invocation;

   _thread = [[NSThread alloc] initWithTarget:self
                                     selector:@selector( function:)
                                       object:nil];
   [_thread mulleStart];
   invocation = [_thread mulleJoin];
   assert( [invocation target] == self);
   assert( [invocation selector] == @selector( function:));
}


- (void) dealloc
{
   [_thread release];
   [super dealloc];
}

@end


int main( void)
{
   Foo   *foo;

   foo = [Foo object];
   [foo run];

   return( 0);
}

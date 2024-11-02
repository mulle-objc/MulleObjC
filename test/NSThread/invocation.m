#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
# pragma message "this test does not work with Apple Foundation"
#else
# import <MulleObjC/MulleObjC.h>
#endif


//
// MEMO: How you can use the returned invocation from
//       a joined thread to extract a return value
//
@interface Foo : NSObject
{
   NSThread   *_thread;
}
@end


@implementation Foo

- (id) function:(id) arg
{
   printf( "%s\n", __PRETTY_FUNCTION__);
   return( [Foo object]);
}


- (void) run
{
   NSInvocation   *invocation;
   id             returnValue;
   id             other;
   id             arg;

   other   = [Foo object];
   _thread = [[NSThread alloc] initWithTarget:self
                                     selector:@selector( function:)
                                       object:other];
   [_thread mulleStart];
   invocation = [_thread mulleJoin];

   if( [invocation target] != self)
   {
      mulle_printf( "fail target\n");
   }

   if( [invocation selector] != @selector( function:))
   {
      mulle_printf( "fail selector\n");
   }

   [invocation getArgument:&arg atIndex:2];
   if( arg != other)
   {
      mulle_printf( "fail arg\n");
   }

   [invocation getReturnValue:&returnValue];
   if( returnValue == self || returnValue == arg || ! [returnValue isKindOfClass:[Foo class]])
   {
      mulle_printf( "fail returnValue: %@\n", returnValue);
   }
   [returnValue function:nil];
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

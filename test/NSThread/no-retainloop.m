#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
# pragma message "this test does not work with Apple Foundation"
#else
# import <MulleObjC/MulleObjC.h>
#endif


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
   _thread = [[NSThread alloc] initWithTarget:self
                                     selector:@selector( function:)
                                       object:nil];
   [_thread mulleStart];
   [_thread mulleJoin];
   [_thread autorelease];
   _thread = nil;
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

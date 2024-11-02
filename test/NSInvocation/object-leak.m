#import <MulleObjC/MulleObjC.h>


@interface Foo : NSObject
{
   struct mulle_array   _invocations;
}
@end


@implementation Foo

- (instancetype) init
{
   struct mulle_allocator   *allocator;

   allocator = MulleObjCInstanceGetAllocator( self);
   mulle_array_init( &_invocations,
                     0,
                     &MulleObjCContainerRetainKeyCallback,
                     allocator);
   return( self);
}

- (void) finalize
{
   mulle_array_reset( &_invocations);
   [super finalize];
}

- (void) dealloc
{
   mulle_array_done( &_invocations);
   [super dealloc];
}

- (void) printUTF8String:(char *) s
{
   printf( "%s\n", s);
}


- (void) addInvocation:(NSInvocation *) invocation
{
   [invocation retainArguments];
   mulle_array_add( &_invocations, invocation);
}

@end


int   main( void)
{
   Foo            *foo;
   NSInvocation   *invocation;

   @autoreleasepool
   {
      foo        = [Foo object];
      invocation = [NSInvocation mulleInvocationWithTarget:foo
                                                  selector:@selector( printUTF8String:), "Hello"];
      [foo addInvocation:invocation];
      [foo mullePerformFinalize];
   }
   printf( "We're going in, we're going down\n");
   return( 0);
}



#import <MulleObjC/MulleObjC.h>


@interface TestObject : NSObject
{
@public char   _name[ 16];   
}
@end


@implementation TestObject

- (instancetype) retain 
{
   mulle_printf( "%s: %s\n", self->_name, __FUNCTION__);
   return( [super retain]);
}


- (void) release 
{
   mulle_printf( "%s: %s\n", self->_name, __FUNCTION__);
   [super release];
}

- (instancetype) autorelease 
{
   mulle_printf( "%s: %s\n", self->_name, __FUNCTION__);
   return( [super autorelease]);
}

- (void) testMethod:(id) arg
{
}

@end


static void   trace( char *comment, TestObject *target, TestObject *argument)
{
   mulle_printf( "%s:\n", comment);
   mulle_printf( "\t-[target retainCount]   : %td\n", [target retainCount]);
   mulle_printf( "\t-[argument retainCount] : %td\n\n", [argument retainCount]);   
}


int   main( void)
{
   NSInvocation             *invocation;
   TestObject               *target;
   TestObject               *argument;
   struct mulle_pointerset  set;

   @autoreleasepool
   {
      target     = [TestObject object];
      strcpy( target->_name, "target"); 
      argument   = [TestObject object];
      strcpy( argument->_name, "argument"); 

      trace( "creation", target, argument);

      invocation = [NSInvocation mulleInvocationWithTarget:target
                                                   selector:@selector( testMethod:),
                                                   argument];
      trace( "added to invocation", target, argument);

      [invocation mulleRelinquishAccess];
      trace( "after mulleRelinquishAccess", target, argument);

      [invocation mulleGainAccess];
      trace( "after mulleGainAccess", target, argument);
   }

   return( 0);
}
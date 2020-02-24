#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
# pragma message "this test does not work with Apple Foundation"
#else
# import <MulleObjC/MulleObjC.h>
#endif


@interface NSThread( Print)
@end


@implementation NSThread( Print)


- (void) _isProbablyGoingSingleThreaded
{
   printf( "%s\n", __PRETTY_FUNCTION__);
   fflush( stdout);
}


- (void) _isGoingMultiThreaded
{
   printf( "%s\n", __PRETTY_FUNCTION__);
   fflush( stdout);
}


- (void) _threadWillExit
{
   printf( "%s\n", __PRETTY_FUNCTION__);
   fflush( stdout);
}


+ (void) doNothing:(id) obj
{
   printf( "%s\n", __PRETTY_FUNCTION__);
   fflush( stdout);
}


+ (void) sleep1:(id) obj
{
   sleep( 1);
   printf( "%s\n", __PRETTY_FUNCTION__);
   fflush( stdout);
}

@end



int main( void)
{
   printf( "START: %s\n", __FUNCTION__);

   [NSThread detachNewThreadSelector:@selector( doNothing:)
                            toTarget:[NSThread class]
                          withObject:nil];
   [NSThread detachNewThreadSelector:@selector( sleep1:)
                            toTarget:[NSThread class]
                          withObject:nil];
   sleep( 2);
   printf( "STOP: %s\n", __FUNCTION__);
   return( 0);
}

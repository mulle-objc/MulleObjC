#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
# pragma message "this test does not work with Apple Foundation"
#else
# import <MulleObjC/MulleObjC.h>
#endif

#include <unistd.h>


@interface StupidString : NSObject
{
   char  _name[ 128];
}
@end


@implementation StupidString

- (id) initWithCString:(char *) s
{
   strncpy( _name, s, 128);
   _name[ 127] = 0;
   return( self);
}

- (char *) cStringDescription
{
   return( _name);
}

@end


@interface NSThread( Print)
@end


@implementation NSThread( Print)

- (id) userInfo
{
   return( _userInfo);
}

- (void) setUserInfo:(id) obj
{
   _userInfo = [obj retain];
}


- (void) _isProbablyGoingSingleThreaded
{
   printf( "%s %s\n", __PRETTY_FUNCTION__, [[[NSThread currentThread] userInfo] cStringDescription]);
   fflush( stdout);
}


- (void) _isGoingMultiThreaded
{
   printf( "%s %s\n", __PRETTY_FUNCTION__, [[[NSThread currentThread] userInfo] cStringDescription]);
   fflush( stdout);
}


- (void) _threadWillExit
{
   printf( "%s %s\n", __PRETTY_FUNCTION__, [[[NSThread currentThread] userInfo] cStringDescription]);
   fflush( stdout);
}


+ (void) doNothing:(id) obj
{
   [[NSThread currentThread] setUserInfo:[[[StupidString alloc] initWithCString:"nothing"] autorelease]];

   sleep( 1);
   printf( "%s %s\n", __PRETTY_FUNCTION__, [[[NSThread currentThread] userInfo] cStringDescription]);
   fflush( stdout);
}


+ (void) sleep1:(id) obj
{
   [[NSThread currentThread] setUserInfo:[[[StupidString alloc] initWithCString:"sleep"] autorelease]];

   sleep( 2);
   printf( "%s %s\n", __PRETTY_FUNCTION__, [[[NSThread currentThread] userInfo] cStringDescription]);
   fflush( stdout);
}

@end



int main( void)
{
   [[NSThread currentThread] setUserInfo:[[[StupidString alloc] initWithCString:"main"] autorelease]];

   printf( "START: %s\n", __FUNCTION__);

   [NSThread detachNewThreadSelector:@selector( doNothing:)
                            toTarget:[NSThread class]
                          withObject:nil];
   [NSThread detachNewThreadSelector:@selector( sleep1:)
                            toTarget:[NSThread class]
                          withObject:nil];
   sleep( 3);
   printf( "STOP: %s\n", __FUNCTION__);
   return( 0);
}

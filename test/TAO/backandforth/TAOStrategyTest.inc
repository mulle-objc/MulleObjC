#import <MulleObjC/MulleObjC.h>


#define __THREAD_NAME__  [MulleThreadGetCurrentThread() mulleNameUTF8String]

#ifndef TEST_PROTOCOLS
# define TEST_PROTOCOLS
#endif

@interface Foo : NSObject  TEST_PROTOCOLS
@end


@implementation Foo

- (MulleObjCTAOStrategy) mulleTAOStrategy MULLE_OBJC_THREADSAFE_METHOD
{
   return( TEST_TAO_STRATEGY);
}


- (void) release
{
   mulle_printf( "%s - -: %s %td -> %td\n", __THREAD_NAME__, __PRETTY_FUNCTION__, [self retainCount], [self retainCount] - 1);
   [super release];
}


- (id) retain
{
   mulle_printf( "%s - +: %s %td -> %td\n", __THREAD_NAME__,__PRETTY_FUNCTION__, [self retainCount], [self retainCount] + 1);
   [super retain];
   return( self);
}


- (id) autorelease
{
   mulle_printf( "%s - a: %s %td\n", __THREAD_NAME__,__PRETTY_FUNCTION__, [self retainCount]);
   return( [super autorelease]);
}



- (void) dealloc
{
   mulle_printf( "%s - d: %s %td\n", __THREAD_NAME__, __PRETTY_FUNCTION__, [self retainCount]);
   [super dealloc];
}


- (void) mulleGainAccess
{
   [super mulleGainAccess];
   mulle_printf( "%s - g: %s %td\n", __THREAD_NAME__,__PRETTY_FUNCTION__, [self retainCount]);
}


- (void) mulleRelinquishAccess
{
   [super mulleRelinquishAccess];
   mulle_printf( "%s - q: %s %td\n", __THREAD_NAME__,__PRETTY_FUNCTION__, [self retainCount]);
}

@end


static int   thread_function( NSThread *thread, id obj)
{
   mulle_printf( "%s - 3: %s %td\n", __THREAD_NAME__, __PRETTY_FUNCTION__, [obj retainCount]);
   return( 0);
}

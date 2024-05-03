#import <MulleObjC/MulleObjC.h>


@interface Bar : NSObject <MulleObjCThreadSafe>
@end


@implementation Bar

- (void) access
{
}


@end



//
// we only have two threads, otherwise its almost impossible without
// keeping all NSThreads around...
//
static NSThread  *NSThread_for_OSthread( mulle_thread_t arg)
{
   if( ! arg)
      return( nil);
   if( arg == _NSThreadGetOSThread( [NSThread mainThread]))
      return( [NSThread mainThread]);
   return( [NSThread currentThread]);
}



static int  thread_main( NSThread *thread, void *arg)
{
   Class   cls;
   id      obj = arg;

   cls = [obj class];
   mulle_printf( "-[NSThread currentThread] %@\n", [NSThread currentThread]);
   mulle_printf( "-[%@ mulleIsThreadSafe] %btd\n",   cls, [obj mulleIsThreadSafe]);
   mulle_printf( "-[%@ threadAffinity] %@\n",        cls, NSThread_for_OSthread( _mulle_objc_object_get_thread( (struct _mulle_objc_object *) obj)));
   mulle_printf( "-[%@ mulleIsAccessible] %btd\n",   cls, [obj mulleIsAccessible]);

   mulle_printf( "-[%@ mulleIsAccessibleByThread:%@] %btd\n",
                     cls,
                     thread,
                     [obj mulleIsAccessibleByThread:thread]);

   mulle_printf( "-[%@ mulleIsAccessibleByThread:%@] %btd\n",
                     cls,
                     [NSThread mainThread],
                     [obj mulleIsAccessibleByThread:[NSThread mainThread]]);
   [obj access];

   return( 0);
}


void  test( Class cls)
{
   id         obj;
   NSThread   *thread;

   obj = [cls object];
   thread_main( [NSThread mainThread], obj);

   thread = [[[NSThread alloc] mulleInitWithFunction:thread_main
                                            argument:obj] autorelease];
   [thread mulleSetNameUTF8String:"NSThread"];
   [thread mulleStartUndetached];
   [thread mulleJoin];
}


int main( void)
{
   test( [Bar class]);

   return( 0);
}
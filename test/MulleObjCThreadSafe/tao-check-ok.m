#import <MulleObjC/MulleObjC.h>


@interface Bar : NSObject <MulleObjCThreadSafe>
@end


@implementation Bar
@end


static int  thread_main( NSThread *thread, void *arg)
{
   Class   cls;
   id      obj = arg;

   cls = [obj class];
   mulle_printf( "-[%@ mulleIsThreadSafe] %btd\n",   cls, [obj mulleIsThreadSafe]);
   mulle_printf( "-[%@ threadAffinity] %p\n",        cls, _mulle_objc_object_get_thread( (struct _mulle_objc_object *) obj));
   mulle_printf( "-[%@ mulleIsAccessible] %btd\n",   cls, [obj mulleIsAccessible]);

   mulle_printf( "-[%@ mulleIsAccessibleByThread:%@] %btd\n",
                     cls,
                     thread,
                     [obj mulleIsAccessibleByThread:thread]);

   mulle_printf( "-[%@ mulleIsAccessibleByThread:%@] %btd\n",
                     cls,
                     [NSThread mainThread],
                     [obj mulleIsAccessibleByThread:[NSThread mainThread]]);
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
   [thread mulleStartUndetached];
   [thread mulleJoin];
}



int main( void)
{
   test( [Bar class]);

   return( 0);
}
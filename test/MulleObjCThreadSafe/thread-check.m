#import <MulleObjC/MulleObjC.h>


//
// we only have two threads, otherwise its almost impossible without
// keeping all NSThreads around...
//
static NSThread  *NSThread_for_OSthread( mulle_thread_t arg)
{
   if( ! arg)
      return( nil);
   if( arg == MulleThreadObjectGetOSThread( [NSThread mainThread]))
      return( [NSThread mainThread]);
   return( [NSThread currentThread]);
}



int   main( void)
{
   Class      cls;
   NSThread   *obj;
   NSThread   *other;

   cls   = [NSThread class];
   obj   = [NSThread currentThread];
   other = [NSThread mulleThreadWithTarget:obj
                                  selector:@selector( mulleIsAccessibleByThread:)
                                     object:nil];
   [other mulleSetNameUTF8String:"NSThread"];

   mulle_printf( "-[%@ mulleIsThreadSafe] %btd\n",   cls, [obj mulleIsThreadSafe]);
   mulle_printf( "-[%@ threadAffinity] %@\n",        cls, NSThread_for_OSthread( _mulle_objc_object_get_thread( (struct _mulle_objc_object *) obj)));
   mulle_printf( "-[%@ mulleIsAccessible] %btd\n",   cls, [obj mulleIsAccessible]);

   mulle_printf( "-[%@ mulleIsAccessibleByThread:%@] %btd\n",
                     cls,
                     obj,
                     [obj mulleIsAccessibleByThread:obj]);

   mulle_printf( "-[%@ mulleIsAccessibleByThread:%@] %btd\n",
                     cls,
                     other,
                     [obj mulleIsAccessibleByThread:other]);

   mulle_printf( "-[%@ mulleIsAccessibleByThread:%@] %btd\n",
                     cls,
                     [NSThread mainThread],
                     [obj mulleIsAccessibleByThread:[NSThread mainThread]]);
   return( 0);
}


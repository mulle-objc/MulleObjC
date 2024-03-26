#import <MulleObjC/MulleObjC.h>


int main( void)
{
   Class      cls;
   NSThread   *obj;
   NSThread   *other;

   cls   = [NSThread class];
   obj   = [NSThread currentThread];
   other = [NSThread mulleThreadWithTarget:obj
                                  selector:@selector( self)
                                     object:nil];

   mulle_printf( "-[%@ mulleIsThreadSafe] %btd\n",   cls, [obj mulleIsThreadSafe]);
   mulle_printf( "-[%@ threadAffinity] %p\n",        cls, _mulle_objc_object_get_thread( (struct _mulle_objc_object *) obj));
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


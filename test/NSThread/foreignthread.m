#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
# pragma message "this test does not work with Apple Foundation"
#else
# import <MulleObjC/MulleObjC.h>
#endif


static mulle_thread_rval_t   function( void *arg)
{
   NSAutoreleasePool   *pool;
   NSThread            *currentThread;
   NSThread            *mainThread;

   mulle_fprintf( stderr, "function::NSPushAutoreleasePool\n");
   pool = NSPushAutoreleasePool( 0);
   {
      mulle_fprintf( stderr, "function::check stuff 1\n");
      currentThread = [NSThread currentThread];
      mulle_printf( "[NSThread currentThread] is %snil\n",
                     currentThread == nil ? "" : "not ");
      mainThread = [NSThread mainThread];
      mulle_fprintf( stderr, "function::check stuff 2\n");
      mulle_printf( "[NSThread currentThread] is %s[NSThread mainThread]\n",
                     currentThread == mainThread ? "" : "not ");
   }
   mulle_fprintf( stderr, "function::NSPopAutoreleasePool\n");
   NSPopAutoreleasePool( pool);
   mulle_fprintf( stderr, "function::exit\n");

   mulle_thread_return();
}


int main( void)
{
   mulle_thread_t    thread;

   mulle_fprintf( stderr, "Create thread\n");
   if( mulle_thread_create( function, NULL, &thread))
      return( 1);

   mulle_fprintf( stderr, "Join thread\n");
   mulle_thread_join( thread);
   mulle_fprintf( stderr, "Exit\n");
   return( 0);
}

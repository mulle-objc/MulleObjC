#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
# pragma message "this test does not work with Apple Foundation"
#else
# import <MulleObjC/MulleObjC.h>
#endif


static mulle_thread_rval_t   function( void *arg)
{
   NSAutoreleasePool   *pool;

   fprintf( stderr, "function::NSPushAutoreleasePool\n");
   pool = NSPushAutoreleasePool( 0);
   {
      fprintf( stderr, "function::check stuff\n");
      printf( "[NSThread currentThread] is %snil\n",
                  [NSThread currentThread] == nil ? "" : "not ");
      printf( "[NSThread currentThread] is %s[NSThread mainThread]\n",
                  [NSThread currentThread] == [NSThread mainThread] ? "" : "not ");
   }
   fprintf( stderr, "function::NSPopAutoreleasePool\n");
   NSPopAutoreleasePool( pool);
   fprintf( stderr, "function::exit\n");

   mulle_thread_return();
}


int main( void)
{
   mulle_thread_t    thread;

   fprintf( stderr, "Create thread\n");
   if( mulle_thread_create( function, NULL, &thread))
      return( 1);

   fprintf( stderr, "Join thread\n");
   mulle_thread_join( thread);
   return( 0);
}

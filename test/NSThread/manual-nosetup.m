#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
# pragma message "this test does not work with Apple Foundation"
#else
# import <MulleObjC/MulleObjC.h>
# import <MulleObjC/private/mulle-objc-universefoundationinfo-private.h>
#endif



// this doesn't work, because the thread is not yet registered
// wont't work in release, as the assert will not trigger

static void  function( void *universe)
{
//   thread = _MulleThreadCreateThreadObjectInUniverse( universe);
   [[NSObject new] autorelease];

   // we just run into the end of the thread, which should be OK
//   _MulleThreadRemoveFromUniverse( thread, universe);
}


int   main( void)
{
   mulle_thread_t                thread;
   struct _mulle_objc_universe   *universe;

   universe = mulle_objc_global_get_defaultuniverse();

   mulle_thread_create( function, universe, &thread);
   mulle_thread_join( thread);

   return( 0);
}

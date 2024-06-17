#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
# pragma message "this test does not work with Apple Foundation"
#else
# import <MulleObjC/MulleObjC.h>
# import <MulleObjC/mulle-objc-universefoundationinfo-private.h>
#endif


int  main( void)
{
   NSThread                                    *thread;
   struct _mulle_objc_universefoundationinfo   *info;
   struct _mulle_objc_universe                 *universe;
   intptr_t                                    n_threads;

   universe  = mulle_objc_global_get_defaultuniverse();
   info      = _mulle_objc_universe_get_universefoundationinfo( universe);
   n_threads = (intptr_t) _mulle_atomic_pointer_read( &info->thread.n_threads);
   if( n_threads != 0)
      return( 1);

   thread = [NSThread currentThread];  // it should be available already
   if( ! thread)
   {
      printf( "missing NSThread in universe %p\n", universe);
      return( 1);
   }

   fprintf( stderr, "1\n");

   //
   // thread must not be a rootobject
   // thread must be a rootthreadobject
   //
   if( mulle_set_get( info->object.roots, thread))
   {
      printf( "is mistakingly a root object\n");
      return( 1);
   }

   if( ! mulle_map_get( info->object.threads, (void *) MulleThreadObjectGetOSThread( thread)))
   {
      printf( "is mistakingly not a root thread object\n");
      return( 1);
   }
   fprintf( stderr, "2\n");
   _mulle_objc_universe_release( universe);
   fprintf( stderr, "3\n");

   // DANGEROUS!
   if( _mulle_atomic_pointer_read( &info->thread.n_threads) != (void *) 0)
   {
      printf( "still running\n");
      return( 1);
   }

   fprintf(  stderr, "4\n");
   return( 0);
}

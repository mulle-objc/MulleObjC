//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#include <errno.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>


static void  rval_perror( char *s, int rval)
{
   errno = rval;
   perror( s);
}


static void  rval_perror_abort( char *s, int rval)
{
   rval_perror( s, rval);
   abort();
}



int   main( int argc, const char * argv[])
{
   pthread_mutex_t   lock;
   int               rval;

   pthread_mutex_init( &lock, NULL);
   {
      rval = pthread_mutex_trylock( &lock);
      if( rval)
      {
         rval_perror_abort( "pthread_mutex_trylock", rval);
      }

      rval = pthread_mutex_trylock( &lock);
      if( ! rval)
      {
         mulle_fprintf( stderr, "unexpected success\n");
         abort();
      }
      rval_perror( "pthread_mutex_trylock", rval);

      rval = pthread_mutex_unlock( &lock);
      if( rval)
         rval_perror_abort( "pthread_mutex_unlock", rval);
   }
   pthread_mutex_destroy( &lock);

   return( 0);
}

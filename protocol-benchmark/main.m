//
//  main.m
//  bench-protocols
//
//  Created by Nat! on 29/05/17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
//
#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
typedef Protocol  *PROTOCOL;
#else
# import <MulleObjC/MulleObjC.h>
#endif

#include <sys/time.h>
#include <stdarg.h>


// reduce INNER LOOPS so that apple runtime returns within human boredom limits
#if 0
#define LOOPS         2
#define INNER_LOOPS   100000
#else
# define LOOPS         1
# define INNER_LOOPS   100000
#endif

@protocol exists
@end

@protocol miss // not on Foo
@end


@interface Foo : NSObject
@end


@implementation Foo
@end


//
// add 1000 protocols to Foo
//
#include "protocols.inc"

// place at back :)
@interface Foo ( Exists) < exists>
@end


@implementation Foo( Exists)
@end



static void   test_Foo_conformance( unsigned long n, va_list args)
{
   unsigned long   i;
   unsigned long   j;
   PROTOCOL        proto;

   proto = va_arg( args, PROTOCOL);
   if( ! proto)
      abort();

   for( i = 0; i < n; i++)
      for( j = 0; j < INNER_LOOPS; j++)
      {
         [Foo conformsToProtocol:proto];
      }
}


#pragma mark -
#pragma test environment

static struct timeval   print_w_timestamp( char *format, ...)
{
   char             buf[256];
   struct timeval   tv;
   struct tm        *loctime;
   time_t           curtime;
   va_list          args;

   gettimeofday( &tv, NULL);

   curtime = tv.tv_sec;
   loctime = localtime( &curtime);

   strftime( buf, sizeof( buf), "%H:%M:%S", loctime);
   fprintf( stderr, "%s.%06lu: ", buf, (unsigned long) tv.tv_usec);

   va_start( args, format);
   vfprintf( stderr, format, args);
   va_end( args);

   return( tv);
}


static long   elapsed_us( struct timeval start, struct timeval stop)
{
   long    us;
   long    elapsed;
   int     carry;

   if( carry = stop.tv_usec < start.tv_usec)
      us = 1000000 - start.tv_usec + stop.tv_usec;
   else
      us = stop.tv_usec - start.tv_usec;

   elapsed = (stop.tv_sec - start.tv_sec - carry) * 1000000 + us;
   return( elapsed);
}


static void   run_test( char *title, int noheader, void (*f)( unsigned long, va_list), ...)
{
   va_list          args;
   va_list          tmp;
   struct timeval   start;
   struct timeval   end;
   long             us;

   // warmup

   va_start( args, f);

   va_copy( tmp, args);
   (*f)( 1, tmp);
   va_end( tmp);

   start = print_w_timestamp( "start %s\n", title);
   (*f)( LOOPS, args);
   end   = print_w_timestamp( "end %s\n\n", title);
   va_end( args);

   us = elapsed_us( start, end);
   if( noheader)
      printf( "%ld\n", us);  // ; for "Numbers.app"
   else
      printf( "%s;%ld\n", title, us);  // ; for "Numbers.app"
}


int   main( int argc, char  *argv[])
{
   int   noheader;

   noheader = argc == 2 && ! strcmp( argv[ 1], "--noheader");

   if( ! [Foo conformsToProtocol:@protocol( exists)])
   {
      printf( "exists fail\n");
      return( 1);
   }
   if( [Foo conformsToProtocol:@protocol( miss)])
   {
      printf( "miss fail\n");
      return( 1);
   }

   run_test( "-conformsToProtocol: YES", noheader, (void *) test_Foo_conformance, @protocol( exists));
   run_test( "-conformsToProtocol: NO", noheader, (void *) test_Foo_conformance, @protocol( miss));

   return( 0);
}


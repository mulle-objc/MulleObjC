//
//  main.m
//  test-foundation
//
//  Created by Nat! on 19/10/15.
//  Copyright © 2015 Mulle kybernetiK. All rights reserved.
//
#ifndef __MULLE_RUNTIME__
# import <Foundation/Foundation.h>
#else
# import <MulleStandaloneObjC/MulleStandaloneObjC.h>
#endif

#include <sys/time.h>


#define LOOPS   10


@interface Bar : NSObject
@end


@implementation Bar

+ (void) doNoParam
{
}


- (void) doNoParam
{
}


- (void) doOneParam:(id) a
{
}


- (void) doTwoParam:(id)a :(id) b
{
}


- (void) doThreeParam:(id)a :(id) b :(id) c
{
}


- (void) doFourParam:(id)a :(id) b :(id) c :(id) d
{
}


@end


@interface Foo : Bar

- (id) doStuff:(id) a
             b:(id) b
             c:(id) c;

@end


@implementation Foo

+ (void) doSuperNoParam
{
   [super doNoParam];
}


- (void) doSuperNoParam
{
   [super doNoParam];
}


# pragma mark -

- (id) doStuff:(id) a
             b:(id) b
             c:(id) c
{
   return( a);
}


- (id) doStuff:(id) a
             b:(id) b
{
   return( [self doStuff:a
                       b:b
                       c:nil]);
}


- (id) doStuff:(id) a
{
   return( [self doStuff:a
                       b:a]);
}


- (id) doStuff
{
   return( [self doStuff:nil]);
}

# pragma mark -

+ (id) doStuff:(id) a
             b:(id) b
             c:(id) c
{
   return( a);
}


+ (id) doStuff:(id) a
             b:(id) b
{
   return( [self doStuff:a
                       b:b
                       c:nil]);
}


+ (id) doStuff:(id) a
{
   return( [self doStuff:a
                       b:a]);
}


+ (id) doStuff
{
   return( [self doStuff:nil]);
}

@end


static void   doNoParam( unsigned long n, va_list args)
{
   unsigned long   i;
   unsigned long   j;
   id              obj;
   
   obj = va_arg( args, id);
   for( i = 0; i < n; i++)
      for( j = 0; j < 10000000; j++)
      {
         [obj doNoParam];
      }
}


static void   doOneParam( unsigned long n, va_list args)
{
   unsigned long   i;
   unsigned long   j;
   id              obj;
   id              a;
   
   obj = va_arg( args, id);
   a   = va_arg( args, id);
   for( i = 0; i < n; i++)
      for( j = 0; j < 10000000; j++)
         [obj doOneParam:a];
}


static void   doTwoParam( unsigned long n, va_list args)
{
   unsigned long   i;
   unsigned long   j;
   id              obj;
   id              a, b;
   
   obj = va_arg( args, id);
   a   = va_arg( args, id);
   b   = va_arg( args, id);
   for( i = 0; i < n; i++)
      for( j = 0; j < 10000000; j++)
      {
         [obj doTwoParam:a :b];
      }
}


static void   doThreeParam( unsigned long n, va_list args)
{
   unsigned long   i;
   unsigned long   j;
   id              obj;
   id              a, b, c;
   
   obj = va_arg( args, id);
   a   = va_arg( args, id);
   b   = va_arg( args, id);
   c   = va_arg( args, id);
   for( i = 0; i < n; i++)
      for( j = 0; j < 10000000; j++)
      {
         [obj doThreeParam:a :b :c];
      }
}


static void   doFourParam( unsigned long n, va_list args)
{
   unsigned long   i;
   unsigned long   j;
   id              obj;
   id              a, b, c, d;
   
   obj = va_arg( args, id);
   a   = va_arg( args, id);
   b   = va_arg( args, id);
   c   = va_arg( args, id);
   d   = va_arg( args, id);
   for( i = 0; i < n; i++)
      for( j = 0; j < 10000000; j++)
      {
         [obj doFourParam:a :b :c :d];
      }
}


static void   doNoParamClass( unsigned long n, va_list unused)
{
   unsigned long   i;
   unsigned long   j;
   
   for( i = 0; i < n; i++)
      for( j = 0; j < 10000000; j++)
      {
         [Foo doNoParam];
      }
}


static void   doSuperNoParam( unsigned long n, va_list args)
{
   unsigned long   i;
   unsigned long   j;
   id              obj;
   
   obj = va_arg( args, id);
   for( i = 0; i < n; i++)
      for( j = 0; j < 10000000; j++)
      {
         [obj doSuperNoParam];
      }
}


static void   doSuperNoParamClass( unsigned long n, va_list unused)
{
   unsigned long   i;
   unsigned long   j;
   
   for( i = 0; i < n; i++)
      for( j = 0; j < 10000000; j++)
      {
         [Foo doSuperNoParam];
      }
}



static void   doStuff( unsigned long n, va_list args)
{
   unsigned long   i;
   unsigned long   j;
   id              obj;
   
   obj = va_arg( args, id);
   for( i = 0; i < n; i++)
      for( j = 0; j < 10000000; j++)
      {
         [obj doStuff];
      }
}


static void   doStuffClass( unsigned long n, va_list unused)
{
   unsigned long   i;
   unsigned long   j;
   
   for( i = 0; i < n; i++)
      for( j = 0; j < 10000000; j++)
      {
         [Foo doStuff];
      }
}


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
      printf( "%ld\n", title, us);  // ; for "Numbers.app"
   else
      printf( "%s;%ld\n", title, us);  // ; for "Numbers.app"
}


int   main( int argc, char  *argv[])
{
   Foo   *foo;
   int   noheader;
   
   foo = [Foo new];
   
   noheader = argc == 2 && ! strcmp( argv[ 1], "--noheader");
   run_test( "-doNoParam", noheader, (void *) doNoParam, foo);
   run_test( "+doNoParam", noheader, (void *) doNoParamClass, nil);

   run_test( "-doOneParam", noheader, (void *) doOneParam, foo, nil);
   run_test( "-doTwoParam", noheader, (void *) doTwoParam, foo, nil, nil);
   run_test( "-doThreeParam", noheader, (void *) doThreeParam, foo, nil, nil, nil);
   run_test( "-doFourParam", noheader, (void *) doFourParam, foo, nil, nil, nil, nil);

   run_test( "-doSuperNoParam", noheader, (void *) doSuperNoParam, foo);
   run_test( "+doSuperNoParam", noheader, (void *) doSuperNoParamClass, nil);

   run_test( "-doStuff", noheader, (void *) doStuff, foo);
   run_test( "+doStuff", noheader, (void *) doStuffClass, foo);

   return 0;
}


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
# import "MulleStandaloneObjC.h"
#endif

#include <sys/time.h>




@interface Foo : NSObject

- (id) doStuff:(id) a
             b:(id) b
             c:(id) c;

@end


@implementation Foo

- (void) talk
{
   printf( "hello world\n");
}


+ (void) doNothing
{
}


- (void) doNothing
{
}


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


@end


void  print_w_timestamp( char *format, ...)
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
   printf( "%s.%06lu: ", buf, (unsigned long) tv.tv_usec);
   
   va_start( args, format);
   vprintf( format, args);
   va_end( args);
}


int   main( int argc, char  *argv[])
{
   Foo             *foo;
   unsigned long   i;
   unsigned long   j;
   
   foo = [Foo new];
   print_w_timestamp( "start\n");
   for( i = 0; i < 10; i++)
      for( j = 0; j < 10000000; j++)
      {
         [foo doNothing];
      }
   print_w_timestamp( "end\n");

#ifndef __OBJC2__
   [foo release];
#endif
   return 0;
}


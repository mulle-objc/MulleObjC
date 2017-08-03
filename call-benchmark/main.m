//
//  main.m
//  test-foundation
//
//  Created by Nat! on 19/10/15.
//  Copyright © 2015 Mulle kybernetiK. All rights reserved.
//
#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjC/MulleObjC.h>

//
// this class is fast in MulleObjC but not in Apple
//
@interface NSMutableDictionary : NSObject
@end

@implementation NSMutableDictionary
@end


//
// this class is fast in MulleObjC and in Apple
//
@interface NSNumber : NSObject
@end

@implementation NSNumber
@end

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


static void   test_self( unsigned long n, va_list args)
{
   unsigned long   i;
   unsigned long   j;
   id              obj;

   obj = va_arg( args, id);
   for( i = 0; i < n; i++)
      for( j = 0; j < 10000000; j++)
      {
         [obj self];
      }
}


static void   test_class( unsigned long n, va_list args)
{
   unsigned long   i;
   unsigned long   j;
   id              obj;

   obj = va_arg( args, id);
   for( i = 0; i < n; i++)
      for( j = 0; j < 10000000; j++)
      {
         [obj class];
      }
}


static void   test_retainRelease( unsigned long n, va_list args)
{
   unsigned long   i;
   unsigned long   j;
   id              obj;

   obj = va_arg( args, id);
   for( i = 0; i < n; i++)
      for( j = 0; j < 10000000; j++)
      {
         [[obj retain] release];
      }
}


static void   test_doNoParam( unsigned long n, va_list args)
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


static void   test_doOneParam( unsigned long n, va_list args)
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


static void   test_doTwoParam( unsigned long n, va_list args)
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


static void   test_doThreeParam( unsigned long n, va_list args)
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


static void   test_doFourParam( unsigned long n, va_list args)
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


static void   test_doSuperNoParam( unsigned long n, va_list args)
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


static void   test_doStuff( unsigned long n, va_list args)
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

#pragma mark -
#pragma mark Classes hardcoded


static void   test_Foo_self( unsigned long n, va_list unused)
{
   unsigned long   i;
   unsigned long   j;

   for( i = 0; i < n; i++)
      for( j = 0; j < 10000000; j++)
      {
         [Foo self];
      }
}


static void   test_Foo_class( unsigned long n, va_list unused)
{
   unsigned long   i;
   unsigned long   j;

   for( i = 0; i < n; i++)
      for( j = 0; j < 10000000; j++)
      {
         [Foo class];
      }
}


static void   test_Foo_newRelease( unsigned long n, va_list args)
{
   unsigned long   i;
   unsigned long   j;
   id              obj;

   obj = va_arg( args, id);
   for( i = 0; i < n; i++)
      for( j = 0; j < 10000000; j++)
      {
         [[Foo new] release];
      }
}


static void  test_Foo_doNoParam( unsigned long n, va_list unused)
{
   unsigned long   i;
   unsigned long   j;

   for( i = 0; i < n; i++)
      for( j = 0; j < 10000000; j++)
      {
         [Foo doNoParam];
      }
}


static void   test_Foo_doSuperNoParam( unsigned long n, va_list unused)
{
   unsigned long   i;
   unsigned long   j;

   for( i = 0; i < n; i++)
      for( j = 0; j < 10000000; j++)
      {
         [Foo doSuperNoParam];
      }
}


static void   test_doStuffClass( unsigned long n, va_list unused)
{
   unsigned long   i;
   unsigned long   j;

   for( i = 0; i < n; i++)
      for( j = 0; j < 10000000; j++)
      {
         [Foo doStuff];
      }
}


#pragma NSNumber


static void   test_NSNumber_self( unsigned long n, va_list unused)
{
   unsigned long   i;
   unsigned long   j;

   for( i = 0; i < n; i++)
      for( j = 0; j < 10000000; j++)
      {
         [NSNumber self];
      }
}


static void   test_NSNumber_class( unsigned long n, va_list unused)
{
   unsigned long   i;
   unsigned long   j;

   for( i = 0; i < n; i++)
      for( j = 0; j < 10000000; j++)
      {
         [NSNumber class];
      }
}


static void   test_NSNumber_newRelease( unsigned long n, va_list args)
{
   unsigned long   i;
   unsigned long   j;
   id              obj;

   obj = va_arg( args, id);
   for( i = 0; i < n; i++)
      for( j = 0; j < 10000000; j++)
      {
         [[NSNumber new] release];
      }
}


#pragma NSMutableDictionary

static void   test_NSMutableDictionary_self( unsigned long n, va_list unused)
{
   unsigned long   i;
   unsigned long   j;

   for( i = 0; i < n; i++)
      for( j = 0; j < 10000000; j++)
      {
         [NSMutableDictionary self];
      }
}


static void   test_NSMutableDictionary_class( unsigned long n, va_list unused)
{
   unsigned long   i;
   unsigned long   j;

   for( i = 0; i < n; i++)
      for( j = 0; j < 10000000; j++)
      {
         [NSMutableDictionary class];
      }
}


static void   test_NSMutableDictionary_newRelease( unsigned long n, va_list args)
{
   unsigned long   i;
   unsigned long   j;
   id              obj;

   obj = va_arg( args, id);
   for( i = 0; i < n; i++)
      for( j = 0; j < 10000000; j++)
      {
         [[NSMutableDictionary new] release];
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
   Foo                  *foo;
   int                  noheader;
   NSNumber             *nr;
   NSMutableDictionary  *dict;

#if 0
   {
      struct _mulle_objc_class   *cls;

      // put in NSMutableDictionary
      cls = mulle_objc_unfailingget_class( MULLE_OBJC_CLASSID( MULLE_OBJC_FASTCLASSHASH_10));
      _mulle_objc_universe_set_fastclass( mulle_objc_inlined_get_universe(), cls, 10);

      // put in NSNumber
      cls = mulle_objc_unfailingget_class( MULLE_OBJC_CLASSID( MULLE_OBJC_FASTCLASSHASH_13));
      _mulle_objc_universe_set_fastclass( mulle_objc_inlined_get_universe(), cls, 13);
   }
#endif
   foo = [Foo new];

#ifdef __MULLE_OBJC__
   {
      struct _mulle_objc_cache  *cache;

      [foo doNoParam];
      [foo doOneParam:nil];
      [foo doTwoParam:nil :nil];
      [foo doThreeParam:nil :nil :nil];
      [foo doFourParam:nil :nil :nil :nil];
      [foo doThreeParam:nil :nil :nil];
      [foo doTwoParam:nil :nil];
      [foo doOneParam:nil];
      [foo doNoParam];

      cache = _mulle_objc_class_get_methodcache( _mulle_objc_object_get_isa( foo));

      fprintf( stderr, "doNoParam = %d\n", _mulle_objc_cache_relative_index_of_uniqueid( cache, @selector( doNoParam)));
      fprintf( stderr, "doOneParam = %d\n", _mulle_objc_cache_relative_index_of_uniqueid( cache, @selector( doOneParam:)));
      fprintf( stderr, "doTwoParam = %d\n", _mulle_objc_cache_relative_index_of_uniqueid( cache, @selector( doTwoParam::)));
      fprintf( stderr, "doThreeParam = %d\n", _mulle_objc_cache_relative_index_of_uniqueid( cache, @selector( doThreeParam:::)));
      fprintf( stderr, "doFourParam = %d\n", _mulle_objc_cache_relative_index_of_uniqueid( cache, @selector( doFourParam::::)));
   }
#endif

   noheader = argc == 2 && ! strcmp( argv[ 1], "--noheader");

   run_test( "-[Foo doNoParam]", noheader, (void *) test_doNoParam, foo);
   run_test( "-[Foo doOneParam]", noheader, (void *) test_doOneParam, foo, nil);
   run_test( "-[Foo doTwoParam]", noheader, (void *) test_doTwoParam, foo, nil, nil);
   run_test( "-[Foo doThreeParam]", noheader, (void *) test_doThreeParam, foo, nil, nil, nil);
   run_test( "-[Foo doFourParam]", noheader, (void *) test_doFourParam, foo, nil, nil, nil, nil);
   run_test( "-[Foo doSuperNoParam]", noheader, (void *) test_doSuperNoParam, foo);

   nr   = [NSNumber new];
   dict = [NSMutableDictionary new];

   run_test( "-[Foo class]", noheader, (void *) test_class, foo);
   run_test( "-[NSNumber class]", noheader, (void *) test_class, nr);
   run_test( "-[NSMutableDictionary class]", noheader, (void *) test_class, dict);

   run_test( "-[Foo self]", noheader, (void *) test_self, foo);
   run_test( "-[NSNumber self]", noheader, (void *) test_self, nr);
   run_test( "-[NSMutableDictionary self]", noheader, (void *) test_self, dict);

   run_test( "+[Foo doNoParam]", noheader, (void *) test_Foo_doNoParam, nil);
   run_test( "+[Foo doSuperNoParam]", noheader, (void *) test_Foo_doSuperNoParam, nil);

   run_test( "+[Foo self]", noheader, (void *) test_Foo_self, nil);
   run_test( "+[NSNumber self]", noheader, (void *) test_NSNumber_self, nil);
   run_test( "+[NSMutableDictionary self]", noheader, (void *) test_NSMutableDictionary_self, nil);

   run_test( "+[Foo class]", noheader, (void *) test_Foo_class, nil);
   run_test( "+[NSNumber class]", noheader, (void *) test_NSNumber_class, nil);
   run_test( "+[NSMutableDictionary class]", noheader, (void *) test_NSMutableDictionary_class, nil);

   run_test( "[[Foo new] release]", noheader, (void *) test_Foo_newRelease, nil);
   run_test( "[[NSNumber new] release]", noheader, (void *) test_NSNumber_newRelease, nil);
   run_test( "[[NSMutableDictionary new] release]", noheader, (void *) test_NSMutableDictionary_newRelease, nil);

   run_test( "[[Foo retain] release]", noheader, (void *) test_retainRelease, foo);

   return 0;
}


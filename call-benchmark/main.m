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

+ (void) doNo
{
}


- (void) doNo
{
}


- (void) doOne:(id) a
{
}


- (void) doTwo:(id)a :(id) b
{
}


- (void) doThree:(id)a :(id) b :(id) c
{
}


- (void) doFour:(id)a :(id) b :(id) c :(id) d
{
}


@end


@interface Foo : Bar

- (id) doStuff:(id) a
             b:(id) b
             c:(id) c;

@end


@implementation Foo

+ (void) doSuperNo
{
   [super doNo];
}


- (void) doSuperNo
{
   [super doNo];
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


static void   test_doNo( unsigned long n, va_list args)
{
   unsigned long   i;
   unsigned long   j;
   id              obj;

   obj = va_arg( args, id);
   for( i = 0; i < n; i++)
      for( j = 0; j < 10000000; j++)
      {
         [obj doNo];
      }
}


static void   test_doOne( unsigned long n, va_list args)
{
   unsigned long   i;
   unsigned long   j;
   id              obj;
   id              a;

   obj = va_arg( args, id);
   a   = va_arg( args, id);
   for( i = 0; i < n; i++)
      for( j = 0; j < 10000000; j++)
         [obj doOne:a];
}


static void   test_doTwo( unsigned long n, va_list args)
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
         [obj doTwo:a :b];
      }
}


static void   test_doThree( unsigned long n, va_list args)
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
         [obj doThree:a :b :c];
      }
}


static void   test_doFour( unsigned long n, va_list args)
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
         [obj doFour:a :b :c :d];
      }
}


static void   test_doSuperNo( unsigned long n, va_list args)
{
   unsigned long   i;
   unsigned long   j;
   id              obj;

   obj = va_arg( args, id);
   for( i = 0; i < n; i++)
      for( j = 0; j < 10000000; j++)
      {
         [obj doSuperNo];
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


static void  test_Foo_doNo( unsigned long n, va_list unused)
{
   unsigned long   i;
   unsigned long   j;

   for( i = 0; i < n; i++)
      for( j = 0; j < 10000000; j++)
      {
         [Foo doNo];
      }
}


static void   test_Foo_doSuperNo( unsigned long n, va_list unused)
{
   unsigned long   i;
   unsigned long   j;

   for( i = 0; i < n; i++)
      for( j = 0; j < 10000000; j++)
      {
         [Foo doSuperNo];
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


static void   run_test( char *title, char *loop, int noheader, void (*f)( unsigned long, va_list), ...)
{
   va_list          args;
   va_list          tmp;
   struct timeval   start;
   struct timeval   end;
   long             us;

   if( loop)
   {
      if( strcmp( loop, title))
         return;

      fprintf( stderr, "running %s forever...", title);
      for(;;)
         (*f)( LOOPS, args);
   }


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
   char                 *test_loop;

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

      [foo doNo];
      [foo doOne:nil];
      [foo doTwo:nil :nil];
      [foo doThree:nil :nil :nil];
      [foo doFour:nil :nil :nil :nil];
      [foo doThree:nil :nil :nil];
      [foo doTwo:nil :nil];
      [foo doOne:nil];
      [foo doNo];
      [foo doSuperNo];

      cache = _mulle_objc_class_get_methodcache( _mulle_objc_object_get_isa( foo));

      fprintf( stderr, "doNo = %d\n", _mulle_objc_cache_find_entryindex( cache, @selector( doNo)));
      fprintf( stderr, "doOne = %d\n", _mulle_objc_cache_find_entryindex( cache, @selector( doOne:)));
      fprintf( stderr, "doTwo = %d\n", _mulle_objc_cache_find_entryindex( cache, @selector( doTwo::)));
      fprintf( stderr, "doThree = %d\n", _mulle_objc_cache_find_entryindex( cache, @selector( doThree:::)));
      fprintf( stderr, "doFour = %d\n", _mulle_objc_cache_find_entryindex( cache, @selector( doFour::::)));
      fprintf( stderr, "doSuperNo = %d\n", _mulle_objc_cache_find_entryindex( cache, @selector( doSuperNo)));
      fprintf( stderr, "Foo;doSuperNo = %d\n", _mulle_objc_cache_find_entryindex( cache, mulle_objc_superid_from_string( "Foo;doSuperNo")));

      mulle_objc_dotdump_to_tmp();
   }
#endif

   test_loop = NULL;
   noheader  = argc >= 2 && ! strcmp( argv[ 1], "--noheader");
   if( argc >= 4 && ! strcmp( argv[ 2], "--loop"))
      test_loop = argv[ 3];

   run_test( "-[Foo doNo]", test_loop, noheader, (void *) test_doNo, foo);
   run_test( "-[Foo doOne]", test_loop, noheader, (void *) test_doOne, foo, nil);
   run_test( "-[Foo doTwo]", test_loop, noheader, (void *) test_doTwo, foo, nil, nil);
   run_test( "-[Foo doThree]", test_loop, noheader, (void *) test_doThree, foo, nil, nil, nil);
   run_test( "-[Foo doFour]", test_loop, noheader, (void *) test_doFour, foo, nil, nil, nil, nil);
   run_test( "-[Foo doSuperNo]", test_loop, noheader, (void *) test_doSuperNo, foo);

   nr   = [NSNumber new];
   dict = [NSMutableDictionary new];

   run_test( "-[Foo class]", test_loop, noheader, (void *) test_class, foo);
   run_test( "-[NSNumber class]", test_loop, noheader, (void *) test_class, nr);
   run_test( "-[NSMutableDictionary class]", test_loop, noheader, (void *) test_class, dict);

   run_test( "-[Foo self]", test_loop, noheader, (void *) test_self, foo);
   run_test( "-[NSNumber self]", test_loop, noheader, (void *) test_self, nr);
   run_test( "-[NSMutableDictionary self]", test_loop, noheader, (void *) test_self, dict);

   run_test( "+[Foo doNo]", test_loop, noheader, (void *) test_Foo_doNo, nil);
   run_test( "+[Foo doSuperNo]", test_loop, noheader, (void *) test_Foo_doSuperNo, nil);

   run_test( "+[Foo self]", test_loop, noheader, (void *) test_Foo_self, nil);
   run_test( "+[NSNumber self]", test_loop, noheader, (void *) test_NSNumber_self, nil);
   run_test( "+[NSMutableDictionary self]", test_loop, noheader, (void *) test_NSMutableDictionary_self, nil);

   run_test( "+[Foo class]", test_loop, noheader, (void *) test_Foo_class, nil);
   run_test( "+[NSNumber class]", test_loop, noheader, (void *) test_NSNumber_class, nil);
   run_test( "+[NSMutableDictionary class]", test_loop, noheader, (void *) test_NSMutableDictionary_class, nil);

   run_test( "[[Foo new] release]", test_loop, noheader, (void *) test_Foo_newRelease, nil);
   run_test( "[[NSNumber new] release]", test_loop, noheader, (void *) test_NSNumber_newRelease, nil);
   run_test( "[[NSMutableDictionary new] release]", test_loop, noheader, (void *) test_NSMutableDictionary_newRelease, nil);

   run_test( "[[Foo retain] release]", test_loop, noheader, (void *) test_retainRelease, foo);

   return 0;
}


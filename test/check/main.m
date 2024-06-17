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


int   main( int argc, char  *argv[])
{
   Foo                  *foo;
   int                  noheader;
   NSNumber             *nr;
   NSMutableDictionary  *dict;

   foo = [Foo new];

   {
      struct _mulle_objc_cache  *cache;

      [foo doNoParam];
      [foo doOneParam:nil];
      [foo doTwoParam:nil :nil];
      [foo doThreeParam:nil :nil :nil];
      [foo doFourParam:nil :nil :nil :nil];
      [foo doNoParam];
      [foo doOneParam:nil];
      [foo doTwoParam:nil :nil];
      [foo doThreeParam:nil :nil :nil];

      cache = _mulle_objc_class_get_impcache_cache_atomic( _mulle_objc_object_get_isa( foo));

      fprintf( stderr, "doNoParam = %d\n", _mulle_objc_cache_probe_entryindex( cache, @selector( doNoParam)));
      fprintf( stderr, "doOneParam = %d\n", _mulle_objc_cache_probe_entryindex( cache, @selector( doOneParam:)));
      fprintf( stderr, "doTwoParam = %d\n", _mulle_objc_cache_probe_entryindex( cache, @selector( doTwoParam::)));
      fprintf( stderr, "doThreeParam = %d\n", _mulle_objc_cache_probe_entryindex( cache, @selector( doThreeParam:::)));
      fprintf( stderr, "doFourParam = %d\n", _mulle_objc_cache_probe_entryindex( cache, @selector( doFourParam::::)));
   }

   [foo release];

   return 0;
}


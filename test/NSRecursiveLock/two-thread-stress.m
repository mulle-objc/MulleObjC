//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#ifdef __MULLE_OBJC__
# import <MulleObjC/MulleObjC.h>
#else
# import <Foundation/Foundation.h>
# pragma message( "Apple Foundation")
#endif


#define S_TREASURE   32

@interface Foo : NSObject <MulleObjCThreadSafe>
{
   NSRecursiveLock    *_lock;
   char               _treasure[ S_TREASURE];
}
@end


@implementation Foo

- (instancetype) init
{
   _lock = [NSRecursiveLock new];
   return( self);
}

- (void) dealloc
{
   [_lock release];
   [super dealloc];
}


- (void) runWithDepth:(unsigned int) depth
{
   int    c;
   char   tmp[ S_TREASURE];

   c = mulle_pointer_hash( (void *) mulle_thread_self());
   memset( tmp, c, S_TREASURE);

   if( depth)
   {
      [_lock lock];
         memcpy( _treasure, tmp, S_TREASURE);
         MULLE_THREAD_UNPLEASANT_RACE_YIELD();
         if( memcmp( tmp, _treasure, S_TREASURE))
            abort();
         [self runWithDepth:depth - 1];
      [_lock unlock];
   }
}


- (void) test:(id) unused
{
   NSUInteger  i;

   for( i = 0; i < 1000; i++)
   {
      MULLE_THREAD_UNPLEASANT_RACE_YIELD();
      [self runWithDepth:rand() % 32];
   }
}

@end



int   main( int argc, const char * argv[])
{
   Foo  *foo;

   foo = [Foo object];
   [NSThread detachNewThreadSelector:@selector( test:)
                            toTarget:foo
                          withObject:nil];

   [foo test:nil];

   return( 0);
}

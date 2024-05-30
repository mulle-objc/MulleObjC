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


static void   print_fail_if( int state)
{
   if( state)
      printf( "FAIL\n");
}


@implementation NSConditionLock( Test)

- (void) runServer:(id) argument
{
   @autoreleasepool
   {
      [self lockWhenCondition:1848];
      printf( "1. %ld\n", [self condition]);
      [self unlockWithCondition:1849];

      [self lockWhenCondition:1850];
      printf( "3. %ld\n", [self condition]);
      [self unlockWithCondition:1851];
   }
}

- (void) runClient:(id) argument
{
   [self lockWhenCondition:1849];
   printf( "2. %ld\n", [self condition]);
   [self unlockWithCondition:1850];

   [self lockWhenCondition:1851];
   printf( "4. %ld\n", [self condition]);
   [self unlockWithCondition:1852];
}

@end



int   main( int argc, const char * argv[])
{
   NSConditionLock   *lock;

#ifdef __MULLE_OBJC__
   if( mulle_objc_global_check_universe( __MULLE_OBJC_UNIVERSENAME__) != mulle_objc_universe_is_ok)
      return( 1);
#endif

   lock = [[[NSConditionLock alloc] initWithCondition:1848] autorelease];
   printf( "0. %ld\n", [lock condition]);

   [NSThread detachNewThreadSelector:@selector( runServer:)
                            toTarget:lock
                          withObject:nil];

   [lock runClient:nil];

   return( 0);
}

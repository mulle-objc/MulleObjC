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


int   main( int argc, const char * argv[])
{
   NSConditionLock   *lock;

#ifdef __MULLE_OBJC__
   if( mulle_objc_global_check_universe( __MULLE_OBJC_UNIVERSENAME__) != mulle_objc_universe_is_ok)
      return( 1);
#endif

   lock = [[[NSConditionLock alloc] initWithCondition:1848] autorelease];

   printf( "1. %ld\n", [lock condition]);
   // exercise NSLocking protocol, which is done by NSCondition
   // really
   if( [lock tryLockWhenCondition:1849])
   {
      printf( "succeeded with wrong condition\n");
      return( 1);
   }
   if( ! [lock tryLockWhenCondition:1848])
   {
      printf( "failed with right condition\n");
      return( 1);
   }
   printf( "2. %ld\n", [lock condition]);

   [lock unlockWithCondition:1849];
   printf( "3. %ld\n", [lock condition]);

   [lock lockWhenCondition:1849];
   printf( "4. %ld\n", [lock condition]);
   [lock unlockWithCondition:1850];
   printf( "5. %ld\n", [lock condition]);

   return( 0);
}

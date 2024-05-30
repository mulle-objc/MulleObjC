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


int   main( int argc, const char * argv[])
{
   NSConditionLock   *lock;

#ifdef __MULLE_OBJC__
   if( mulle_objc_global_check_universe( __MULLE_OBJC_UNIVERSENAME__) != mulle_objc_universe_is_ok)
      return( 1);
#endif
   lock = [NSConditionLock new];

   // exercise NSLocking protocol, which is done by NSCondition
   // really
   [lock lock];
   [lock unlock];

   [lock release];

   return( 0);
}

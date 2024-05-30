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
   NSRecursiveLock  *lock;

   lock = [NSRecursiveLock alloc];
   lock = [lock init];
   lock = [lock autorelease];

   [lock lock];
   [lock unlock];

   if( ! [lock tryLock])
      return( 1);
   [lock unlock];

   [lock lock];
   [lock lock];
   [lock unlock];
   [lock unlock];

   [lock lock];
   if( ! [lock tryLock])
      return( 1);
   [lock unlock];
   [lock unlock];

   return( 0);
}

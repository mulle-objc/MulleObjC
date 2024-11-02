//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#ifdef __MULLE_OBJC__
# import <MulleObjC/MulleObjC.h>
# import <MulleObjC/NSDebug.h>
#else
# import <Foundation/Foundation.h>
# import <Foundation/NSDebug.h>
# pragma message( "Apple Foundation")
#endif


int   main( int argc, const char * argv[])
{
   NSConditionLock   *lock;

   // just some
   lock = [NSConditionLock object];

   mulle_printf( "nil: %s\n", _NSPrintForDebugger( nil));
   //MulleObjCDebugElideAddressOutput=YES;
   mulle_printf( "obj: %s\n", _NSPrintForDebugger( lock));

   return( 0);
}

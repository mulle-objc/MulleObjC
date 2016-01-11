//
//  ns_debug.c
//  MulleObjC
//
//  Created by Nat! on 21/10/15.
//  Copyright © 2015 Mulle kybernetiK. All rights reserved.
//

#include "ns_debug.h"


BOOL   NSDebugEnabled;
BOOL   NSZombieEnabled;
BOOL   NSDeallocateZombies;
BOOL   NSHangOnUncaughtException;


void   *NSFrameAddress( NSUInteger frame)
{
   return( NULL);
}


void   *NSReturnAddress( NSUInteger frame)
{
   return( NULL);
}


NSUInteger   NSCountFrames( void)
{
   return( 0);
}


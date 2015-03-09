/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSProxy.m is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSProxy.h"



@implementation NSProxy

+ (void) initialize
{
   // this is called by all subclasses, that don't implement #initialize
   // so don't do much/anything here (or protect against it)
#if DEBUG_INITIALIZE
   printf( "+[%s initialize] handled by %s\n",_NSObjCGetClassName( self), __PRETTY_FUNCTION__);
#endif 
}


- (BOOL) isProxy
{
   return( YES);
}

@end


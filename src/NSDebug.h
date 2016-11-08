/*
 *  MulleFoundation - the mulle-objc class library
 *
 *  NSDebug.h is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSObject.h"


@interface NSObject ( NSDebug)

- (id) debugDescription;

@end


char   *_NSPrintForDebugger( id a);
void   MulleObjCZombifyObject( id obj);

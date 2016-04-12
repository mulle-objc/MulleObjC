/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSFastEnumeration.h is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "ns_type.h"


typedef struct
{
   unsigned long   state;
   id              *itemsPtr;
   unsigned long   *mutationsPtr;
   unsigned long   extra[5];
} NSFastEnumerationState;


@protocol NSFastEnumeration

- (NSUInteger) countByEnumeratingWithState:(NSFastEnumerationState *) state
                                   objects:(id *) objects
                                     count:(NSUInteger) count;
@end



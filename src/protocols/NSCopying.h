/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSCopying.h is a part of MulleFoundation
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

#import "ns_zone.h"


//
// the old copyWithZone: still works, but it's gone from the protocol
//
@protocol NSCopying 

- (id) copy;

@end



id   NSCopyObject( id object, NSUInteger extraBytes, NSZone *zone);


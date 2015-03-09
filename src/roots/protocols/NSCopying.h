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


@protocol NSCopying

- (id) copyWithZone:(NSZone *) zone;  // NSZone is just here for compatibility

@end

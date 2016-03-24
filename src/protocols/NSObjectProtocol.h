/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSObjectProtocol.h is a part of MulleFoundation
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


#ifdef TRACE_INCLUDE_MULLE_FOUNDATION
# warning NSObject protocol included
#endif


@protocol NSObject

// these are not in the traditional NSObject protocol
+ (instancetype) new;
+ (nonnull instancetype) alloc;
+ (nonnull instancetype) allocWithZone:(NSZone *) zone;  // deprecated
- (instancetype) init;


// traditionals
- (nonnull instancetype) retain;
- (void) release;
- (nonnull instancetype) autorelease;
- (NSUInteger) retainCount;
- (NSZone *) zone;

- (BOOL) isEqual:(id) obj;
- (NSUInteger) hash;
- (Class) superclass;
- (nonnull Class) class;
- (nonnull id) self;
- (id) performSelector:(SEL) sel;
- (id) performSelector:(SEL) sel
            withObject:(id) obj;
- (id) performSelector:(SEL) sel
            withObject:(id) obj
            withObject:(id) other;
- (BOOL) isProxy;
- (BOOL) isKindOfClass:(Class) cls;
- (BOOL) isMemberOfClass:(Class) cls;
- (BOOL) conformsToProtocol:(PROTOCOL) protocol;
- (BOOL) respondsToSelector:(SEL) sel;
- (id) description;

// mulle additions:

// AAO suport
+ (nonnull instancetype) instantiate;
- (nonnull instancetype) immutableInstance;

// advanced Autorelease and ObjectGraph support
- (void) becomeRootObject;
- (void) becomeSingleton;
- (void) becomePlaceholder;
- (void) pushToParentAutoreleasePool;

@end

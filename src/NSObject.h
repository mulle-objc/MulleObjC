/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSObject.h is a part of MulleFoundation
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

#import "NSObjectProtocol.h"
#import "ns_zone.h"


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnullability-completeness"
#pragma clang diagnostic ignored "-Wcast-of-sel-type"

//
// +load: mulle-objc-runtime guarantees, that the class and therefore the
//        superclass too is available. Messaging other classes in the same
//        shared library is wrong.
//
// +initialize: mulle-objc-runtime guarantees that +initialize is executed
//              only once per meta-class object.
//
@interface NSObject < NSObject>
{
}



//
// these methods must not be overriden
// the runtime will replace any [foo alloc] call
// with a C function
//
- (NSZone *) zone   __attribute__((deprecated("zones have no meaning and will eventually disappear")));  // always NULL
- (nonnull instancetype) retain;
- (void) release;
- (nonnull instancetype) autorelease;
- (NSUInteger) retainCount;

// regular methods

//
// new does NOT call +alloc or +allocWithZone:
// override new too, if you override alloc
//
+ (instancetype) new;
+ (nonnull instancetype) alloc;
+ (nonnull instancetype) allocWithZone:(NSZone *) zone  __attribute__((deprecated("zones have no meaning and will eventually disappear")));   // deprecated

//
// if you subclass NSObject and override init, don't bother calling [super init]
// 
- (instancetype) init;
- (void) dealloc;

- (NSUInteger) hash;
- (BOOL) isEqual:(id) other;

- (Class) superclass;
- (nonnull Class) class;
- (nonnull instancetype) self;
- (BOOL) isKindOfClass:(Class) cls;
- (BOOL) isMemberOfClass:(Class) cls;

- (BOOL) conformsToProtocol:(PROTOCOL) protocol;
- (BOOL) respondsToSelector:(SEL) sel;
- (id) performSelector:(SEL) sel;
- (id) performSelector:(SEL) sel 
            withObject:(id) obj;
- (id) performSelector:(SEL) sel 
            withObject:(id) obj1
            withObject:(id) obj2;

- (BOOL) isProxy;
- (id) description;


+ (nonnull Class) class;
+ (BOOL) isSubclassOfClass:(Class) cls;
+ (BOOL) instancesRespondToSelector:(SEL) sel;

- (IMP) methodForSelector:(SEL) sel;
+ (IMP) instanceMethodForSelector:(SEL) sel;

#pragma mark mulle additions

//
// find the implementation that was overridden
// fairly slow!
//
- (IMP) methodWithSelector:(SEL) sel
overriddenByImplementation:(IMP) imp;

// AAO suport
+ (nonnull instancetype) instantiate;        // alloc + autorelease
- (nonnull instancetype) immutableInstance;  // copy + autorelease

// advanced Autorelease and ObjectGraph support

- (void) becomeRootObject;        // retains  #1#

- (void) resignAsRootObject;      // autoreleases
- (void) pushToParentAutoreleasePool;

// not part of NSObject protocol

/* 
   Returns all objects, retained by this instance.
   This is not deep!
 
   Every class that stores objects in C-arrays, must
   implement this. Oherwise the default implementation 
   is good enough.
 */
- (NSUInteger) getOwnedObjects:(id *) objects
                        length:(NSUInteger) length;

@end

#pragma clang diagnostic push


//
// HACKISH stuff
//
//
// this can be useful for creating placeholder objects
// TODO: make this a runtime struct like classpair
//
struct MulleObjCObjectWithHeader
{
   struct _mulle_objc_objectheader   header;
   struct _mulle_objc_object         object;
};


static inline void   *MulleObjCObjectWithHeaderGetObject( struct MulleObjCObjectWithHeader *p)
{
   return( &p->object);
}


static inline void   *MulleObjCObjectGetObjectWithHeaderFromObject( id p)
{
   return( (void *)  _mulle_objc_object_get_objectheader( p));
}


/*
 * #1# whenever you call [self retain] or don't return an object autoreleased,
 * chances are very high, this object is a root object (or could become one)
 */


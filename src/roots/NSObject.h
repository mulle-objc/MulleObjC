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


@interface NSObject < NSObject>
{
}


//
// these methods must not be overriden
// the runtime will replace any [foo alloc] call
// with a C function
//
- (NSZone *) zone;  // always NULL
- (id) retain;
- (void) release;
- (id) autorelease;
- (NSUInteger) retainCount;

// regular methods

//
// new does NOT call +alloc or +allocWithZone:
// override new too, if you override alloc
//
+ (id) new;
+ (id) alloc;
+ (id) allocWithZone:(NSZone *) zone;   // deprecated
- (id) init;
- (void) dealloc;

- (BOOL) isEqual:(id) other;
- (NSUInteger) hash;
- (Class) superclass;
- (Class) class;
- (id) self;
- (id) performSelector:(SEL) sel;
- (id) performSelector:(SEL) sel 
            withObject:(id) obj;
- (id) performSelector:(SEL) sel 
            withObject:(id) obj1
            withObject:(id) obj2;

- (BOOL) isProxy;
- (BOOL) isKindOfClass:(Class) cls;
- (BOOL) isMemberOfClass:(Class) cls;
- (BOOL) conformsToProtocol:(PROTOCOL) protocol;
- (BOOL) respondsToSelector:(SEL) sel;

- (id) description;

+ (BOOL) isSubclassOfClass:(Class) cls;


#if 0 // not yet, avoid this in foundation code
- (id) copy;
- (id) mutableCopy;
#endif

+ (Class) class;
+ (BOOL) instancesRespondToSelector:(SEL) sel;

- (IMP) methodForSelector:(SEL) sel;
+ (IMP) instanceMethodForSelector:(SEL) sel;

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


// this is sometimes useful for creating static objects
struct _NSObject
{
   struct _mulle_objc_objectheader   header;
   struct _mulle_objc_object         nsObject;
};



static inline void   *NSObjectFrom_NSObject( struct _NSObject *p)
{
   return( _mulle_objc_objectheader_get_object( &p->header));
}


static inline void   *_NSObjectFromNSObject( NSObject *p)
{
   return( (void *)  _mulle_objc_object_get_objectheader( p));
}



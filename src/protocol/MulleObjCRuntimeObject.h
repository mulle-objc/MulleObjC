//
//  MulleObjCRuntimeObject.h
//  MulleObjC
//
//  Created by Nat! on 12.05.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
//
#import "import.h"

#import "NSZone.h"
#import "mulle-objc-type.h"
#import "mulle-objc-atomicid.h"
#import "MulleObjCIntegralType.h"


#ifdef TRACE_INCLUDE_MULLE_FOUNDATION
# warning MulleObjCRuntimeObject protocol included
#endif

//
// # MulleObjCTAOStrategy Enumeration
//
// The MulleObjCTAOStrategy enumeration defines Thread Affinity and
// Ownership strategies that control how objects are transferred between
// threads in the MulleObjC runtime system. This is a core part of
// MulleObjC's memory management and thread safety architecture.
//
// ## Purpose
//
// This enumeration provides policies for safely transferring object
// ownership between threads while managing memory correctly through
// autorelease pools. The TAO system is designed to prevent race conditions,
// memory leaks, and dangling pointers when objects move across thread
// boundaries.
//
// ## Implementation Details
//
// ### All purpose thread strategies
//
// The enumeration defines five strategies, each with different implications
// for thread safety and memory management. For a generic passing of objects,
// between threads you SHOULD use MulleObjCTAOKnownThreadSafe. All other
// strategies are basically hacks.
//
// *  MulleObjCTAOKnownThreadSafe:
//    The most efficient strategy, used for fully thread-safe objects.
//    Asserts that the object has no thread affinity (can be accessed from
//    any thread). Completely bypasses thread affinity management. Used with
//    objects that implement @protocol MulleObjCThreadSafe. Tip:
//    use MulleObject dervied classes and make them MulleObjCThreadSafe.
//
// *  MulleObjCTAOCallerRemovesFromCurrentPool:
//    Used when transferring an object that was just created for passing to
//    another thread. The caller is responsible for removing the object from
//    the current thread's autorelease pool. Implementation explicitly calls
//    mulleReleasePoolObjects:count: on the current thread's autorelease
//    pool. The fallback for objects, that do not "care" about thread safety.
//    A common general-purpose strategy, which is not recommended as a
//    "design" feature.
//
// *  MulleObjCTAOCallerRemovesFromAllPools:
//    A more aggressive cleanup approach. Removes the object from all
//    autorelease pools across all threads. The code comments warn against
//    regular use, as it may lead to future failures. Used only in special
//    circumstances when an object must be completely detached. But extremely
//    hacky and  potentially slow and dangerous. Not recommended for general use.
//
// ### Custom thread strategies
//
// A custom thread is a thread, where you know what the thread funciton will
// do (e.g. look up a NSURL for example). Using one of these strategies you
// implicitly design a class to be only used with a certain custom thread,
// which is limiting
//
// *  MulleObjCTAOKnownThreadSafeMethods:
//    Used when you assume that the receiver will only call thread-safe methods.
//    So your object is no longer all purpose but limited to a certain kind of
//    NSThread access. Does not change thread affinity when gaining or
//    relinquishing access. Bypasses normal thread checking and
//    autorelease pool management. Allows more efficient inter-thread
//    operation for partially thread-safe objects.
//
// *  MulleObjCTAOReceiverPerformsFinalize:
//    For special setups where the receiving object handles its own
//    finalization. Changes thread affinity when gaining or
//    relinquishing access. Reserved for specialized manual object
//    management scenarios.
//
// ## Operational Flow
//
// The source thread calls mulleRelinquishAccess, which:
// - Retains the object (ensuring it won't be deallocated during transfer)
// - Based on the strategy, potentially removes it from autorelease pools
// - Unsets the thread affinity marker (sets to mulle_objc_object_has_no_thread)
//
// The receiving thread calls mulleGainAccess, which:
// - Sets the thread affinity to the current thread (unless using thread-safe
//   strategies)
// - Autoreleases the object in the receiving thread's autorelease pool
//
//

typedef NS_ENUM( NSUInteger, MulleObjCTAOStrategy)
{
   MulleObjCTAOCallerRemovesFromCurrentPool, // use this, if you just created the object to pass
   MulleObjCTAOCallerRemovesFromAllPools,    // try to avoid this
   MulleObjCTAOCallerRemovesFromCurrentPoolShallow, // will not walk ivars and properties!
   MulleObjCTAOCallerRemovesFromAllPoolsShallow,    // will not walk ivars and properties!
   MulleObjCTAOReceiverPerformsFinalize,     // for very special setups (*)
   MulleObjCTAOTransferIvars,                // walk ivars
   MulleObjCTAOKnownThreadSafeMethods,       // aspire to use this (-finalize/-dealloc only do threadsafe stuff)
   MulleObjCTAOKnownThreadSafe               // most preferable though is this (only threadsafe objects are involved)
};

// (*) this means an instance is created and then presented to a thread in a one
//     directional fashion. It won't work, if the instance is created in the
//     thread and then acquired by the thread maker.
//

MULLE_OBJC_GLOBAL
NS_ENUM_TABLE( MulleObjCTAOStrategy, 8);



// TODO: make this somewhat "official" by removing the underscore prefix
typedef struct _mulle_objc_dependency     mulle_objc_dependency_t;

#define MULLE_OBJC_DEPENDS_ON_LIBRARY( libname) \
@dependency MulleObjCDeps( libname)

#define MULLE_OBJC_DEPENDS_ON_CLASS( classname) \
@dependency classname

#define MULLE_OBJC_DEPENDS_ON_CATEGORY( classname, categoryname) \
@dependency classname( categoryname)

@class NSThread;

//
// Custom attribute for methods
//
#define _MULLE_OBJC_METHOD_USER_ATTRIBUTE_0   __attribute__((annotate("objc_user_0")))
#define _MULLE_OBJC_METHOD_USER_ATTRIBUTE_1   __attribute__((annotate("objc_user_1")))
#define _MULLE_OBJC_METHOD_USER_ATTRIBUTE_2   __attribute__((annotate("objc_user_2")))
#define _MULLE_OBJC_METHOD_USER_ATTRIBUTE_3   __attribute__((annotate("objc_user_3")))
#define _MULLE_OBJC_METHOD_USER_ATTRIBUTE_4   __attribute__((annotate("objc_user_4")))

#define MULLE_OBJC_THREADSAFE_METHOD   \
   _MULLE_OBJC_METHOD_USER_ATTRIBUTE_4

// just the same, but I don't want to use  MULLE_OBJC_THREADSAFE on its own
#define MULLE_OBJC_THREADSAFE_PROPERTY  \
   _MULLE_OBJC_METHOD_USER_ATTRIBUTE_4



@protocol MulleObjCRuntimeObject

// this is basically mulle-objc-runtime/mulle-objc-retain-release.h
- (instancetype) retain          MULLE_OBJC_THREADSAFE_METHOD;
- (void) release                 MULLE_OBJC_THREADSAFE_METHOD;
- (NSUInteger) retainCount       MULLE_OBJC_THREADSAFE_METHOD;

- (void) dealloc;
- (void) finalize;

// ObjectGraph support
- (id) _becomeRootObject;

// check if an object can be safely accessed by a thread, use this for
// validatation and debugging only
- (BOOL) mulleIsThreadSafe          MULLE_OBJC_THREADSAFE_METHOD;
- (BOOL) mulleIsAccessible          MULLE_OBJC_THREADSAFE_METHOD;
- (BOOL) mulleIsAccessibleByThread:(NSThread *) threadObject   MULLE_OBJC_THREADSAFE_METHOD;

// if you pass an object from one thread to another the sender does
// a relinquish and the receiver does a gain. For objects that are threadsafe
// already, this does nothing. -mulleGainAccess returnValue is that of -autorelease
//
// You must implement this on MulleObjCThreadUnsafe (the default) classes,
// with properties or ivars that reference (retain) other objects, to also
// let the therad gain access to them. You do not implement this on
// a class, that is MulleObjCThreadSafe.
//
- (void) mulleGainAccess            MULLE_OBJC_THREADSAFE_METHOD;
- (void) mulleGainAccessWithTAOStrategy:(MulleObjCTAOStrategy) strategy MULLE_OBJC_THREADSAFE_METHOD;

- (void) mulleRelinquishAccess      MULLE_OBJC_THREADSAFE_METHOD;
- (void) mulleRelinquishAccessWithTAOStrategy:(MulleObjCTAOStrategy) strategy MULLE_OBJC_THREADSAFE_METHOD;

- (void) mulleGainAccessWithUniquingSet:(struct mulle_pointerset *) p          MULLE_OBJC_THREADSAFE_METHOD;
- (void) mulleRelinquishAccessWithUniquingSet:(struct mulle_pointerset *) p    MULLE_OBJC_THREADSAFE_METHOD;

- (MulleObjCTAOStrategy) mulleTAOStrategy MULLE_OBJC_THREADSAFE_METHOD;


// if using class properties, then you can use these methods to access
// the recursive lock
+ (void) lock;
+ (void) unlock;
+ (BOOL) tryLock;

@end


//
// MEMO: the compiler will use mulle_objc_object_call_retain on -O2 anyway or ?
//
static inline id   MulleObjCObjectRetain( id obj)
{
   return( mulle_objc_object_call_retain( obj));
}


static inline void   MulleObjCObjectRelease( id obj)
{
   mulle_objc_object_call_release( obj);
}


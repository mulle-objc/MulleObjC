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
   MulleObjCTAOReceiverPerformsFinalize,     // for very special setups (*)
   MulleObjCTAOKnownThreadSafeMethods,       // aspire to use this (-finalize/-dealloc only do threadsafe stuff)
   MulleObjCTAOKnownThreadSafe               // most preferable though is this (only threadsafe objects are involved)
};

// (*) this means an instance is created and then presented to a thread in a one
//     directional fashion. It won't work, if the instance is created in the
//     thread and then acquired by the thread maker.
//

extern NS_ENUM_TABLE( MulleObjCTAOStrategy, 5);



// make this somewhat "official" by removing the underscore prefix
typedef struct _mulle_objc_dependency     mulle_objc_dependency_t;

#define MULLE_OBJC_MAKE_CLASSID( classname)       @selector( classname)
#define MULLE_OBJC_MAKE_CATEGORYID( categoryname) @selector( categoryname)


#define MULLE_OBJC_CLASS_DEPENDENCY( classname) \
      { MULLE_OBJC_MAKE_CLASSID( classname), MULLE_OBJC_NO_CATEGORYID }
#define MULLE_OBJC_CATEGORY_DEPENDENCY( classname, categoryname) \
      { MULLE_OBJC_MAKE_CLASSID( classname), MULLE_OBJC_MAKE_CATEGORYID( categoryname) }
#define MULLE_OBJC_LIBRARY_DEPENDENCY( libname) \
      { MULLE_OBJC_MAKE_CLASSID( MulleObjCLoader), MULLE_OBJC_MAKE_CATEGORYID( libname) }

#define MULLE_OBJC_NO_DEPENDENCY  \
      { MULLE_OBJC_NO_CLASSID, MULLE_OBJC_NO_CATEGORYID }


#define MULLE_OBJC_DEPENDS_ON_CLASS( classname)             \
                                                            \
+ (mulle_objc_dependency_t *) dependencies                  \
{                                                           \
   static mulle_objc_dependency_t   dependencies[] =        \
   {                                                        \
      MULLE_OBJC_CLASS_DEPENDENCY( classname),              \
      MULLE_OBJC_NO_DEPENDENCY                              \
   };                                                       \
   return( dependencies);                                   \
}                                                           \
/* gobble up semicolon with known external definition */    \
extern void   MulleObjCInstanceDeallocate( id obj)

#define MULLE_OBJC_DEPENDS_ON_CATEGORY( classname, categoryname) \
                                                                 \
+ (mulle_objc_dependency_t *) dependencies                       \
{                                                                \
   static mulle_objc_dependency_t   dependencies[] =             \
   {                                                             \
      MULLE_OBJC_CATEGORY_DEPENDENCY( classname, categoryname),  \
      MULLE_OBJC_NO_DEPENDENCY                                   \
   };                                                            \
   return( dependencies);                                        \
}                                                                \
/* gobble up semicolon with known external definition */         \
extern void   MulleObjCInstanceDeallocate( id obj)


#define MULLE_OBJC_DEPENDS_ON_LIBRARY( libname)             \
                                                            \
+ (mulle_objc_dependency_t *) dependencies                  \
{                                                           \
   static mulle_objc_dependency_t   dependencies[] =        \
   {                                                        \
      MULLE_OBJC_LIBRARY_DEPENDENCY( libname),              \
      MULLE_OBJC_NO_DEPENDENCY                              \
   };                                                       \
   return( dependencies);                                   \
}                                                           \
/* gobble up semicolon with known external definition */    \
extern void   MulleObjCInstanceDeallocate( id obj)


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



@protocol NSObject;
@class NSThread;

/*
 * Helper macros to declare protocol classes.
 *
 * They always implement NSObject. This should be harmless and reduces
 * warnings.y By default all methods are declared optional, since the
 * protocolclass usually implements them (so they are optional for the
 * consumer).
 *
 * MEMO: want to call super ? Check out MulleObjCObjectSearchSuperIMP.
 * TODO: can we put this manually into the instruction cache (like other
 *       superids ?)
 */
#define _PROTOCOLCLASS_INTERFACE0( name) \
_Pragma("clang diagnostic push")         \
@class name;                             \
@protocol name                           \
@optional


#define PROTOCOLCLASS_INTERFACE0( name)  \
_Pragma("clang diagnostic push")         \
@class name;                             \
@protocol name < NSObject>               \
@optional


#define _PROTOCOLCLASS_INTERFACE( name, ...) \
_Pragma("clang diagnostic push")             \
@class name;                                 \
@protocol name < __VA_ARGS__ >               \
@optional


#define PROTOCOLCLASS_INTERFACE( name, ...)            \
_Pragma("clang diagnostic push")                       \
@class name;                                           \
@protocol name < NSObject __VA_OPT__(,) __VA_ARGS__ >  \
@optional


#define PROTOCOLCLASS_END()     \
_Pragma("clang diagnostic pop") \
@end



#define PROTOCOLCLASS_IMPLEMENTATION( name)                        \
_Pragma("clang diagnostic push")                                   \
_Pragma("clang diagnostic ignored \"-Wprotocol\"")                 \
_Pragma("clang diagnostic ignored \"-Wobjc-root-class\"")          \
_Pragma("clang diagnostic ignored \"-Wobjc-missing-super-calls\"") \
                                                                   \
@interface name < name>                                            \
@end                                                               \
                                                                   \
@implementation name



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
- (MulleObjCTAOStrategy) mulleTAOStrategy MULLE_OBJC_THREADSAFE_METHOD;

@end



static inline id   MulleObjCObjectRetain( id obj)
{
   return( mulle_objc_object_call_retain( obj));
}


static inline void   MulleObjCObjectRelease( id obj)
{
   mulle_objc_object_call_release( obj);
}


// Does not work, _Pragma can't do it
// #define _MULLE_OBJC_METHOD_USER_ATTRIBUTE_0_PUSH \
// _Pragma( "clang attribute push(__attribute__((annotate(\"objc_user_0\"))), apply_to = objc_method)")
//
// #define _MULLE_OBJC_METHOD_USER_ATTRIBUTE_1_PUSH \
// _Pragma( "clang attribute push(__attribute__((annotate(\"objc_user_1\"))), apply_to = objc_method")
//
// #define _MULLE_OBJC_METHOD_USER_ATTRIBUTE_2_PUSH \
// _Pragma( "clang attribute push(__attribute__((annotate(\"objc_user_2\"))), apply_to = objc_method")
//
// #define _MULLE_OBJC_METHOD_USER_ATTRIBUTE_3_PUSH \
// _Pragma( "clang attribute push(__attribute__((annotate(\"objc_user_3\"))), apply_to = objc_method")
//
// #define _MULLE_OBJC_METHOD_USER_ATTRIBUTE_4_PUSH \
// _Pragma( "clang attribute push(__attribute__((annotate(\"objc_user_4\"))), apply_to = objc_method")
//
// #define _MULLE_OBJC_METHOD_USER_ATTRIBUTE_POP    \
// _Pragma( "clang attribute pop")
// #define MULLE_OBJC_THREADSAFE_METHODS_PUSH \
//    _MULLE_OBJC_METHOD_USER_ATTRIBUTE_4_PUSH
//
// #define MULLE_OBJC_THREADSAFE_METHODS_POP \
//    _MULLE_OBJC_METHOD_USER_ATTRIBUTE_POP
//


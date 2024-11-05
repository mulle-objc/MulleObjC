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
//     thread and then acquired by the thread maker. I.e. hardly ever useful.
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


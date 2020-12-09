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
#import "MulleObjCIntegralType.h"


#ifdef TRACE_INCLUDE_MULLE_FOUNDATION
# warning MulleObjCRuntimeObject protocol included
#endif


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
extern void   NSDeallocateObject( id obj)

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
extern void   NSDeallocateObject( id obj)


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
extern void   NSDeallocateObject( id obj)


@protocol NSObject;

/*
 * Helper macros to declare protocol classes.
 * They always implement NSObject. This should be harmless and reduces
 * warnings.y By default all methods are declared optional, since the
 * protocolclass usually implements them (so they are optional for the
 * consumer)
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


#define PROTOCOLCLASS_INTERFACE( name, ...)  \
_Pragma("clang diagnostic push")             \
@class name;                                 \
@protocol name < NSObject, __VA_ARGS__ >     \
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

//
// these methods must not be overriden
// the runtime will replace any [foo alloc] call
// with a C function (with -O2 or better)
//
- (NSZone *) zone   __attribute__((deprecated("zones have no meaning and will eventually disappear")));  // always NULL

- (instancetype) retain;
- (void) release;
- (instancetype) autorelease;
- (NSUInteger) retainCount;

// some mulle additions for AAO mode and complete ObjectGraph support

// AAO suport
+ (instancetype) instantiate;
- (instancetype) immutableInstance;

// ObjectGraph support
- (id) _becomeRootObject;
- (void) _pushToParentAutoreleasePool;

@end



static inline id   MulleObjCObjectRetain( id obj)
{
   return( mulle_objc_object_retain_inline( obj));
}


static inline void   MulleObjCObjectRelease( id obj)
{
   return( mulle_objc_object_release_inline( obj));
}

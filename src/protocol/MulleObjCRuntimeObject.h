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


#define MULLE_OBJC_CLASS_DEPENDENCY( classname) \
      { @selector( classname), MULLE_OBJC_NO_CATEGORYID }
#define MULLE_OBJC_CATEGORY_DEPENDENCY( classname, categoryname) \
      { @selector( classname), @selector( categoryname) }
#define MULLE_OBJC_LIBRARY_DEPENDENCY( libname) \
      { @selector( MulleObjCLoader), @selector( libname) }

#define MULLE_OBJC_NO_DEPENDENCY  \
      { MULLE_OBJC_NO_CLASSID, MULLE_OBJC_NO_CATEGORYID }



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


/*
 * Helper macros to declare protocol classes
 */
#define PROTOCOLCLASS_INTERFACE0( name)  \
@class name;                             \
@protocol name

#define PROTOCOLCLASS_INTERFACE( name, ...)  \
@class name;                                 \
@protocol name < __VA_ARGS__ >


#define PROTOCOLCLASS_END()   @end



#define PROTOCOLCLASS_IMPLEMENTATION( name)  \
@interface name < name>                      \
@end                                         \
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


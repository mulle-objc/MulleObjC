// include on demand only (catch old code)
#ifdef MULLE_OBJC_RUNTIME_OBJECT_DEPRECATED

#define MULLE_OBJC_MAKE_CLASSID( classname)       @selector( classname)
#define MULLE_OBJC_MAKE_CATEGORYID( categoryname) @selector( categoryname)

// These macros are outdated, use the `@dependency` directive now.
//
#define MULLE_OBJC_CLASS_DEPENDENCY( classname) \
      { MULLE_OBJC_MAKE_CLASSID( classname), MULLE_OBJC_NO_CATEGORYID }
#define MULLE_OBJC_CATEGORY_DEPENDENCY( classname, categoryname) \
      { MULLE_OBJC_MAKE_CLASSID( classname), MULLE_OBJC_MAKE_CATEGORYID( categoryname) }
#define MULLE_OBJC_LIBRARY_DEPENDENCY( libname) \
      { MULLE_OBJC_MAKE_CLASSID( MulleObjCDeps), MULLE_OBJC_MAKE_CATEGORYID( libname) }

#define MULLE_OBJC_NO_DEPENDENCY  \
      { MULLE_OBJC_NO_CLASSID, MULLE_OBJC_NO_CATEGORYID }


/*
 * Old helper macros to declare protocol classes.  But use
 * @protocol_interface, @protocol_implementation, @protocol_class now.
 */
#define _PROTOCOLCLASS_INTERFACE0( name)                       \
@protocol_interface name


#define PROTOCOLCLASS_INTERFACE0( name)                        \
@protocol_interface name < NSObject>


#define _PROTOCOLCLASS_INTERFACE( name, ...)                   \
@protocol_interface name __VA_OPT__(< __VA_ARGS__ >)


#define PROTOCOLCLASS_INTERFACE( name, ...)                    \
@protocol_interface name < NSObject __VA_OPT__(, __VA_ARGS__) >


#define PROTOCOLCLASS_END()                                    \
@end



#define PROTOCOLCLASS_IMPLEMENTATION( name)                    \
@protocol_implementation  name                                 \




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



#endif


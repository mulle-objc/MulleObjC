//
//  MulleObjCRuntimeObjectDeprecated.h
//  MulleObjC
//
//  Copyright (c) 2026 Nat! - Mulle kybernetiK.
//  All rights reserved.
//
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//
//  Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  Neither the name of Mulle kybernetiK nor the names of its contributors
//  may be used to endorse or promote products derived from this software
//  without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.
//
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
 * @mixin, @implementation, @protocol_class now.
 * These actually need C23 for __VA_OPT__ so avoid.
 */
#if MULLE_C_HAS_VA_OPT

#define _PROTOCOLCLASS_INTERFACE0( name)                       \
@mixin name


#define PROTOCOLCLASS_INTERFACE0( name)                        \
@mixin name < NSObject>


#define _PROTOCOLCLASS_INTERFACE( name, ...)                   \
@mixin name __VA_OPT__(< __VA_ARGS__ >)


#define PROTOCOLCLASS_INTERFACE( name, ...)                    \
@mixin name < NSObject __VA_OPT__(, __VA_ARGS__) >


#define PROTOCOLCLASS_END()                                    \
@end

#define PROTOCOLCLASS_IMPLEMENTATION( name)                    \
@implementation  name

#else

#warning "deprecated protocolclass macros are unvailable as compiler does not support __VA_OPT__"

#endif



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


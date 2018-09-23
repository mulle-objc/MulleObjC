//
//  ns_compiler.h
//  MulleObjC
//
//  Created by Nat! on 23.02.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
//

// This should be includeable by C and not require linkage with MulleObjC

#ifndef NSCompiler_h__
#define NSCompiler_h__

//
// currently these adornments are not used in MulleObjC Foundation (yet)
// but it's convenient to have them for user code. They are used for static
// analysis of retain/release code
//
#if ! defined( __clang__)

#ifndef __has_feature          // Optional.
# if defined( __GNUC__)
#  define __has_feature( x) 1   // Assume gcc can do
# else
#  define __has_feature( x) 0   // Assume non-clang, non-gcc can't
# endif
# define __mulle_undef_has_feature
#endif

#ifndef __has_attribute
# define __has_attribute( x) 0
# define __mulle_undef_has_attribute
#endif

#endif


#ifndef NS_RETURNS_NOT_RETAINED
# if __has_feature( attribute_mulle_objc_returns_not_retained)
#  define NS_RETURNS_NOT_RETAINED __attribute__(( ns_returns_not_retained))
# else
#  define NS_RETURNS_NOT_RETAINED
# endif
#endif


#ifndef NS_RETURNS_RETAINED
# if __has_feature( attribute_mulle_objc_returns_retained)
#  define NS_RETURNS_RETAINED __attribute__(( ns_returns_retained))
# else
#  define NS_RETURNS_RETAINED
# endif
#endif


#ifndef NS_RELEASES_ARGUMENT
# if __has_feature( attribute_mulle_objc_consumed)
#  define NS_RELEASES_ARGUMENT   __attribute__(( ns_consumed))
# else
#  define NS_RELEASES_ARGUMENT
# endif
#endif


#ifndef NS_CONSUMED
# if __has_feature( attribute_mulle_objc_consumed)
#  define NS_CONSUMED   __attribute__(( ns_consumed))
# else
#  define NS_CONSUMED
# endif
#endif


#ifndef NS_CONSUMES_SELF
# if __has_feature( attribute_mulle_objc_consumes_self)
#  define NS_CONSUMES_SELF   __attribute__(( ns_consumes_self))
# else
#  define NS_CONSUMES_SELF
# endif
#endif


//
// get rid of hax if needed
//
#ifdef undef_has_feature
# undef __has_feature
# undef undef_has_feature
#endif

#ifdef undef_has_attibute
# undef __has_attribute
# undef undef_has_attibute
#endif

#endif /* ns_compiler_h */

#ifndef mulle_objc_include_h__
#define mulle_objc_include_h__

/* This is a central include file to keep dependencies out of the library
   C files. It is usally included by .h files only.

   The advantage is that now .c and .h files become motile. They can
   be moved to other projects and don't need to be edited. Also less typing...

   Therefore it is important that this file is called "include.h" and
   not "MulleObjC-include.h" to keep the #include statements in the
   library code uniform.

   The C-compiler will pick up the nearest one.
*/

/* Include the header file automatically generated by c-sourcetree-update.
   Here the prefix is harmless and serves disambiguation. If you have no
   sourcetree, then you don't need it.
 */

// if the "real" foundation has defined this, don't use the builtin stuff


#include <mulle-core/mulle-core.h>


#ifdef MULLE_OBJC_BUILD
# define MULLE_OBJC_GLOBAL    MULLE_C_GLOBAL
#else
# if defined( MULLE_OBJC_INCLUDE_DYNAMIC) || (defined( MULLE_INCLUDE_DYNAMIC) && ! defined( MULLE_OBJC_INCLUDE_STATIC))
#  define MULLE_OBJC_GLOBAL   MULLE_C_EXTERN_GLOBAL
# else
#  define MULLE_OBJC_GLOBAL   extern
# endif
#endif


/* You can add some more include statements here */

#include <assert.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <limits.h>


#ifdef __clang__
# if defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) && ((__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__-0) <= 1040)
#  if ! __DARWIN_UNIX03
#   warning "compiling for 10.4 (not __DARWIN_UNIX03), with __eprintf"
#  endif
# endif
#endif

#endif

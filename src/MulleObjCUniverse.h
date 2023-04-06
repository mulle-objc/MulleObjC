//
//  MulleObjCUniverse.h
//  MulleObjC
//
//  Created by Nat! on 29.03.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
//

// This must be compiled with the mulle-clang compiler to get the
// __MULLE_OBJC_UNIVERSEID__

#ifndef MulleObjCUniverse__h__
#define MulleObjCUniverse__h__

#include "mulle-objc.h"


MULLE_C_CONST_NONNULL_RETURN
static inline struct _mulle_objc_universe  *MulleObjCGetUniverse( void)
{
   return( mulle_objc_global_get_universe_inline( __MULLE_OBJC_UNIVERSEID__));
}


MULLE_C_CONST_NONNULL_RETURN
static inline struct _mulle_objc_universe  *MulleObjCObjectGetUniverse( id self)
{
   if( ! self)
      return( mulle_objc_global_get_universe_inline( __MULLE_OBJC_UNIVERSEID__));

   return( _mulle_objc_object_get_universe( self));
}

#endif

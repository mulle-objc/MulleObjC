//
//  MulleStandaloneObjC.c
//  MulleObjC
//
//  Created by Nat! on 04.02.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "MulleStandaloneObjC.h"


static void   versionassert( struct _mulle_objc_runtime *runtime,
                             void *friend,
                             struct mulle_objc_loadversion *version)
{
   if( (version->foundation & ~0xFF) != (MULLE_OBJC_FOUNDATION_VERSION & ~0xFF))
      _mulle_objc_runtime_raise_inconsistency_exception( runtime, "mulle_objc_runtime %p: foundation version set to %x but runtime foundation is %x",
                                                        runtime,
                                                        version->foundation,
                                                        MULLE_OBJC_FOUNDATION_VERSION);
}


__attribute__((const))  // always returns same value (in same thread)
struct _mulle_objc_runtime  *__get_or_create_objc_runtime( void)
{
   struct _mulle_objc_runtime    *runtime;

   runtime = __mulle_objc_get_runtime();
   if( ! runtime)
      runtime = (*ns_root_setup)( versionassert);
   return( runtime);
}


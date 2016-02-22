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



/* 
 * it's just too convenient, to have this as the old name
 */
void   *_objc_msgForward( void *self, mulle_objc_methodid_t _cmd, void *_param)
{
   struct _mulle_objc_class   *cls;
   
   cls = _mulle_objc_object_get_isa( self);
   _mulle_objc_class_raise_method_not_found_exception( cls, _cmd);
   return( NULL);
}

struct _mulle_objc_method   NSObject_msgForward_method =
{
   MULLE_OBJC_FORWARD_METHODID,  // forward:
   "forward:",
   "@@:@",
   0,
   
   _objc_msgForward
};



__attribute__((const))  // always returns same value (in same thread)
struct _mulle_objc_runtime  *__get_or_create_objc_runtime( void)
{
   struct _mulle_objc_runtime           *runtime;
   static struct _ns_root_setupconfig   config =
   {
      versionassert,
      &NSObject_msgForward_method,
      NULL
   };
   
   runtime = __mulle_objc_get_runtime();
   if( ! runtime->version)
      (*ns_root_setup)( runtime, &config);
   return( runtime);
}


//
//  MulleDynamicObject.m
//  MulleObjC
//
//  Copyright (c) 2020 Nat! - Mulle kybernetiK.
//  Copyright (c) 2020 Codeon GmbH.
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
#import "NSObject.h"

//
// The convenient superclass of all "non-value" and "non-container" objects.
//
// This allows us to add properties via categories.
// You declare them with @property( dynamic) int foo; in the @interface
// and @dynamic foo; in the @implementation of a category on MulleDynamicObject.
//
// For this scheme to work, there must be NSValue and NSNumber classes present
// in the runtime. Otherwise you can only store NSInteger, NSUInteger, char *
// and any object (but not NSRange or floating point values or any integer
// exceeding the sizeof( void *)
//
@interface MulleDynamicObject : NSObject
{
   struct mulle__pointermap   __ivars;      // use __ to "hide" it
}

//
// You MUST NOT call [super forward:] to inherit this. See NSObject
// forward: for more details. Your subclass may want to code it's forward:
// method like this:
//
// ``` objc
// - (void *) forward:(void *) args
// {
//    void   *rval;
//    int    fail = 0;
//   
//    rval = _MulleDynamicObjectForward( self, _cmd, param, &fail);
//    if( ! fail)
//       return( rval);
//    ...
//    // your code here
//
- (void *) forward:(void *) args;


//
// -isFullyDynamic set to YES creates descriptors on the fly
// and guesses their type to be id.
// The created descriptors are global and will affect everything. If your
// registration of -myIntValue comes later in a NSBundle, it's tough luck.
// The signature is already set to '@'.
//
// -isFullyDynamic is a non-thread safe global for performance reasons.
//
// Only override with a category!, don't override in a subclass! (As this
// would obscure the actual extent of what this does). The idea is that
// this is a global switch, that will affect all objects in the program.
// It's supposed to be a "design" decision.
//
+ (BOOL) isFullyDynamic;

@end

#define MULLE_DYNAMIC_OBJECT_FORWARD_SUPERID   ((mulle_objc_superid_t) 0x4d6bf14f)  // 'MulleDynamicObject;forward:'


typedef NS_ENUM(NSInteger, MulleObjCGenericType)
{
    MulleObjCGenericTypeVoidPointer = 0,  // as is
    MulleObjCGenericTypeStrdup,           // strdup/free
    MulleObjCGenericTypeAssign,           // just like void pointer
    MulleObjCGenericTypeRetain,           // retain/autorelease
    MulleObjCGenericTypeCopy,             // copy/autorelease
    MulleObjCGenericTypeValue,            // wrap into NSValue
    MulleObjCGenericTypeNumber            // wrap into NSValue
};



MULLE_C_NONNULL_FIRST_FOURTH 
MULLE_OBJC_GLOBAL
void   _MulleDynamicObjectValueSetter( MulleDynamicObject *self, SEL selector, void *_param, char *objcType);

MULLE_C_NONNULL_FIRST_FOURTH 
MULLE_OBJC_GLOBAL
void   _MulleDynamicObjectNumberSetter( MulleDynamicObject *self, SEL selector, void *_param, char *objcType);

MULLE_C_NONNULL_FIRST 
MULLE_OBJC_GLOBAL
void   _MulleDynamicObjectValueGetter( MulleDynamicObject *self, SEL selector, void *_param);


MULLE_C_NONNULL_FIRST 
MULLE_OBJC_GLOBAL
struct _mulle_objc_property  *_MulleObjCClassPointerSearchDynamicProperty( struct _mulle_objc_infraclass **infra_p,
                                                                           mulle_objc_methodid_t methodid);

MULLE_C_NONNULL_FIRST 
MULLE_OBJC_GLOBAL
MulleObjCGenericType
   _MulleObjCGenericTypeOfProperty( struct _mulle_objc_property *property);

MULLE_C_NONNULL_FIRST 
MULLE_OBJC_GLOBAL
MulleObjCGenericType   _MulleObjCGenericTypeOfSignature( char *signature);



MULLE_C_STATIC_ALWAYS_INLINE
void   *_MulleDynamicObjectForward( id self, SEL _cmd, void *args, int *fail)
{
   struct _mulle_objc_property     *property;
   mulle_objc_implementation_t     imp;
   struct _mulle_objc_infraclass   *infra;
   struct _mulle_objc_class        *cls;
   struct _mulle_objc_method       *method;
   mulle_objc_methodid_t           sel;
   struct _mulle_objc_method *
      _mulle_objc_infraclass_create_methods_for_property( struct _mulle_objc_infraclass *infra,
                                                          struct _mulle_objc_property *property,
                                                          mulle_objc_methodid_t neededSel);

   assert( fail && ! *fail); // callers obligation

   cls   = _mulle_objc_object_get_non_tps_isa( self);
   infra = _mulle_objc_class_as_infraclass( cls);
   sel   = (mulle_objc_methodid_t) _cmd;

   // if property was found, infra is changed to the infra class where we found the
   // property, thats where we need to place the methodlist, if property is NULL
   // infra is unchanged
   property = _MulleObjCClassPointerSearchDynamicProperty( &infra, sel);
   if( property)
   {
      method   = _mulle_objc_infraclass_create_methods_for_property( infra, property, sel);
      imp      = _mulle_objc_method_get_implementation( method);
      return( mulle_objc_implementation_invoke( imp, self, sel, args));
   }

#ifdef HAVE_FULLY_DYNAMIC_MULLE_DYNAMIC_OBJECT
   if( [(Class) infra isFullyDynamic])
   {
      struct _mulle_objc_method *
         _mulle_objc_infraclass_create_accessor_methods( struct _mulle_objc_infraclass *infra,
                                                         mulle_objc_methodid_t neededSel);

      // we can not create a property dynamically though, because it's not clear where
      // to place it (directly on MulleDynamicObject ?)
      method = _mulle_objc_infraclass_create_accessor_methods( infra, sel);
      if( method)
      {
         imp   = _mulle_objc_method_get_implementation( method);
         return( mulle_objc_implementation_invoke( imp, self, sel, args));
      }
   }
#endif
   *fail = 1;
   return( NULL);
}

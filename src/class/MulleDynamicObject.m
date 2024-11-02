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
#import "MulleDynamicObject.h"

#import "MulleObjCProtocol.h"

#import "import-private.h"
#include <ctype.h>


#define HAVE_FULLY_DYNAMIC_MULLE_DYNAMIC_OBJECT

// NEW MASTERPLAN:
//    *   generate actual properties dynamically and put them into the runtime
//        for dynamic access. Also create methods, the implementations should
//        be uniform so we can draw from a preset set of C methods.
//
// TODO: conceivably should query the universe for the "number" and "value"
//       class, like the string class is also defined in the universe
//
// Bonus future idea: Each category can have
//                    initCategory/finalizeCategory/deallocCategory methods.
//                    these will be called during "init"/"finalize"/"dealloc".
//                    Simple to implemement: collect direct categories only
//                    call in "normal" order for init, call in "reverse" order
//                    for dealloc and finalize
//
// forward decl
#ifndef NSVALUE_DEFINED
@interface NSValue : NSObject

- (instancetype) initWithBytes:(void *) args
                      objCType:(char *) signature;

- (void) getValue:(void *) arg;
- (char *) objCType;

+ (IMP) setterForProperty:(struct _mulle_objc_property *) property
                  ofClass:(Class) cls;

@end
#endif

@interface NSValue( MulleObjectFuture)

+ (IMP) setterImplementationForObjCType:(char *) type
                           accessorBits:(NSUInteger) bits;
+ (IMP) getterImplementationObjCType:(char *) type
                        accessorBits:(NSUInteger) bits;

@end


// forward decl
#ifndef NSNUMBER_DEFINED
@interface NSNumber : NSValue
@end
#endif

static mulle_objc_implementation_t
   _NSClassAccessorImplementationForObjCType( struct _mulle_objc_infraclass *infra,
                                              mulle_objc_methodid_t methodid,
                                              char *type,
                                              NSUInteger bits)
{
   struct _mulle_objc_metaclass    *meta;
   struct _mulle_objc_class        *cls;
   mulle_objc_implementation_t     imp;
   mulle_objc_implementation_t     setter;

   setter = 0;
   meta   = _mulle_objc_infraclass_get_metaclass( infra);
   cls    = _mulle_objc_metaclass_as_class( meta);
   mulle_objc_class_clobberchain_for( cls, methodid, imp)
   {
      mulle_metaabi_union_voidptr_return( struct { char *type; NSUInteger bits;})  param;

      param.p.type = type;
      param.p.bits = bits;

      setter = mulle_objc_implementation_invoke( imp, infra, methodid, &param);
      if( setter)
         break;
   }
   return( setter);
}


// NSValue

static mulle_objc_implementation_t
   _NSValueAccessorImplementationForObjCType( mulle_objc_methodid_t methodid,
                                              char *type,
                                              NSUInteger bits)
{
   return( _NSClassAccessorImplementationForObjCType( (struct _mulle_objc_infraclass *) [NSValue class],
                                                      methodid,
                                                      type,
                                                      bits));
}


static mulle_objc_implementation_t
   _NSValueSetterImplementationForProperty( struct _mulle_objc_property *property)
{
   return( _NSValueAccessorImplementationForObjCType( @selector( setterImplementationObjCType:accessorBits:),
                                                      _mulle_objc_property_get_signature( property),
                                                      _mulle_objc_property_get_bits( property)));

}


static mulle_objc_implementation_t
   _NSValueGetterImplementationForProperty( struct _mulle_objc_property *property)
{
   return( _NSValueAccessorImplementationForObjCType( @selector( getterImplementationObjCType:accessorBits:),
                                                      _mulle_objc_property_get_signature( property),
                                                      _mulle_objc_property_get_bits( property)));

}


// NSNumber
static mulle_objc_implementation_t
   _NSNumberAccessorImplementationForObjCType( SEL sel,
                                               char *type,
                                               NSUInteger bits)
{
   return( _NSClassAccessorImplementationForObjCType( (struct _mulle_objc_infraclass *) [NSNumber class],
                                                      (mulle_objc_methodid_t) sel,
                                                      type,
                                                      bits));
}


static mulle_objc_implementation_t
   _NSNumberSetterImplementationForProperty( struct _mulle_objc_property *property)
{
   return( _NSNumberAccessorImplementationForObjCType( @selector( setterImplementationObjCType:accessorBits:),
                                                       _mulle_objc_property_get_signature( property),
                                                       _mulle_objc_property_get_bits( property)));
}


static mulle_objc_implementation_t
   _NSNumberGetterImplementationForProperty( struct _mulle_objc_property *property)
{
   return( _NSNumberAccessorImplementationForObjCType( @selector( getterImplementationObjCType:accessorBits:),
                                                       _mulle_objc_property_get_signature( property),
                                                       _mulle_objc_property_get_bits( property)));
}


@implementation MulleDynamicObject

static struct _mulle_objc_super   OBJECT_forward =
{
   .superid  = MULLE_DYNAMIC_OBJECT_FORWARD_SUPERID,
   .name     = "MulleDynamicObject;forward:",
   .classid  = @selector( MulleDynamicObject),
   .methodid = @selector( forward:)
};

//
// in case there are setter, adder, remove functions that map to a different
// getter, we will notice that it's not in _getter_lookup. Instead we need to
// use a slower and more complex scheme (lookup property and find it)
// Because this is super unlikely, we warn about this and do not maintain
// a second cache.
//
static struct
{
   struct mulle_concurrent_hashmap   _getter_lookup;
   int                               _initialized;
} Self;


+ (void) initialize
{
   struct _mulle_objc_universe   *universe;
   struct mulle_allocator        *allocator;

   if( Self._initialized)
      return;

   Self._initialized = 1;

   universe = _mulle_objc_infraclass_get_universe( self),
   mulle_objc_universe_register_super_nofail( universe, &OBJECT_forward);

   //
   // can not use regular allocator, as it can be replaced with the
   // testallocator which is not mulle-aba aware
   //
   allocator = _mulle_objc_universe_get_allocator( universe);
   _mulle_concurrent_hashmap_init( &Self._getter_lookup, 0, allocator);

}


+ (void) deinitialize
{
   if( Self._initialized)
   {
      _mulle_concurrent_hashmap_done( &Self._getter_lookup);
      Self._initialized = 0;
   }
}

#ifdef HAVE_FULLY_DYNAMIC_MULLE_DYNAMIC_OBJECT
+ (BOOL) isFullyDynamic; // defaults to NO
{
   return( NO);
}
#endif


// TODO: we need some standard wraps for NSRange, CGPoint, CGRect (e.g. intptr[ 2], float[2], float[4])
//       otherwise its too slow for UIKit
//
enum generic_type
{
//   is_invalid = -1,
   is_void_pointer = 0,  // as is
   is_strdup,            // strdup/free
   is_assign,            // just like void pointer
   is_retain,            // retain/autorelease
   is_copy,              // copy/autorelease
   is_value,             // wrap into NSValue (argh)
   is_number             // wrap into NSValue (argh)
};


enum generic_type   generic_type_for_signature( char *signature)
{
   char  *type;

   type = _mulle_objc_signature_skip_type_qualifier( signature);
   switch( *type)
   {
//   case 0            :  // can't happen
//   case _C_ATOM      :  // not compiler generated
//   case _C_BFLD      :  // can't happen because not a valid rval
//   case _C_VOID      :  // can't be a getter then
//   case _C_UNDEF     :  // sued for ^? and {?} but not alone
//       return( is_invalid);

   case _C_CLASS     :
   case _C_ASSIGN_ID : return( is_assign);
   case _C_RETAIN_ID : return( is_retain);
   case _C_COPY_ID   : return( is_copy);
   case _C_CHARPTR   : return( is_strdup);

   case _C_SEL       :
   case _C_CHR       :
   case _C_UCHR      :
   case _C_SHT       :
   case _C_USHT      :
   case _C_INT       :
   case _C_UINT      :
   case _C_BOOL      :
                       return( is_void_pointer);

   case _C_LNG       : if( mulle_metaabi_is_voidptr_storage_compatible( long))
                         return( is_void_pointer);
                       return( is_number);
                       // wrap it
   case _C_ULNG      : if( mulle_metaabi_is_voidptr_storage_compatible( unsigned long))
                         return( is_void_pointer);
                       return( is_number);

   case _C_LNG_LNG   : if( mulle_metaabi_is_voidptr_storage_compatible( long long))
                         return( is_void_pointer);
                       return( is_number);

   case _C_ULNG_LNG  : if( mulle_metaabi_is_voidptr_storage_compatible( unsigned long long))
                         return( is_void_pointer);
                       return( is_number);

   case _C_DBL       : return( is_number);
   case _C_FLT       : return( is_number);
   case _C_LNG_DBL   : return( is_number);

   case _C_PTR       : if( type[ 1] == '?')
                          return( is_void_pointer);
                       if( mulle_metaabi_is_voidptr_storage_compatible( void( *)( void)))
                         return( is_void_pointer);
                       return( is_value);

   default           : ;
   }

   return( is_value);
}

#if 0
static inline enum generic_type   generic_type_for_getter_signature( char *signature)
{
   return( generic_type_for_signature( signature));
}


static enum generic_type   generic_type_for_setter_signature( char *signature)
{
   char   *type;

// memo: skip return value, skip self, skip _cmd
   type = mulle_objc_signature_next_type( signature);
   type = mulle_objc_signature_next_type( type);
   type = mulle_objc_signature_next_type( type);
   return( generic_type_for_signature( type));
}


static inline enum generic_type   generic_type_for_adder_signature( char *signature)
{
   return( generic_type_for_setter_signature( signature));
}


static inline enum generic_type   generic_type_for_remover_signature( char *signature)
{
   return( generic_type_for_setter_signature( signature));
}
#endif


static inline enum generic_type
   generic_type_for_property( struct _mulle_objc_property *property)
{
   char                *signature;
   enum generic_type   ivarType;

   if( _mulle_objc_property_get_bits( property) & _mulle_objc_property_retain)
      return( is_retain);
   if( _mulle_objc_property_get_bits( property) & _mulle_objc_property_copy)
      return( is_copy);

   signature    = _mulle_objc_property_get_signature( property);
   ivarType     = generic_type_for_signature( signature);
   return( ivarType == is_retain ? is_assign : ivarType);
}



/*
 *  given a method id, find a dynamic property that has this as a
 *  getter/setter/adder/remover
 */
struct search_methodid_context
{
    mulle_objc_methodid_t         methodid;
    struct _mulle_objc_property   *property;
    struct _mulle_objc_infraclass *infra;
};


static inline struct search_methodid_context   search_methodid_context_make( mulle_objc_methodid_t methodid)
{
   return( (struct search_methodid_context) { .methodid = methodid });
}


static mulle_objc_walkcommand_t
   search_methodid( struct _mulle_objc_property *property,
                    struct _mulle_objc_infraclass *infra,
                    void *userinfo)
{
   struct search_methodid_context   *ctx = userinfo;

   if( ! _mulle_objc_property_is_dynamic( property))
      return( mulle_objc_walk_ok);

   if( _mulle_objc_property_get_getter( property) != ctx->methodid)
   {
      if( _mulle_objc_property_is_readonly( property))
         return( mulle_objc_walk_ok);

      if( _mulle_objc_property_get_setter( property)  != ctx->methodid &&
          _mulle_objc_property_get_adder( property)   != ctx->methodid &&
          _mulle_objc_property_get_remover( property) != ctx->methodid)
      {
         return( mulle_objc_walk_ok);
      }
   }

   ctx->property = property;
   ctx->infra    = infra;
   return( mulle_objc_walk_done);
}


MULLE_C_NEVER_INLINE
static struct _mulle_objc_property  *search_dynamic_property( struct _mulle_objc_infraclass **infra_p,
                                                              mulle_objc_methodid_t methodid)
{
   mulle_objc_walkcommand_t         cmd;
   struct search_methodid_context   ctxt;
   struct _mulle_objc_infraclass    *infra = *infra_p;
   unsigned int                     inheritance;

   ctxt        = search_methodid_context_make( methodid);

   // when we are a subclass of MulleObject the infra class is setup
   // to not find anything, therefore we allow everything here.
   inheritance = 0;
   cmd         = _mulle_objc_infraclass_walk_properties( infra,
                                                         inheritance,
                                                         search_methodid,
                                                         &ctxt);
   if( cmd == mulle_objc_walk_done)
   {
      *infra_p = infra;
      return( ctxt.property);
   }
   return( NULL);
}



- (instancetype) init
{
   // this maps getter SEL to value
   _mulle__pointermap_init( &self->__ivars, 0, MulleObjCInstanceGetAllocator( self));
   return( self);
}


static inline void  release_generic_value( struct mulle__pointermap *map,
                                           struct mulle_pointerpair *pair,
                                           struct _mulle_objc_property *property,
                                           struct mulle_allocator *allocator)
{
   enum generic_type   type;

   //
   // descriptor is always the "value" getter
   // key is the value selector
   //
   if( property)
   {
      type = generic_type_for_property( property);
      if( type == is_void_pointer)
         return;

      if( type == is_strdup)
      {
         mulle_allocator_free( allocator, pair->value);
         return;
      }
   }
   [(id) pair->value autorelease];
}


- (void) finalize
{
   struct mulle_allocator              *allocator;
   struct mulle__pointermapenumerator  rover;
   struct mulle_pointerpair            pair;
   struct _mulle_objc_infraclass       *infra;
   struct _mulle_objc_class            *cls;
   struct _mulle_objc_property         *property;

   // this will have called _MulleObjCInstanceClearProperties( self, NO);
   // so what is left, to clear ?
   [super finalize]; // call anywhere you like

   cls       = _mulle_objc_object_get_non_tps_isa( self);
   allocator = MulleObjCInstanceGetAllocator( self);
   rover     = mulle__pointermap_enumerate( &self->__ivars);
   while( _mulle__pointermapenumerator_next_pair( &rover, &pair))
   {
      if( ! pair.value)
         continue;

      infra    = _mulle_objc_class_as_infraclass( cls);
      // this is a "choke" point: best solution would be to have a
      // per infraclass property cache to speed this up
      property = search_dynamic_property( &infra, (mulle_objc_methodid_t) (uintptr_t) pair.key);
      release_generic_value( &self->__ivars, &pair, property, allocator);
   }
   _mulle__pointermapenumerator_done( &rover);

   _mulle__pointermap_reset( &self->__ivars, allocator);
}


- (void) dealloc
{
   _mulle__pointermap_done( &self->__ivars, MulleObjCInstanceGetAllocator( self));

   [super dealloc];  // call at end
}



// keep in index order of fields, for compiler to optimize...

static inline void   *MulleObjectGetKeyForSelector( MulleDynamicObject *self, mulle_objc_methodid_t _cmd)
{
   void                            *key;
   void                            *getterSel;
   struct _mulle_objc_property     *property;
   struct _mulle_objc_class        *cls;
   struct _mulle_objc_infraclass   *infra;

   key =  _mulle_concurrent_hashmap_lookup( &Self._getter_lookup, (uintptr_t) _cmd);
   assert( key);
   if( key != (void *) (uintptr_t) MULLE_OBJC_INVALID_METHODID)
      return( key);

   cls       = _mulle_objc_object_get_non_tps_isa( self);
   infra     = _mulle_objc_class_as_infraclass( cls);
   property  = search_dynamic_property( &infra, _cmd);  // infra will change to its parent infraclass
   getterSel = (void *) (uintptr_t) _mulle_objc_property_get_getter( property);
   return( getterSel);
}


//
// GET ACCESSORS (need willReadRelationship code for object)
//
MULLE_C_NONNULL_FIRST
static void   *_MulleObjectVoidPointerGetter( MulleDynamicObject *self,
                                              mulle_objc_methodid_t _cmd,
                                              void *_param)
{
   void   *value;

   value = _mulle__pointermap_get( &self->__ivars, (void *) (uintptr_t) _cmd);
   return( value);
}


MULLE_C_NONNULL_FIRST
static void   *_MulleObjectAssignGetterWillReadRelationship( MulleDynamicObject *self,
                                                             mulle_objc_methodid_t _cmd,
                                                             void *_param)
{
   id                       old;
   id                       changed;
   struct mulle_allocator   *allocator;

   old     = _mulle__pointermap_get( &self->__ivars, (void *) (uintptr_t) _cmd);
   changed = _mulle_objc_object_call_inline_full( self, MULLE_OBJC_WILLREADRELATIONSHIP_METHODID, old);
   if( old != changed)
   {
      allocator = MulleObjCInstanceGetAllocator( self);
      _mulle__pointermap_set( &self->__ivars, (void *) (uintptr_t) _cmd, changed, allocator);
   }
   return( changed);
}

// this is also used by
MULLE_C_NONNULL_FIRST
static void   *_MulleObjectRetainGetterWillReadRelationship( MulleDynamicObject *self,
                                                             mulle_objc_methodid_t _cmd,
                                                             void *_param)
{
   id                       old;
   id                       changed;
   struct mulle_allocator   *allocator;

   old     = _mulle__pointermap_get( &self->__ivars, (void *) (uintptr_t) _cmd);
   changed = _mulle_objc_object_call_inline_full( self, MULLE_OBJC_WILLREADRELATIONSHIP_METHODID, old);
   if( old != changed)
   {
      [old autorelease];
      changed   = [changed retain];
      allocator = MulleObjCInstanceGetAllocator( self);
      _mulle__pointermap_set( &self->__ivars, (void *) (uintptr_t) _cmd, changed, allocator);
   }
   return( changed);
}


void   _MulleDynamicObjectValueGetter( MulleDynamicObject *self,  mulle_objc_methodid_t _cmd,  void *_param)
{
   id     value;

   // this is superslow, as we walk all properties worst case... so CGRect will suffer badly
   value = _mulle__pointermap_get( &self->__ivars, (void *) (uintptr_t) _cmd);
   [value getValue:_param];
}


//
// SET ACCESSORS (need willReadRelationship code for object)
//
MULLE_C_NONNULL_FIRST
static void   _MulleObjectVoidPointerSetter( MulleDynamicObject *self,
                                             mulle_objc_methodid_t _cmd,
                                             void *_param)
{
   void                     *key;
   struct mulle_allocator   *allocator;

   key       = MulleObjectGetKeyForSelector( self, _cmd);
   allocator = MulleObjCInstanceGetAllocator( self);
   _mulle__pointermap_set( &self->__ivars, key, _param, allocator);
}

MULLE_C_NONNULL_FIRST
static void   _MulleObjectVoidPointerSetterWillChange( MulleDynamicObject *self,
                                                       mulle_objc_methodid_t _cmd,
                                                       void *_param)
{
   _mulle_objc_object_call_inline_full( self, MULLE_OBJC_WILLCHANGE_METHODID, self);
   _MulleObjectVoidPointerSetter( self, _cmd, _param);
}


MULLE_C_NONNULL_FIRST
static void   _MulleObjectStrdupSetter( MulleDynamicObject *self,
                                        mulle_objc_methodid_t _cmd,
                                        void *_param)
{
   void                     *key;
   struct mulle_allocator   *allocator;
   char                     *old;
   char                     *value;

   key       = MulleObjectGetKeyForSelector( self, _cmd);
   allocator = MulleObjCInstanceGetAllocator( self);
   value     = mulle_allocator_strdup( allocator, _param);
   old       = _mulle__pointermap_update( &self->__ivars, key, value, allocator);
   mulle_allocator_free( allocator, old);
}


MULLE_C_NONNULL_FIRST
static void   _MulleObjectStrdupSetterWillChange( MulleDynamicObject *self,
                                                       mulle_objc_methodid_t _cmd,
                                                       void *_param)
{
   _mulle_objc_object_call_inline_full( self, MULLE_OBJC_WILLCHANGE_METHODID, self);
   _MulleObjectStrdupSetter( self, _cmd, _param);
}


MULLE_C_NONNULL_FIRST
static void   _MulleObjectRetainSetter( MulleDynamicObject *self,
                                        mulle_objc_methodid_t _cmd,
                                        void *_param)
{
   void                     *key;
   struct mulle_allocator   *allocator;
   id                        old;
   id                        value;

   allocator = MulleObjCInstanceGetAllocator( self);
   value     = [(id) _param retain];
   key       = MulleObjectGetKeyForSelector( self, _cmd);
   old       = _mulle__pointermap_update( &self->__ivars, key, value, allocator);
   [old autorelease];
}


MULLE_C_NONNULL_FIRST
static void   _MulleObjectRetainSetterWillChange( MulleDynamicObject *self,
                                                  mulle_objc_methodid_t _cmd,
                                                  void *_param)
{
   _mulle_objc_object_call_inline_full( self, MULLE_OBJC_WILLCHANGE_METHODID, self);
   _MulleObjectRetainSetter( self, _cmd, _param);
}


MULLE_C_NONNULL_FIRST
static void   _MulleObjectCopySetter( MulleDynamicObject *self,
                                      mulle_objc_methodid_t _cmd,
                                      void *_param)
{
   void                     *key;
   struct mulle_allocator   *allocator;
   id                       old;
   id                       value;

   allocator = MulleObjCInstanceGetAllocator( self);
   value     = [(id) _param copy];
   key       = MulleObjectGetKeyForSelector( self, _cmd);
   old       = _mulle__pointermap_update( &self->__ivars, key, value, allocator);
   [old autorelease];
}


MULLE_C_NONNULL_FIRST
static void   _MulleObjectCopySetterWillChange( MulleDynamicObject *self,
                                                mulle_objc_methodid_t _cmd,
                                                void *_param)
{
   _mulle_objc_object_call_inline_full( self, MULLE_OBJC_WILLCHANGE_METHODID, self);
   _MulleObjectCopySetter( self, _cmd, _param);
}


MULLE_C_NONNULL_FIRST
static void   _MulleObjectGenericValueSetter( MulleDynamicObject *self,
                                              mulle_objc_methodid_t _cmd,
                                              void *_param)
{
   void                            *key;
   struct mulle_allocator          *allocator;
   struct _mulle_objc_property     *property;
   struct _mulle_objc_infraclass   *infra;
   struct _mulle_objc_class        *cls;
   id                              old;
   id                              value;
   char                            *signature;

   // this is superslow, as we walk all properties worst case... so CGRect will suffer badly
   key       = MulleObjectGetKeyForSelector( self, _cmd);
   cls       = _mulle_objc_object_get_non_tps_isa( self);
   infra     = _mulle_objc_class_as_infraclass( cls);
   property  = search_dynamic_property( &infra, (uintptr_t) key);
   signature = _mulle_objc_property_get_signature( property);
   value     = [[NSValue alloc] initWithBytes:_param
                                     objCType:signature];
   allocator = MulleObjCInstanceGetAllocator( self);
   old       = _mulle__pointermap_update( &self->__ivars, key, value, allocator);
   [old autorelease];
}


MULLE_C_NONNULL_FIRST
static void   _MulleObjectGenericValueSetterWillChange( MulleDynamicObject *self,
                                                        mulle_objc_methodid_t _cmd,
                                                        void *_param)
{
   _mulle_objc_object_call_inline_full( self, MULLE_OBJC_WILLCHANGE_METHODID, self);
   _MulleObjectGenericValueSetter( self, _cmd, _param);
}


void   _MulleDynamicObjectValueSetter( MulleDynamicObject *self,
                                       SEL _cmd,
                                       void *_param,
                                       char *objcType)
{
   void                     *key;
   struct mulle_allocator   *allocator;
   id                       old;
   id                       value;

   key       = MulleObjectGetKeyForSelector( self, (mulle_objc_methodid_t) _cmd);
   value     = [[NSValue alloc] initWithBytes:_param
                                     objCType:objcType];
   allocator = MulleObjCInstanceGetAllocator( self);
   old       = _mulle__pointermap_update( &self->__ivars, key, value, allocator);
   [old autorelease];
}


void   _MulleDynamicObjectNumberSetter( MulleDynamicObject *self,
                                        SEL _cmd,
                                        void *_param,
                                        char *objcType)
{
   void                     *key;
   struct mulle_allocator   *allocator;
   id                       old;
   id                       value;

   // this is superslow, as we walk all properties worst case... so CGRect will suffer badly
   key       = MulleObjectGetKeyForSelector( self, _cmd);
   value     = [[NSNumber alloc] initWithBytes:_param
                                      objCType:objcType];
   allocator = MulleObjCInstanceGetAllocator( self);
   old       = _mulle__pointermap_update( &self->__ivars, key, value, allocator);
   [old autorelease];
}


enum mulle_objc_property_accessor_type
{
    mulle_objc_property_accessor_invalid = -1,
    mulle_objc_property_accessor_getter,
    mulle_objc_property_accessor_setter,
    mulle_objc_property_accessor_adder,
    mulle_objc_property_accessor_remover
};


static void
   _mulle_objc_method_init_getter( struct _mulle_objc_method *method,
                                   struct _mulle_objc_property *property,
                                   struct _mulle_objc_descriptor *desc,
                                   struct _mulle_objc_infraclass *infra)
{
   enum generic_type             ivarType;
   mulle_objc_implementation_t   imp;
   int                           isRelationship;

   ivarType       = generic_type_for_property( property);
   isRelationship = _mulle_objc_property_is_relationship( property);

   switch( ivarType)
   {
   case is_void_pointer : imp = (mulle_objc_implementation_t) _MulleObjectVoidPointerGetter;
                          break;
   case is_strdup       : imp = (mulle_objc_implementation_t) _MulleObjectVoidPointerGetter;
                          break;
   case is_assign       : imp = (mulle_objc_implementation_t)
                                (isRelationship
                                ? _MulleObjectAssignGetterWillReadRelationship
                                : _MulleObjectVoidPointerGetter);
                          break;
   case is_copy         : // let it slide...
   case is_retain       : imp = (mulle_objc_implementation_t)
                                (isRelationship
                                ? _MulleObjectRetainGetterWillReadRelationship
                                : _MulleObjectVoidPointerGetter);
                          break;
   case is_number       : imp = _NSNumberGetterImplementationForProperty( property);
                          if( imp)
                             break;
   // every thing else is wrapped in NSValue (we don't do willReadRelationship:)
   default              : imp = _NSValueGetterImplementationForProperty( property);
                          if( ! imp)
                              imp = (mulle_objc_implementation_t) _MulleDynamicObjectValueGetter;
                          break;
   }

   method->descriptor = *desc;  // why not
   method->value      = imp;
}


static void    register_getter_lookup( mulle_objc_methodid_t sel,
                                       struct _mulle_objc_property *property,
                                       struct _mulle_objc_infraclass *infra)
{
   struct _mulle_objc_universe   *universe;
   mulle_objc_methodid_t         getterSel;
   mulle_objc_methodid_t         otherSel;
   void                          *previous;

   getterSel = _mulle_objc_property_get_getter( property);

   //
   // if another setter already squats the space,
   //
   previous = _mulle_concurrent_hashmap_register( &Self._getter_lookup,
                                                  (uintptr_t) sel,
                                                  (void *) (uintptr_t ) getterSel);
   // insert worked, fine!
   if( ! previous)
      return;

   // already got a proper entry fine for this (from some other class)
   otherSel = (mulle_objc_methodid_t) (uintptr_t) previous;
   if( otherSel == getterSel)
      return;

   //
   // Insert did not work. So its a conflict, we should "poison" this
   // selector, so that a slow lookup is forced. (its no concurrency
   // problem yet, as we haven't added our method list yet)
   // Unfortunately there is no _mulle_concurrent_hashmap_set (yet), therefore
   // we would need to lock, which we don't want to do.
   // So we raise...
   universe = _mulle_objc_infraclass_get_universe( infra);
   mulle_objc_universe_fail_inconsistency( universe,
                                           "class %08x \"%s\" %s accessor "
                                           "%08x \"%s\" conflicts with accessor "
                                           "%08x \"%s\" of property "
                                           "\"%s\"",
                                           _mulle_objc_infraclass_get_classid( infra),
                                           _mulle_objc_infraclass_get_name( infra),
                                           sel,
                                           _mulle_objc_universe_describe_methodid( universe,
                                                                                   sel),
                                           otherSel,
                                           _mulle_objc_universe_describe_methodid( universe,
                                                                                   otherSel),
                                           _mulle_objc_property_get_name( property));
}


static void
   _mulle_objc_method_init_setter( struct _mulle_objc_method *method,
                                   struct _mulle_objc_property *property,
                                   struct _mulle_objc_descriptor *desc,
                                   struct _mulle_objc_infraclass *infra)
{
   enum generic_type             ivarType;
   mulle_objc_implementation_t   imp;
   int                           isObservable;

   ivarType     = generic_type_for_property( property);
   isObservable = _mulle_objc_property_is_observable( property);

   switch( ivarType)
   {
   case is_assign       :
   case is_void_pointer : imp = (mulle_objc_implementation_t)
                                (isObservable
                                ? _MulleObjectVoidPointerSetterWillChange
                                : _MulleObjectVoidPointerSetter);
                          break;
   case is_strdup       : imp = (mulle_objc_implementation_t)
                                (isObservable
                                ? _MulleObjectStrdupSetterWillChange
                                : _MulleObjectStrdupSetter);
                          break;
   case is_retain       : imp = (mulle_objc_implementation_t)
                                (isObservable
                                ? _MulleObjectRetainSetterWillChange
                                : _MulleObjectRetainSetter);
                          break;
   case is_copy         : imp = (mulle_objc_implementation_t)
                                (isObservable
                                ? _MulleObjectCopySetterWillChange
                                : _MulleObjectCopySetter);
                          break;
   case is_number       : imp = _NSNumberSetterImplementationForProperty( property);
                          if( imp)
                             break;
                          // fall thru (why not)
   case is_value        : imp = _NSValueSetterImplementationForProperty( property);
                          if( ! imp)
                              imp = (mulle_objc_implementation_t)
                                    (isObservable
                                    ? _MulleObjectGenericValueSetterWillChange
                                    : _MulleObjectGenericValueSetter);
                          break;
   }

   method->descriptor = *desc;  // why not
   method->value      = imp;

   register_getter_lookup( _mulle_objc_descriptor_get_methodid( &method->descriptor),
                           property,
                           infra);
}


MULLE_C_NO_RETURN
static void   retain_complain( struct _mulle_objc_property *property,
                               struct _mulle_objc_descriptor *desc,
                               struct _mulle_objc_infraclass *infra)
{
   struct _mulle_objc_universe   *universe;

   universe = _mulle_objc_infraclass_get_universe( infra);
   mulle_objc_universe_fail_inconsistency( universe,
                                           "A container accessor "
                                           "%08x \"%s\" of property "
                                           "%08x \"%s\" of class "
                                           "%08x \"%s\" "
                                           "can only be created for retained objects",
                                           _mulle_objc_descriptor_get_methodid( desc),
                                           _mulle_objc_descriptor_get_name( desc),
                                           _mulle_objc_property_get_propertyid( property),
                                           _mulle_objc_property_get_name( property),
                                           _mulle_objc_infraclass_get_classid( infra),
                                           _mulle_objc_infraclass_get_name( infra));

}


static void   _MulleObjectAdder( MulleDynamicObject *self,
                                 mulle_objc_methodid_t _cmd,
                                 void *_param)
{
   void                             *key;
   id <MulleObjCContainerProperty>  container;
   id                               value;

   key       = MulleObjectGetKeyForSelector( self, _cmd);
   container = _mulle__pointermap_get( &self->__ivars, key);
   value     = (id) _param;
   [container addObject:(id) value];
}


MULLE_C_NONNULL_FIRST
static void   _MulleObjectAdderWillChange( MulleDynamicObject *self,
                                           mulle_objc_methodid_t _cmd,
                                           void *_param)
{
   mulle_objc_object_call_inline_partial( self, MULLE_OBJC_WILLCHANGE_METHODID, self);
   _MulleObjectAdder( self, _cmd, _param);
}


MULLE_C_NONNULL_FIRST
static void   _MulleObjectAdderWillReadRelationship( MulleDynamicObject *self,
                                                     mulle_objc_methodid_t _cmd,
                                                     void *_param)
{
   id <MulleObjCContainerProperty>  container;
   void                             *key;
   id                               value;

   key       = MulleObjectGetKeyForSelector( self, _cmd);
   container = _MulleObjectRetainGetterWillReadRelationship( self, (mulle_objc_methodid_t) (uintptr_t) key, _param);
   value     = (id) _param;
   [container addObject:value];
}


MULLE_C_NONNULL_FIRST
static void   _MulleObjectAdderWillChangeAndReadRelationship( MulleDynamicObject *self,
                                                              mulle_objc_methodid_t _cmd,
                                                              void *_param)
{
   mulle_objc_object_call_inline_partial( self, MULLE_OBJC_WILLCHANGE_METHODID, self);
   _MulleObjectAdderWillReadRelationship( self, _cmd, _param);
}


MULLE_C_NONNULL_FIRST
static void
   _mulle_objc_method_init_adder( struct _mulle_objc_method *method,
                                  struct _mulle_objc_property *property,
                                  struct _mulle_objc_descriptor *desc,
                                  struct _mulle_objc_infraclass *infra)
{
   enum generic_type             ivarType;
   mulle_objc_implementation_t   imp;
   int                           isObservable;
   int                           isRelationship;


   assert( _mulle_objc_property_is_container( property));

   // lets allow copy, for some strange stuff i don't understand,
   // but its got to be an object
   ivarType = generic_type_for_property( property);
   if( ivarType != is_retain && ivarType != is_copy && ivarType != is_assign)
      retain_complain( property, desc, infra);

   isObservable   = _mulle_objc_property_is_observable( property);
   isRelationship = _mulle_objc_property_is_relationship( property);
   imp          = (mulle_objc_implementation_t)
                  (isObservable
                  ? (isRelationship ? _MulleObjectAdderWillChangeAndReadRelationship
                                    : _MulleObjectAdderWillChange)
                  : (isRelationship ? _MulleObjectAdderWillReadRelationship
                                    : _MulleObjectAdder));

   method->descriptor = *desc;  // why not
   method->value      = imp;

   register_getter_lookup( _mulle_objc_descriptor_get_methodid( desc),
                           property,
                           infra);
}


static void   _MulleObjectRemover( MulleDynamicObject *self,
                                         mulle_objc_methodid_t _cmd,
                                         void *_param)
{
   id <MulleObjCContainerProperty>  container;
   void                             *key;
   id                               value;

   key       = MulleObjectGetKeyForSelector( self, _cmd);
   container = _mulle__pointermap_get( &self->__ivars, key);
   value     = (id) _param;
   [container removeObject:(id) value];
}


static void   _MulleObjectRemoverWillChange( MulleDynamicObject *self,
                                           mulle_objc_methodid_t _cmd,
                                           void *_param)
{
   mulle_objc_object_call_inline_partial( self, MULLE_OBJC_WILLCHANGE_METHODID, self);
   _MulleObjectRemover( self, _cmd, _param);
}


static void   _MulleObjectRemoverWillReadRelationship( MulleDynamicObject *self,
                                                       mulle_objc_methodid_t _cmd,
                                                       void *_param)
{
   id <MulleObjCContainerProperty>  container;
   id                               value;
   void                             *key;

   key       = MulleObjectGetKeyForSelector( self, _cmd);
   value     = (id) _param;
   container = _MulleObjectRetainGetterWillReadRelationship( self, (mulle_objc_methodid_t) (uintptr_t) key, _param);
   [container removeObject:(id) value];

}


static void   _MulleObjectRemoverWillChangeAndReadRelationship( MulleDynamicObject *self,
                                                                mulle_objc_methodid_t _cmd,
                                                                void *_param)
{
   mulle_objc_object_call_inline_partial( self, MULLE_OBJC_WILLCHANGE_METHODID, self);
   _MulleObjectRemoverWillReadRelationship( self, _cmd, _param);
}



static void
   _mulle_objc_method_init_remover( struct _mulle_objc_method *method,
                                    struct _mulle_objc_property *property,
                                    struct _mulle_objc_descriptor *desc,
                                    struct _mulle_objc_infraclass *infra)
{
   enum generic_type             ivarType;
   mulle_objc_implementation_t   imp;
   int                           isObservable;
   int                           isRelationship;


   assert( _mulle_objc_property_is_container( property));

   // lets allow copy, for some strange stuff i don't understand,
    // but its got to be an object
   ivarType = generic_type_for_property( property);
   if( ivarType != is_retain && ivarType != is_copy && ivarType != is_assign)
      retain_complain( property, desc, infra);

   isObservable   = _mulle_objc_property_is_observable( property);
   isRelationship = _mulle_objc_property_is_relationship( property);
   imp            = (mulle_objc_implementation_t)
                    (isObservable
                    ? (isRelationship ? _MulleObjectRemoverWillChangeAndReadRelationship
                                      : _MulleObjectRemoverWillChange)
                    : (isRelationship ? _MulleObjectRemoverWillReadRelationship
                                      : _MulleObjectRemover));


   method->descriptor = *desc;  // why not
   method->value      = imp;

   register_getter_lookup( _mulle_objc_descriptor_get_methodid( desc),
                           property,
                           infra);
}



MULLE_C_NONNULL_RETURN
static struct _mulle_objc_method *
  __mulle_objc_infraclass_create_methods_for_property( struct _mulle_objc_infraclass *infra,
                                                       struct _mulle_objc_property *property,
                                                       mulle_objc_methodid_t neededSel)
{
   struct _mulle_objc_descriptor   *desc;
   struct _mulle_objc_descriptor   *accessors[ mulle_objc_property_accessor_remover + 1];
   struct _mulle_objc_methodlist   *list;
   struct _mulle_objc_universe     *universe;
   struct _mulle_objc_class        *cls;
   struct _mulle_objc_method       *method;
   unsigned int                    n;
   unsigned int                    i;
   int                             accessorType;
   mulle_objc_methodid_t           sel;
   size_t                          size;
   int                             error;

   memset( accessors, 0, sizeof( accessors));
   universe = _mulle_objc_infraclass_get_universe( infra);
   cls      = _mulle_objc_infraclass_as_class( infra);
   i        = 0;

   for( accessorType = mulle_objc_property_accessor_getter;
        accessorType <= mulle_objc_property_accessor_remover;
        accessorType++)
   {
      // MEMO: the property declaration should have already been filled with
      //       only those that we need. So if its not a container then
      //       adder/remover  ought to be (SEL) 0
      //
      switch( accessorType)
      {
      case mulle_objc_property_accessor_getter  : sel = _mulle_objc_property_get_getter( property); break;
      case mulle_objc_property_accessor_setter  : sel = _mulle_objc_property_get_setter( property); break;
      case mulle_objc_property_accessor_adder   : sel = _mulle_objc_property_get_adder( property); break;
      case mulle_objc_property_accessor_remover : sel = _mulle_objc_property_get_remover( property); break;
      }
      if( ! sel)
         continue;

      method = mulle_objc_class_search_non_inherited_method( cls, sel, &error);
      if( method)
      {
         assert( sel != neededSel); // why are we here then, if it exists
         continue;
      }

      desc = _mulle_objc_universe_lookup_descriptor( universe, sel);
      accessors[ accessorType] = desc;
      ++i;
   }

   n    = i;
   assert( n);  // why are we here then, if all exist ?

   i    = 0;
   size = mulle_objc_sizeof_methodlist( n);
   list = _mulle_objc_universe_calloc( universe, 1, size);
   list->n_methods = n;
   for( accessorType = mulle_objc_property_accessor_getter;
        accessorType <= mulle_objc_property_accessor_remover;
        accessorType++)
   {
      desc = accessors[ accessorType];
      if( ! desc)
         continue;

      switch( accessorType)
      {
      case mulle_objc_property_accessor_getter  :
         _mulle_objc_method_init_getter( &list->methods[ i], property, desc, infra);
         break;
      case mulle_objc_property_accessor_setter  :
         _mulle_objc_method_init_setter( &list->methods[ i], property, desc, infra);
         break;
      case mulle_objc_property_accessor_adder   :
         _mulle_objc_method_init_adder( &list->methods[ i], property, desc, infra);
         break;
      case mulle_objc_property_accessor_remover :
         _mulle_objc_method_init_remover( &list->methods[ i], property, desc, infra);
         break;
      }

      ++i;
   }

   mulle_objc_methodlist_sort( list);
   mulle_objc_class_add_methodlist_nofail( _mulle_objc_infraclass_as_class( infra), list);

   // find method in sorted method list
   for( i = 0; i < n; i++)
      if( neededSel == _mulle_objc_method_get_methodid( &list->methods[ i]))
         break;

   assert( i < n); // why are we here then, if we found nothing and created nothing
   return( &list->methods[ i]);
}


MULLE_C_NONNULL_RETURN
static struct _mulle_objc_method *
  _mulle_objc_infraclass_create_methods_for_property( struct _mulle_objc_infraclass *infra,
                                                      struct _mulle_objc_property *property,
                                                      mulle_objc_methodid_t neededSel)
{
   int                         protect_errno;
   struct _mulle_objc_method   *method;

   protect_errno = errno;
   method        = __mulle_objc_infraclass_create_methods_for_property( infra, property, neededSel);
   errno         = protect_errno;
   return( method);
}


//
// MEMO: A problem with this code is, that you still need descriptors for the
//       methods (except if you are fine with just objects as values). You
//       might as well just declare properties anyway, this could be good for
//       interpreters though.
//
#ifdef HAVE_FULLY_DYNAMIC_MULLE_DYNAMIC_OBJECT

// strings must be constant or already gifted
static struct _mulle_objc_descriptor  *
   _mulle_objc_universe_create_descriptor( struct _mulle_objc_universe *universe,
                                           char *name,
                                           mulle_objc_methodid_t methodid,
                                           char *signature,
                                           unsigned int bits)
{
   struct _mulle_objc_descriptor   *desc;

   desc             = _mulle_objc_universe_calloc( universe, 1, sizeof( struct _mulle_objc_descriptor));
   desc->name       = name;
   desc->methodid   = methodid == MULLE_OBJC_NO_METHODID
                        ? mulle_objc_methodid_from_string( name)
                        : methodid;
   desc->signature  = signature;
   desc->bits       = bits;

   return( desc);
}

static struct _mulle_objc_descriptor  *
   create_getter_from_setter( struct _mulle_objc_descriptor *setter,
                              struct _mulle_objc_universe *universe,
                              unsigned int bits)
{
   struct _mulle_objc_descriptor   *getter;
   struct mulle_objc_typeinfo      arg_info;
   size_t                          len;
   char                            *rval_s;
   char                            *self_s;
   char                            *cmd_s;
   char                            *arg_s;
   char                            *name;
   char                            *signature;
   size_t                          size;

   // remove set from setValue:, make Value -> value
   // or mulleSetValue: -> mulleValue

   len    = strlen( setter->name);
   // we cut off ':' so allocating len is correct
   name   = _mulle_objc_universe_calloc( universe, 1, len);

   // decide between mulleSet and set, nothing else is possible
   if( setter->name[ 0] == 's')
   {
      memcpy( name, &setter->name[ 3], len - 3 - 1);
      name[ 0] = name[ 0] - 'A' + 'a';  // UTF ?
   }
   else
   {
      memcpy( name, setter->name, 5);
      memcpy( &name[ 5], &setter->name[ 8], len - 8 - 1);
      name[ 8] = name[ 0] - 'A' + 'a';  // UTF ?
   }

   // signature of  int setter is : v20@0:8i16  (64 bit)
   // getter is i16@0:8
   //

   rval_s = setter->signature;
   self_s = mulle_objc_signature_supply_typeinfo( rval_s, NULL, NULL);
   cmd_s  = mulle_objc_signature_supply_typeinfo( self_s, NULL, NULL);
   arg_s  = mulle_objc_signature_supply_typeinfo( cmd_s, NULL, NULL);
   mulle_objc_signature_supply_typeinfo( arg_s, NULL, &arg_info);
   size   = (arg_info.pure_type_end - arg_s);

   bits  |= _mulle_objc_methodfamily_getter << _mulle_objc_methodfamily_shift;

   mulle_buffer_do( buf)
   {
      mulle_buffer_sprintf( buf, "%.*s%d@0:%d", (int) size,
                                 arg_s,
                                 (int) (sizeof( void *) + sizeof( void *)),
                                 (int) sizeof( void *));
      signature  = _mulle_objc_universe_strdup( universe, mulle_buffer_get_string( buf));
      getter     = _mulle_objc_universe_create_descriptor( universe,
                                                           name,
                                                           MULLE_OBJC_NO_METHODID,
                                                           signature,
                                                           bits);
   }
   return( getter);
}


static struct _mulle_objc_descriptor  *
   create_setter_from_getter( struct _mulle_objc_descriptor *getter,
                              struct _mulle_objc_universe *universe,
                              unsigned int bits)
{
   struct _mulle_objc_descriptor   *setter;
   struct mulle_objc_typeinfo      arg_info;
   size_t                          len;
   char                            *name;
   char                            *signature;
   size_t                          size;
   int                             is_mulle;

   // remove set from setValue:, make Value -> value
   // or mulleSetValue: -> mulleValue


   len      = strlen( getter->name);
   // we add  ':' and "set" and 0
   name     = _mulle_objc_universe_calloc( universe, 1, 3 + len + 1 + 1);

   is_mulle = ! strncmp( getter->name, "mulle", 5) && isupper( getter->name[ 5]);

   // decide between mulleSet and set, nothing else is possible
   name = strcpy( name, is_mulle ? "mulleSet" : "set");
   strcat( name, getter->name);
   strcat( name, ":");
   name[ is_mulle ? 8 : 3] = toupper( name[ is_mulle ? 8 : 3]);

   // signature of  int setter is : v20@0:8i16  (64 bit)
   // getter is i16@0:8
   //

   mulle_objc_signature_supply_typeinfo( getter->signature, NULL, &arg_info);
   size  = (arg_info.pure_type_end - getter->signature);
   bits |= _mulle_objc_methodfamily_setter << _mulle_objc_methodfamily_shift;

   mulle_buffer_do( buffer)
   {
      mulle_buffer_sprintf( buffer, "v%d@0:%d%s%.*s%d",
                                    (int) (arg_info.natural_size + sizeof( void *) + sizeof( void *)),
                                    (int) sizeof( void *),
                                    size,
                                    getter->signature,
                                    (int) (sizeof( void *) + sizeof( void *)));
      signature  = _mulle_objc_universe_strdup( universe, mulle_buffer_get_string( buffer));
      setter     = _mulle_objc_universe_create_descriptor( universe,
                                                           name,
                                                           MULLE_OBJC_NO_METHODID,
                                                           signature,
                                                           bits);
   }
   return( setter);
}


static enum mulle_objc_property_accessor_type   accessor_type_from_string( char *name)
{
   char                                    *s;
   char                                    *s_arg;
   char                                    *cmp;
   size_t                                  len;
   int                                     c;
   int                                     expect_uppercase;
   enum mulle_objc_property_accessor_type  accessorType;

   s_arg = strchr( name, ':');
   if( ! s_arg)
      return( mulle_objc_property_accessor_getter);

   // setter, adder, remover
   if( s_arg[ 1])  // must have \0 after ':'
      return( mulle_objc_property_accessor_invalid);

   s                = name;
   expect_uppercase = NO;
   if( ! strncmp( s, "mulle", 5))
   {
      expect_uppercase = YES;
      s += 5;
   }

   switch( *s++)
   {
   default  : return( mulle_objc_property_accessor_invalid);
   case 'S' : if( ! expect_uppercase)
                 return( mulle_objc_property_accessor_invalid);
              goto set;

   case 's' : if( expect_uppercase)
                 return( mulle_objc_property_accessor_invalid);
set:
              cmp          = "et";
              len          = 2;
              accessorType = mulle_objc_property_accessor_setter;
              break;

   case 'A' : if( ! expect_uppercase)
                 return( mulle_objc_property_accessor_invalid);
              goto addto;
   case 'a' : if( expect_uppercase)
                 return( mulle_objc_property_accessor_invalid);
addto:
              cmp          = "ddTo";
              len          = 4;
              accessorType = mulle_objc_property_accessor_adder;
              break;


   case 'R' : if( ! expect_uppercase)
                 return( mulle_objc_property_accessor_invalid);
              goto removefrom;
   case 'r' : if( expect_uppercase)
                 return( mulle_objc_property_accessor_invalid);
removefrom:
              cmp          = "emoveFrom";
              len          = 9;
              accessorType = mulle_objc_property_accessor_remover;
              break;
    }

   if( strncmp( s, cmp, len))  // accessor prefix ?
      return( mulle_objc_property_accessor_invalid);

   //
   // need uppercase after prefix .e.g settlementWithString: bad,
   //
   c  = s[ len];
   if( c < 'A' || c > 'Z')
      return( mulle_objc_property_accessor_invalid);

   return( accessorType);
}


static struct  _mulle_objc_descriptor  *
   create_fake_accessor( mulle_objc_methodid_t methodid,
                         char *name,
                         struct _mulle_objc_universe *universe,
                         unsigned int bits)
{
   struct  _mulle_objc_descriptor           *desc;
   char                                     *signature;
   enum mulle_objc_property_accessor_type   accessor_type;

   accessor_type = accessor_type_from_string( name);
   switch( accessor_type)
   {
    default :
      return( NULL);

    case mulle_objc_property_accessor_getter :
      if( sizeof( void *) == 8)
         signature = "@16@0:8";
      else
      {
         assert( sizeof( void *) == 4);
         signature ="@8:@0:4";
      }
      bits |= _mulle_objc_methodfamily_getter << _mulle_objc_methodfamily_shift;
      break;

   case mulle_objc_property_accessor_setter :
      if( sizeof( void *) == 8)
         signature = "v24@0:8@16";
      else
      {
         assert( sizeof( void *) == 4);
         signature ="v12@0:4@8";
      }
      bits |= _mulle_objc_methodfamily_setter << _mulle_objc_methodfamily_shift;
      break;
  }

   desc = _mulle_objc_universe_create_descriptor( universe,
                                                  name,
                                                  methodid,
                                                  signature,
                                                  bits);
   return( desc);
}


//
// this function is used in fully dynamic mode, it can produce storage for
// calls like -setFoo: without having a @property foo; If the descriptor
// is not known to the universe, it will create a fake one and assume the
// value is an object.
//
static struct _mulle_objc_method *
   __mulle_objc_infraclass_create_accessor_methods( struct _mulle_objc_infraclass *infra,
                                                    mulle_objc_methodid_t neededSel)
{
   struct _mulle_objc_descriptor        *desc;
   struct _mulle_objc_descriptor        *accessors[ mulle_objc_property_accessor_setter + 1];
   struct _mulle_objc_methodlist        *list;
   struct _mulle_objc_universe          *universe;
   struct _mulle_objc_class             *cls;
   struct _mulle_objc_method            *method;
   struct _mulle_objc_descriptor        fakeDesc;
   struct _mulle_objc_property          fakeProperty;
   int                                  accessorType;
   size_t                               size;
   char                                 *name;
//   char                                 *fakeName;
//   char                                 *fakeSignature;
   struct _mulle_objc_searcharguments   search;
   struct _mulle_objc_searchresult      result;
//   unsigned int                         offset;
   unsigned int                         i;

   assert( neededSel);

   universe = _mulle_objc_infraclass_get_universe( infra);
   cls      = _mulle_objc_infraclass_as_class( infra);

   desc = _mulle_objc_universe_lookup_descriptor( universe, neededSel);
   if( ! desc)
   {

      // here we are extremely valiant and try to produce a fake descriptor
      // if we can get the name, we can figure out the number of arguments
      // and the prefix and go on from there (everything typed as id)
      //
      name = _mulle_objc_universe_search_hashstring( universe, neededSel);
      if( ! name)
         return( NULL);

      desc = create_fake_accessor( neededSel, name, universe, 0);
      if( ! desc)
         return( NULL);

      desc = _mulle_objc_universe_register_descriptor_nofail( universe, desc, cls, NULL);
   }

#if 0
   fakeName      = NULL;
   fakeSignature = NULL;
#endif
   memset( accessors, 0, sizeof( accessors));
   memset( &fakeDesc, 0, sizeof( fakeDesc));

   if( _mulle_objc_descriptor_is_setter_method( desc))
   {
      accessors[ mulle_objc_property_accessor_setter] = desc;
      accessors[ mulle_objc_property_accessor_getter] = create_getter_from_setter( desc, universe, 0);
#if 0
      accessors[ mulle_objc_property_accessor_getter] = desc;
      // need to look for setter
      fakeName          = mulle_malloc( strlen( desc->name) + 8 + 1);
      fakeDesc.name     = fakeName;
      strcpy( fakeDesc.name, "mulleSet");
      strcat( fakeDesc.name, desc->name);
      fakeDesc.name[ 8] = toupper( fakeDesc.name[ 8]);
      fakeDesc.methodid = mulle_objc_uniqueid_from_string( fakeDesc.name);
      desc              = _mulle_objc_universe_lookup_descriptor( universe, fakeDesc.methodid);
      if( ! desc)
      {
         strcpy( fakeDesc.name, "set");
         strcat( fakeDesc.name, desc->name);
         fakeDesc.name[ 3] = toupper( fakeDesc.name[3]);
         fakeDesc.methodid = mulle_objc_uniqueid_from_string( fakeDesc.name);
         desc              = _mulle_objc_universe_lookup_descriptor( universe, fakeDesc.methodid);
      }

      if( ! desc)
      {
         fakeSignature = mulle_malloc( strlen( accessors[ mulle_objc_property_accessor_getter]->signature) + 8);
         fakeDesc.signature = fakeSignature;
         strcpy( fakeDesc.signature, "v@:");
         strcat( fakeDesc.signature, accessors[ mulle_objc_property_accessor_getter]->signature);

         desc = &fakeDesc;
      }
#endif
   }
   else
      if( _mulle_objc_descriptor_is_getter_method( desc))
      {
         accessors[ mulle_objc_property_accessor_getter] = desc;
         accessors[ mulle_objc_property_accessor_setter] = create_setter_from_getter( desc, universe, _mulle_objc_property_observable);
#if 0
         if( ! strncmp( desc->name, "set", 3))
            offset = 3;
         else
            if( ! strncmp( desc->name, "mulleSet", 8))
               offset = 8;
            else
               return( NULL);

         fakeName           = mulle_strdup( desc->name);
         fakeDesc.name      = &fakeName[ offset];
         fakeDesc.name[ 0]  = tolower( fakeDesc.name[ 0]);
         fakeDesc.name[ strlen( fakeDesc.name) - 1] = 0;
         fakeDesc.methodid  = mulle_objc_uniqueid_from_string( fakeDesc.name);

         // see if it exists
         desc = _mulle_objc_universe_lookup_descriptor( universe, fakeDesc.methodid);
         if( ! desc)
         {
            fakeDesc.signature = accessors[ mulle_objc_property_accessor_setter]->signature;
            fakeDesc.signature = mulle_objc_signature_next_type( fakeDesc.signature);
            fakeDesc.signature = mulle_objc_signature_next_type( fakeDesc.signature);
            fakeDesc.signature = mulle_objc_signature_next_type( fakeDesc.signature);

            desc               = &fakeDesc;
         }
         accessors[ mulle_objc_property_accessor_getter] = desc;
#endif
      }
      else
         return( NULL);

   // looks more like a bug, if we have any one already defined, so dont obscure it
   for( accessorType = mulle_objc_property_accessor_getter;
        accessorType <= mulle_objc_property_accessor_setter;
        accessorType++)
   {
      search = mulle_objc_searcharguments_make_default( accessors[ accessorType]->methodid);
      method = mulle_objc_class_search_method( cls,
                                               &search,
                                               _mulle_objc_class_get_inheritance( cls),
                                               &result);
      if( method)
      {
#if 0
         mulle_free( fakeSignature);
         mulle_free( fakeName);
#endif
         return( NULL);
      }
   }

#if 0
   // ok now we need to make strings in fakeDesc permanent if they are put to use
   // fakeProperty is ephemeral and will vanish once we are thru
   if( accessors[ mulle_objc_property_accessor_getter] == &fakeDesc ||
       accessors[ mulle_objc_property_accessor_setter] == &fakeDesc)
   {
      fakeDesc.name      = _mulle_objc_universe_strdup( universe, fakeDesc.name);
      fakeDesc.signature = _mulle_objc_universe_strdup( universe, fakeDesc.signature);
   }
#endif
   memset( &fakeProperty, 0, sizeof( fakeProperty));

   // make them observable by default
   fakeProperty.bits      = _mulle_objc_property_fake | _mulle_objc_property_observable;
   fakeProperty.name      = accessors[ mulle_objc_property_accessor_getter]->name;
   fakeProperty.signature = accessors[ mulle_objc_property_accessor_getter]->signature;
   fakeProperty.getter    = accessors[ mulle_objc_property_accessor_getter]->methodid;
   fakeProperty.setter    = accessors[ mulle_objc_property_accessor_setter]->methodid;

   size            = mulle_objc_sizeof_methodlist( 2);
   list            = _mulle_objc_universe_calloc( universe, 1, size);
   list->n_methods = 2;

   _mulle_objc_method_init_getter( &list->methods[ 0], &fakeProperty, accessors[ mulle_objc_property_accessor_getter], infra);
   _mulle_objc_method_init_setter( &list->methods[ 1], &fakeProperty, accessors[ mulle_objc_property_accessor_setter], infra);

   mulle_objc_methodlist_sort( list);
   mulle_objc_class_add_methodlist_nofail( _mulle_objc_infraclass_as_class( infra), list);

   // find method in sorted method list
   for( i = 0; i < 2; i++)
      if( neededSel == _mulle_objc_method_get_methodid( &list->methods[ i]))
         break;

   assert( i < 2); // why are we here then, if we found nothing and created nothing

#if 0
   mulle_free( fakeSignature);
   mulle_free( fakeName);
#endif
   return( &list->methods[ i]);
}


static struct _mulle_objc_method *
   _mulle_objc_infraclass_create_accessor_methods( struct _mulle_objc_infraclass *infra,
                                                    mulle_objc_methodid_t neededSel)
{
   int                         protect_errno;
   struct _mulle_objc_method   *method;

   protect_errno = errno;
   method        = __mulle_objc_infraclass_create_accessor_methods( infra, neededSel);
   errno         = protect_errno;
   return( method);
}
#endif

//
// So we get hit with an unknown method. If it's a dynamic property method,
// then we have a matching property declaration for it already. Just not
// a defined method. So search this property. If we find it, generate a
// method for it, add it to the runtime and then execute it.
//
// Adding a method list will invalidate the whole cache. The second level
// cache of MulleObject should not yet be involved (IMO), but maybe so ?
//
- (void *) forward:(void *) args
{
   struct _mulle_objc_property     *property;
   mulle_objc_implementation_t     imp;
   struct _mulle_objc_infraclass   *infra;
   struct _mulle_objc_class        *cls;
   struct _mulle_objc_method       *method;
   mulle_objc_methodid_t           sel;

   cls      = _mulle_objc_object_get_non_tps_isa( self);
   infra    = _mulle_objc_class_as_infraclass( cls);
   sel      = (mulle_objc_methodid_t) _cmd;

   // if property was found, infra is changed to the infra class where we found the
   // property, thats where we need to place the methodlist, if property is NULL
   // infra is unchanged
   property = search_dynamic_property( &infra, sel);
   if( ! property)
   {
#ifdef HAVE_FULLY_DYNAMIC_MULLE_DYNAMIC_OBJECT
      if( [(Class) infra isFullyDynamic])
      {
         // we can not create a property dynamically though, because it's not clear where
         // to place it (directly on MulleDynamicObject ?)
         method = _mulle_objc_infraclass_create_accessor_methods( infra, sel);
         if( method)
         {
            imp = _mulle_objc_method_get_implementation( method);
            return( mulle_objc_implementation_invoke( imp, self, sel, args));
         }
      }
#endif
      // call superclass forward: and fail there, unless that does some smart stuff
      imp = _mulle_objc_object_lookup_superimplementation_inline_nofail( self, MULLE_DYNAMIC_OBJECT_FORWARD_SUPERID);
      return( mulle_objc_implementation_invoke( imp, self, sel, args));
   }

   method   = _mulle_objc_infraclass_create_methods_for_property( infra, property, sel);
   imp      = _mulle_objc_method_get_implementation( method);
   return( mulle_objc_implementation_invoke( imp, self, sel, args));
}


//
// The dynamic methods may not exist yet in the runtime, so we check our
// dynamic properties if they define this selector. For fully dynamic, we
// do more. (Once the methods are in the cache, this will be skipped)
//
static BOOL   MulleObjectRespondsToSelector( Class self, SEL sel)
{
   struct _mulle_objc_universe              *universe;
   struct _mulle_objc_descriptor            *desc;
   struct _mulle_objc_property              *property;
   struct _mulle_objc_infraclass            *infra;
   char                                     *name;
   enum mulle_objc_property_accessor_type   accessorType;

   infra    = (struct _mulle_objc_infraclass *) self;
   property = search_dynamic_property( &infra, sel);
   if( property)
      return( YES);

   if( ! [self isFullyDynamic])
      return( NO);

   universe = _mulle_objc_infraclass_get_universe( infra);
   desc     = _mulle_objc_universe_lookup_descriptor( universe, sel);
   if( desc)
      return( _mulle_objc_descriptor_is_getter_method( desc) ||
              _mulle_objc_descriptor_is_setter_method( desc));

   name         = _mulle_objc_universe_search_hashstring( universe, sel);
   accessorType = accessor_type_from_string( name);
   return( accessorType == mulle_objc_property_accessor_getter ||
           accessorType == mulle_objc_property_accessor_setter);
}


- (BOOL) respondsToSelector:(SEL) sel
{
   struct _mulle_objc_class        *cls;
   struct _mulle_objc_infraclass   *infra;

   if( [super respondsToSelector:sel])
      return( YES);

   cls   = _mulle_objc_object_get_non_tps_isa( self);
   infra = _mulle_objc_class_as_infraclass( cls);
   return( MulleObjectRespondsToSelector( infra, sel));
}


+ (BOOL) instancesRespondToSelector:(SEL) sel
{
   struct _mulle_objc_infraclass   *infra;

   if( [super instancesRespondToSelector:sel])
      return( YES);

   infra = (struct _mulle_objc_infraclass *) self;
   return( MulleObjectRespondsToSelector( infra, sel));
}

@end


@implementation MulleDynamicObject( NSMutableCopying)

static inline void  copy_generic_value( struct mulle__pointermap *map,
                                        struct mulle_pointerpair *pair,
                                        struct _mulle_objc_infraclass *infra,
                                        struct mulle_allocator *allocator)
{
   char                            *signature;
   enum generic_type               type;
   mulle_objc_methodid_t           methodid;
   struct _mulle_objc_descriptor   *desc;
   struct _mulle_objc_property     *property;
   struct _mulle_objc_universe     *universe;

   methodid = (mulle_objc_methodid_t) (uintptr_t) pair->key;
   property = search_dynamic_property( &infra, methodid);
   if( property)
   {
      type      = generic_type_for_property( property);
   }
   else
   {
      universe  = _mulle_objc_infraclass_get_universe( infra);
      desc      = mulle_objc_universe_lookup_descriptor_nofail( universe, methodid);
      signature = _mulle_objc_descriptor_get_signature( desc);
      type      = generic_type_for_signature( signature);
   }

   //
   // descriptor is always the "value" getter
   // key is the value selector
   //
   switch( type)
   {
   case is_strdup : pair->value = mulle_allocator_strdup( allocator, pair->value);
                    break;
   case is_value  :
   case is_number :
   case is_retain : pair->value = [(id) pair->value retain];
                    break;
   case is_copy   : pair->value = [(id) pair->value copy];
   default        : break;
   }

   _mulle__pointermap_insert_pair( map, pair, allocator);
}


- (id) mutableCopy
{
   struct mulle_allocator               *allocator;
   struct mulle__pointermapenumerator   rover;
   struct mulle_pointerpair             pair;
   struct _mulle_objc_infraclass        *infra;
   struct _mulle_objc_class             *cls;
   MulleDynamicObject                          *copy;
   unsigned int                         n;

   copy      = [MulleObjCObjectGetClass( self) new];

   // wipe possibly copied ivars
   n         = mulle__pointermap_get_count( &self->__ivars);
   allocator = MulleObjCInstanceGetAllocator( copy);
   _mulle__pointermap_init( &copy->__ivars, n, allocator);

   //
   // copy values
   //
   cls       = _mulle_objc_object_get_non_tps_isa( self);
   infra     = _mulle_objc_class_as_infraclass( cls);
   rover     = mulle__pointermap_enumerate( &self->__ivars);
   while( _mulle__pointermapenumerator_next_pair( &rover, &pair))
   {
      // this is a "choke" point: best solution would be to have a
      // per infraclass property cache to speed this up
      copy_generic_value( &copy->__ivars, &pair, infra, allocator);
   }
   mulle__pointermapenumerator_done( &rover);

   return( copy);
}

@end

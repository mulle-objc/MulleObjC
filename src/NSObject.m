//
//  NSObject.m
//  MulleObjC
//
//  Copyright (c) 2011 Nat! - Mulle kybernetiK.
//  Copyright (c) 2011 Codeon GmbH.
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

// other files in this library
#import "ns_objc_type.h"
#import "ns_int_type.h"
#import "ns_debug.h"
#import "MulleObjCAllocation.h"
#import "MulleObjCSingleton.h"
#import "NSCopying.h"
#import "NSAutoreleasePool.h"
#import "NSMethodSignature.h"
#import "NSInvocation.h"

// std-c and dependencies
#import <mulle_concurrent/mulle_concurrent.h>


#pragma clang diagnostic ignored "-Wobjc-root-class"


@interface NSObject ( NSCopying)

- (instancetype) copy;

@end


@interface NSObject ( NSMutableCopying)

- (instancetype) mutableCopy;

@end

// desperately need @classid( ) compiler support in clang

#define _MulleObjCInstantiatePlaceholderHash  0x56154b76  // _MulleObjCInstantiatePlaceholder


// intentonally a root object (!)
@interface _MulleObjCInstantiatePlaceholder
{
@public
   Class   _cls;
}
@end

#pragma mark -
#pragma mark ### _MulleObjCInstantiatePlaceholder ###
#pragma mark -

@implementation _MulleObjCInstantiatePlaceholder

- (void *) forward:(void *) _param
{
   id  obj;

   assert( _cls);

   // assert that we are calling an init method
#ifndef NDEBUG
   {
      struct _mulle_objc_method             *method;
      struct _mulle_objc_methoddescriptor   *desc;
      struct _mulle_objc_class              *cls;

      cls = _mulle_objc_infraclass_as_class( _cls);
      method = _mulle_objc_class_search_method( cls,
                                               (mulle_objc_methodid_t) _cmd,
                                               NULL,
                                               MULLE_OBJC_ANY_OWNER,
                                               _mulle_objc_class_get_inheritance( cls),
                                               NULL);
      if( method)
      {
         desc = _mulle_objc_method_get_methoddescriptor( method);
         assert( _mulle_objc_methoddescriptor_is_init_method( desc));
      }
   }
#endif

   obj = [_cls alloc];
   obj = mulle_objc_object_inline_variable_methodid_call( obj, (mulle_objc_methodid_t) _cmd, _param);
   [obj autorelease];
   return( obj);
}

- (void) dealloc
{
   _MulleObjCObjectFree( self);
}


// finalize exists, but it is not adverised
- (void) finalize
{
}


- (void) release
{
   _mulle_objc_object_release( self);
}

@end


#pragma mark -
#pragma mark ### NSObject ###
#pragma mark -

@implementation NSObject

+ (instancetype) alloc
{
   return( NSAllocateObject( self, 0, NULL));
}


+ (instancetype) allocWithZone:(NSZone *) zone
{
   return( NSAllocateObject( self, 0, NULL));
}


+ (instancetype) new
{
   id   p;

   p = [NSAllocateObject( self, 0, NULL) init];
   return( p);
}


- (NSZone *) zone;  // always NULL
{
   return( (NSZone *) 0);
}


- (void) _performFinalize
{
   _mulle_objc_object_perform_finalize( self);
}


// not advertise to the outside world
- (void) finalize
{
}


#if DEBUG
static BOOL   MulleObjCSingleThreadedCheckReleaseAndAutorelease = YES;
#endif


- (void) dealloc
{
   _MulleObjCObjectReleaseProperties( self);

#if DEBUG
   if( MulleObjCSingleThreadedCheckReleaseAndAutorelease)
      if( [NSAutoreleasePool _countObject:self] )
         mulle_objc_throw_internal_inconsistency_exception( "deallocing object %p still in autoreleasepool", self);
#endif
   _MulleObjCObjectFree( self);
}


#pragma mark -
#pragma mark lifetime management

- (instancetype) retain
{
   return( (id) mulle_objc_object_retain( (struct _mulle_objc_object *) self));
}


//
// this "facility" catches release/autorelease mistakes, but only for
// single threaded programs. For multithreaded one would need to suspend all
// other threads and inspect their autorelease pools as well
//
#if DEBUG
static void   checkAutoreleaseRelease( NSObject *self)
{
   if( MulleObjCSingleThreadedCheckReleaseAndAutorelease)
   {
      NSUInteger   autoreleaseCount;
      NSUInteger   retainCount;

      autoreleaseCount = [NSAutoreleasePool _countObject:self];
      retainCount      = [self retainCount];
      if(  autoreleaseCount >= retainCount)
         mulle_objc_throw_internal_inconsistency_exception( "object %p would be autoreleased to often", self);
   }
}
#else
static inline void   checkAutoreleaseRelease( NSObject *self)
{
}
#endif


- (void) release
{
   checkAutoreleaseRelease( self);

   _mulle_objc_object_release( self);
}


- (instancetype) autorelease
{
   checkAutoreleaseRelease( self);

   _MulleObjCAutoreleaseObject( self);
   return( self);
}


- (NSUInteger) retainCount
{
   return( (NSUInteger) _mulle_objc_object_get_retaincount( self));
}


- (instancetype) self
{
   return( self);
}


#pragma mark -
#pragma mark aam support

//
// infraClass is the placeholder class, of which we create an instance
// the infraClass with classid is placed into the placeholder
//
static struct _mulle_objc_object   *_MulleObjCClassNewInstantiatePlaceholder( Class infraCls,
                                                                              mulle_objc_classid_t classid)
{
   struct _mulle_objc_runtime          *runtime;
   struct _mulle_objc_infraclass       *placeholderInfracls;
   struct _mulle_objc_class            *pcls;
   _MulleObjCInstantiatePlaceholder    *placeholder;
   SEL                                 initSel;
   mulle_objc_methodimplementation_t   imp;

   assert( classid);

   runtime             = _mulle_objc_infraclass_get_runtime( infraCls);
   placeholderInfracls = _mulle_objc_runtime_unfailing_get_or_lookup_infraclass( runtime, classid);

   placeholder       = _MulleObjCClassAllocateObject( placeholderInfracls, 0);
   placeholder->_cls = infraCls;

   initSel = @selector( __initPlaceholder);
   pcls    = _mulle_objc_infraclass_as_class( placeholderInfracls);
   imp     = _mulle_objc_class_lookup_methodimplementation_no_forward( pcls, (mulle_objc_methodid_t) initSel);
   if( imp)
      (*imp)( placeholder, (mulle_objc_methodid_t) initSel, NULL);

   return( (struct _mulle_objc_object *) placeholder);
}


+ (mulle_objc_classid_t) __instantiatePlaceholderClassid
{
   return( MULLE_OBJC_CLASSID( _MulleObjCInstantiatePlaceholderHash));
}


+ (instancetype) instantiate
{
   struct _mulle_objc_object   *placeholder;

retry:
   placeholder = _mulle_objc_infraclass_get_placeholder( self);
   if( ! placeholder)
   {
      placeholder = _MulleObjCClassNewInstantiatePlaceholder( self, [self __instantiatePlaceholderClassid]);
      _ns_add_placeholder( placeholder);

      if( ! _mulle_objc_infraclass_set_placeholder( self, placeholder))
      {
         _MulleObjCObjectFree( (id) placeholder);
         goto retry;
      }
   }
   return( (id) placeholder);
}


+ (instancetype) instantiatedObject // alloc + autorelease + init
{
   return( [[self instantiate] init]);
}


- (instancetype) immutableInstance
{
   return( [[self copy] autorelease]);
}


- (instancetype) mutableInstance
{
   return( [[self mutableCopy] autorelease]);
}


+ (NSUInteger) _getRootObjects:(id *) buf
                        length:(NSUInteger) length
{
   struct _ns_rootconfiguration   *config;
   struct _mulle_objc_runtime     *runtime;
   NSUInteger                     count;
   struct mulle_setenumerator     rover;
   id                             obj;
   id                             *sentinel;

   runtime = _mulle_objc_infraclass_get_runtime( self);

   _mulle_objc_runtime_lock( runtime);
   {
      _mulle_objc_runtime_get_foundationspace( runtime, (void **) &config, NULL);

      count    = mulle_set_get_count( config->object.roots);
      sentinel = &buf[ count < length ? count : length];

      rover = mulle_set_enumerate( config->object.roots);
      while( buf < sentinel)
      {
         obj = mulle_setenumerator_next( &rover);
         assert( obj);
         *buf++ = obj;
      }
      mulle_setenumerator_done( &rover);
   }
   _mulle_objc_runtime_unlock( runtime);

   return( count);
}


- (BOOL) _isRootObject
{
   struct _ns_rootconfiguration   *config;
   struct _mulle_objc_runtime     *runtime;
   struct mulle_setenumerator     rover;
   id                             obj;

   runtime = _mulle_objc_object_get_runtime( self);
   obj     = nil;

   _mulle_objc_runtime_lock( runtime);
   {
      _mulle_objc_runtime_get_foundationspace( runtime, (void **) &config, NULL);

      rover = mulle_set_enumerate( config->object.roots);
      while( obj = mulle_setenumerator_next( &rover))
      {
         if( obj == self)
            break;
      }
      mulle_setenumerator_done( &rover);
   }
   _mulle_objc_runtime_unlock( runtime);

   return( obj ? YES : NO);
}


- (void) _becomeRootObject
{
   assert( ! [self _isRootObject]);

   [self retain];
   _ns_add_root( self);
}


- (void) _resignAsRootObject
{
   _ns_remove_root( self);
   [self autorelease];
}


- (void) _pushToParentAutoreleasePool
{
   NSAutoreleasePool   *pool;

   pool = [NSAutoreleasePool _parentAutoreleasePool];
   if( pool)
   {
      [self retain];
      [pool addObject:self];
      return;
   }

   [self _becomeRootObject];
}


# pragma mark -
# pragma mark class "variable" support

#ifdef NDEBUG

# define assert_key( key)

#else
static void   assert_key( id key)
{
   struct _mulle_objc_class   *cls;

   assert( cls = _mulle_objc_object_get_isa( key));
   assert( ! strcmp( "NSConstantString", _mulle_objc_class_get_name( cls)) ||
           ! strstr( "TaggedPointer", _mulle_objc_class_get_name( cls)));
}
#endif


/* every value becomes a "root". It is an error to set a "root" object
   as a value. The classvalues are all taken down when the runtime
   collapses. (way before classes are deallocated !)
 */

+ (void) removeClassValueForKey:(id) key
{
   id      old;
   int     rval;

   assert_key( key);

   while( old = _mulle_objc_infraclass_get_cvar( self, key))
   {
      switch( (rval = _mulle_objc_infraclass_remove_cvar( self, key, old)))
      {
         case 0 :
            if( ! _mulle_objc_object_is_constant( old) && ! MulleObjCIsSingletonInstance( old))
               [old _resignAsRootObject];
         case ENOENT :
            return;

         default :
            errno = rval;
            mulle_objc_throw_errno_exception( "failed to remove key");
      }
   }
   return;
}


+ (BOOL) insertClassValue:(id) value
                   forKey:(id) key
{
   int      rval;

   assert( value);
   assert_key( key);

   switch( (rval = _mulle_objc_infraclass_set_cvar( self, key, value)))
   {
   case 0 :
      if( ! _mulle_objc_object_is_constant( value) && ! MulleObjCIsSingletonInstance( value))
         [value _becomeRootObject];
      return( YES);

   case EEXIST :
      return( NO);

   default :
      errno = rval;
      mulle_objc_throw_errno_exception( "failed to insert key");
   }
}


+ (void) setClassValue:(id) value
                forKey:(id) key
{
   if( ! value)
   {
      [self removeClassValueForKey:key];
      return;
   }

   while( ! [self insertClassValue:value
                            forKey:key])
   {
      [self removeClassValueForKey:key];
   }
}


+ (id) classValueForKey:(id) key
{
   assert_key( key);

   return( _mulle_objc_infraclass_get_cvar( self, key));
}



# pragma mark -
# pragma mark regular methods

- (instancetype) init
{
   return( self);
}


- (BOOL) isEqual:(id) other
{
   return( self == other);
}


//
// stipulation is, that small instance size is:
//    uintptr_t for retainCount
//    isa for objc
// + 2 ivars -> 16 bytes (32 bit) or
//  32 bytes (64 bit)
//
static inline int   shift_factor( void)
{
   return( sizeof( uintptr_t) == 4 ? 4 : 5);
}


static inline int   max_factor( void)
{
   return( sizeof( uintptr_t) * 8);
}


// compiler should optimize this to
// a single inlined rotation instruction since this
// can be all computed at compile time
//
static inline uintptr_t   rotate_uintptr( uintptr_t x)
{

   return( (x >> shift_factor()) | (x << (max_factor() - shift_factor())));
}


- (NSUInteger) hash
{
   return( (NSUInteger) rotate_uintptr( (uintptr_t) self));
}


#pragma mark -
#pragma mark object introspection

- (BOOL) isProxy
{
   return( NO);
}


#pragma mark -
#pragma mark class introspection

- (Class) superclass
{
   return( _mulle_objc_infraclass_get_superclass( _mulle_objc_object_get_infraclass( self)));
}


//
// +class loops around to - class
//
- (Class) class
{
   Class  cls;

   cls = _mulle_objc_object_get_infraclass( self);
   return( cls);
}


+ (Class) class
{
   Class  cls;

   cls = _mulle_objc_object_get_infraclass( self);
   return( cls);
}


+ (BOOL)  isSubclassOfClass:(Class) otherClass
{
   Class   cls;

   cls = self;
   do
   {
      if( cls == otherClass)
         return( YES);
   }
   while( cls = _mulle_objc_infraclass_get_superclass( cls));
   return( NO);
}


- (BOOL) isKindOfClass:(Class) otherClass
{
   struct _mulle_objc_class   *cls;

   cls = _mulle_objc_object_get_isa( self);
   do
   {
      if( cls == _mulle_objc_infraclass_as_class( otherClass))
         return( YES);
   }
   while( cls = _mulle_objc_class_get_superclass( cls));
   return( NO);
}


- (BOOL) isMemberOfClass:(Class) otherClass
{
   return( _mulle_objc_object_get_isa( self) == _mulle_objc_infraclass_as_class( otherClass));
}


#pragma mark -
#pragma mark protocol introspection

- (BOOL) conformsToProtocol:(PROTOCOL) protocol
{
   struct _mulle_objc_class       *cls;
   struct _mulle_objc_classpair   *pair;

   cls  = _mulle_objc_object_get_isa( self);
   pair = _mulle_objc_class_get_classpair( cls);
   return( (BOOL) _mulle_objc_classpair_conformsto_protocolid( pair,
                                                             (mulle_objc_protocolid_t) protocol));
}


#pragma mark -
#pragma mark method introspection

- (id) performSelector:(SEL) sel
{
   return( mulle_objc_object_inline_variable_methodid_call( self, (mulle_objc_methodid_t) sel, (void *) 0));
}


- (id) performSelector:(SEL) sel
            withObject:(id) obj
{
   return( mulle_objc_object_inline_variable_methodid_call( self, (mulle_objc_methodid_t) sel, (void *) obj));
}


/* this is pretty much the worst case for the META-ABI,
   since we need to extract sel from _param and have to alloca and reshuffle
   everything
 */
- (id) performSelector:(SEL) sel
            withObject:(id) obj1
            withObject:(id) obj2
{
   mulle_objc_metaabi_param_block( struct
                                   {
                                      id   obj1;
                                      id   obj2;
                                   },
                                   id)   param;

   param.p.obj1 = obj1;
   param.p.obj2 = obj2;

   return( mulle_objc_object_inline_variable_methodid_call( self, (mulle_objc_methodid_t) sel, &param));
}


- (BOOL) respondsToSelector:(SEL) sel
{
   struct _mulle_objc_class   *cls;
   IMP                        imp;

   cls = _mulle_objc_object_get_isa( self);
   imp = (IMP) _mulle_objc_class_lookup_or_search_methodimplementation_no_forward( cls, (mulle_objc_methodid_t) sel);
   return( imp ? YES : NO);
}


- (IMP) methodForSelector:(SEL) sel
{
   return( (IMP) _mulle_objc_object_lookup_or_search_methodimplementation( (void *) self, (mulle_objc_methodid_t) sel));
}


+ (BOOL) instancesRespondToSelector:(SEL) sel
{
   struct _mulle_objc_class   *cls;
   IMP                        imp;

   cls = _mulle_objc_infraclass_as_class( self);
   imp = (IMP) _mulle_objc_class_lookup_or_search_methodimplementation_no_forward( cls, (mulle_objc_methodid_t) sel);
   return( imp ? YES : NO);
}


+ (IMP) instanceMethodForSelector:(SEL) sel
{
   struct _mulle_objc_class   *cls;

   cls = _mulle_objc_infraclass_as_class( self);
   return( (IMP) _mulle_objc_class_lookup_or_search_methodimplementation( cls, (mulle_objc_methodid_t) sel));
}


#pragma mark -
#pragma mark walk object graph support

struct collect_info
{
   id            self;
   NSUInteger    n;
   id            *objects;
   id            *sentinel;
};


static int   collect( struct _mulle_objc_ivar *ivar,
                      struct _mulle_objc_class *cls,
                      struct collect_info *info)
{
   char  *signature;

   signature = _mulle_objc_ivar_get_signature( ivar);
   switch( *signature)
   {
   case _C_RETAIN_ID :
   case _C_COPY_ID   :
      if( info->objects < info->sentinel)
      {
         *info->objects = _mulle_objc_object_get_pointervalue_for_ivar( info->self, ivar);
         if( *info->objects)
            info->objects++;
      }
      ++info->n;
   }
   return( 0);
}


- (NSUInteger) _getOwnedObjects:(id *) objects
                         length:(NSUInteger) length
{
   struct _mulle_objc_class   *cls;
   struct collect_info        info;

   assert( (! objects && ! length) || objects);

   info.self     = self;
   info.n        = 0;
   info.objects  = objects;
   info.sentinel = &objects[ length];

   cls = _mulle_objc_object_get_isa( self);
   if( _mulle_objc_class_is_metaclass( cls))
   {
      // could actually put class vars in maybe ?
      return( 0);
   }
   _mulle_objc_infraclass_walk_ivars( _mulle_objc_class_as_infraclass( cls),
                                      _mulle_objc_class_get_inheritance( cls),
                                      (int (*)()) collect,
                                       &info);
   return( info.n);
}


#pragma mark -
#pragma mark forwarding

- (id) forwardingTargetForSelector:(SEL) sel
{
   return( nil);
}


- (void) doesNotForwardVariadicSelector:(SEL) sel
{
   mulle_objc_throw_internal_inconsistency_exception( "variadic methods can not be forwarded using invocations");
}


- (void) doesNotRecognizeSelector:(SEL) sel
{
   struct _mulle_objc_class   *cls;

   cls = _mulle_objc_object_get_isa( self);
   _mulle_objc_class_raise_method_not_found_exception( cls, (mulle_objc_methodid_t) sel);
}


- (NSMethodSignature *) methodSignatureForSelector:(SEL) sel
{
   struct _mulle_objc_class    *cls;
   struct _mulle_objc_method   *method;

   cls    = _mulle_objc_object_get_isa( self);
   method = _mulle_objc_class_search_method( cls,
                                             (mulle_objc_methodid_t) sel,
                                             NULL,
                                             MULLE_OBJC_ANY_OWNER,
                                             _mulle_objc_class_get_inheritance( cls),
                                             NULL);
   if( ! method)
      return( nil);

   return( [NSMethodSignature _signatureWithObjCTypes:method->descriptor.signature
                                 methodDescriptorBits:method->descriptor.bits]);
}


+ (NSMethodSignature *) instanceMethodSignatureForSelector:(SEL) sel
{
   struct _mulle_objc_method   *method;

   assert( _mulle_objc_class_is_infraclass( (void *)  self));
   method = _mulle_objc_class_search_method( _mulle_objc_infraclass_as_class( self),
                                             (mulle_objc_methodid_t) sel,
                                             NULL,
                                             MULLE_OBJC_ANY_OWNER,
                                             _mulle_objc_infraclass_get_inheritance( self),
                                             NULL);
   if( ! method)
      return( nil);

   return( [NSMethodSignature signatureWithObjCTypes:method->descriptor.signature]);
}


//
// subclasses should just override this, for best performance
//
- (void *) forward:(void *) _param
{
   id                  target;
   NSMethodSignature   *signature;
   NSInvocation        *invocation;
   void                *rval;

   target = [self forwardingTargetForSelector:_cmd];
   if( target)
      return( mulle_objc_object_inline_variable_methodid_call( target, (mulle_objc_methodid_t) _cmd, _param));

   /*
    * the slowness of these operations can not even be charted
    * I need to code something better
    */
   signature = [self methodSignatureForSelector:_cmd];
   if( ! signature)
   {
      [self doesNotRecognizeSelector:_cmd];
      return( NULL);
   }

   if( [signature isVariadic])
   {
      [self doesNotForwardVariadicSelector:_cmd];
      return( NULL);
   }

   invocation = [NSInvocation invocationWithMethodSignature:signature];
   [invocation setSelector:_cmd];
   [invocation _setMetaABIFrame:_param];
   [self forwardInvocation:invocation];

   switch( [signature _methodMetaABIReturnType])
   {
   case MulleObjCMetaABITypeVoid :
      return( NULL);

   case MulleObjCMetaABITypeVoidPointer :
      [invocation getReturnValue:&rval];
      return( rval);

   case MulleObjCMetaABITypeParameterBlock :
      [invocation getReturnValue:_param];
      return( _param);
   }
}


- (void) forwardInvocation:(NSInvocation *) anInvocation
{
   [self doesNotRecognizeSelector:[anInvocation selector]];
}

@end

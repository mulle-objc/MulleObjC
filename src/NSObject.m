/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSObject.m is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSObject.h"

#import "ns_type.h"
#import "ns_debug.h"
#import "NSCopying.h"
#import "NSAutoreleasePool.h"
#import "MulleObjCAllocation.h"
#import "NSMethodSignature.h"
#import "NSInvocation.h"


@interface NSObject ( NSCopying)

- (instancetype) copy;

@end


@interface NSObject ( NSMutableCopying)

- (instancetype) mutableCopy;

@end

// desperately need @classid( ) compiler support in clang

#define _MulleObjCInstantiatePlaceholderHash  0xb29be388c5d2b55b  // _MulleObjCInstantiatePlaceholder

// intentonally a root object (!)
@interface _MulleObjCInstantiatePlaceholder
{
@public
   Class   _cls;
}
@end


@implementation _MulleObjCInstantiatePlaceholder

- (void) finalize
{
   _MulleObjCFinalizeObject( self);
}


- (void) dealloc
{
   _MulleObjCDeallocateObject( self);
}


- (void *) forward:(void *) _param
{
   id  obj;

   assert( _cls);
   
   // assert that we are calling an init method
#ifndef NDEBUG
   {
      struct _mulle_objc_method             *method;
      struct _mulle_objc_methoddescriptor   *desc;
      
      method = _mulle_objc_class_search_method( _cls, _cmd, _mulle_objc_class_get_inheritance( _cls));
      if( method)
      {
         desc = _mulle_objc_method_get_methoddescriptor( method);
         assert( _mulle_objc_methoddescriptor_is_init_method( desc));
      }
   }
#endif

   obj = [_cls alloc];
   obj = mulle_objc_object_inline_variable_selector_call( obj, _cmd, _param);
   [obj autorelease];
   return( obj);
}

@end



@implementation NSObject

+ (void) initialize
{
   // this is called by all subclasses, that don't implement #initialize
   // so don't do much/anything here (or protect against it)
#if DEBUG_INITIALIZE
   printf( "+[%s initialize] handled by %s\n", _mulle_objc_class_get_name( self), __PRETTY_FUNCTION__);
#endif   
}


+ (nonnull instancetype) alloc
{
   return( _MulleObjCAllocateObject( self, 0));
}


+ (nonnull instancetype) allocWithZone:(NSZone *) zone
{
   return( _MulleObjCAllocateObject( self, 0));
}


- (void) finalize
{
   _MulleObjCFinalizeObject( self);
}


- (void) dealloc
{
   _MulleObjCDeallocateObject( self);
}


+ (instancetype) new
{
   id   p;
   
   p = _MulleObjCAllocateObject( self, 0);
   return( [p init]);
}


#pragma mark -
#pragma mark these methods are only called via performSelector: or some such

//
// these funtions exist, but they are rarely ever called, except when you
// do performSelector or some such.
//

- (NSZone *) zone;  // always NULL
{
   return( (NSZone *) 0);
}


- (nonnull instancetype) retain
{
   return( (id) mulle_objc_object_retain( (struct _mulle_objc_object *) self));
}


- (void) release
{
   mulle_objc_object_release( self);
}


- (nonnull instancetype) autorelease
{
   _MulleObjCAutoreleaseObject( self);
   return( self);
}


- (NSUInteger) retainCount
{
   return( (NSUInteger) _mulle_objc_object_get_retaincount( self));
}


#pragma mark -
#pragma mark AAO methods


struct _mulle_objc_object   *MulleObjCCreatePlaceholder( struct _mulle_objc_class  *self, mulle_objc_classid_t classid)
{
   struct _mulle_objc_runtime          *runtime;
   struct _mulle_objc_class            *cls;
   _MulleObjCInstantiatePlaceholder    *placeholder;
   struct _mulle_objc_method           *method;
   
   assert( classid);
   
   runtime = _mulle_objc_class_get_runtime( self);
   cls     = _mulle_objc_runtime_unfailing_get_or_lookup_class( runtime, classid);
   
   placeholder       = _MulleObjCAllocateObject( cls, 0);
   placeholder->_cls = self;
   
   method      = _mulle_objc_class_search_method( cls, @selector( __initPlaceholder), _mulle_objc_class_get_inheritance( cls));
   if( method)
      (*method->implementation)( placeholder, @selector( __initPlaceholder), NULL);
   _ns_add_placeholder( placeholder);

   return( (struct _mulle_objc_object *) placeholder);
}


+ (mulle_objc_classid_t) __instantiatePlaceholderClassid
{
   return( MULLE_OBJC_CLASSID( _MulleObjCInstantiatePlaceholderHash));
}


+ (nonnull instancetype) instantiate
{
   struct _mulle_objc_object   *placeholder;
   
   placeholder = _mulle_objc_class_get_placeholder( self);
   if( ! placeholder)
   {
      placeholder = MulleObjCCreatePlaceholder( self, [self __instantiatePlaceholderClassid]);
      _mulle_objc_class_set_placeholder( self, placeholder);
   }
   return( (id) placeholder);
}


- (nonnull instancetype) immutableInstance
{
   id   obj;
   
   obj = [self copy];
   NSAutoreleaseObject( obj);
   return( obj);
}


- (nonnull instancetype) mutableInstance
{
   id   obj;
   
   obj = [self mutableCopy];
   NSAutoreleaseObject( obj);
   return( obj);
}


- (NSUInteger) getRootObjects:(id *) buf
                       length:(NSUInteger) length
{
   struct _ns_rootconfiguration   *config;
   struct _mulle_objc_runtime     *runtime;
   NSUInteger                     count;
   struct mulle_setenumerator     rover;
   id                             obj;
   id                             *sentinel;
   
   runtime = mulle_objc_inlined_get_runtime();
   
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


- (void) becomePlaceholder
{
   [self retain];
   _ns_add_placeholder( self);
}


- (void) becomeSingleton
{
   [self retain];
   _ns_add_singleton( self);
}


- (void) becomeRootObject
{
   [self retain];
   _ns_add_root( self);
}


- (void) resignAsRootObject
{
   _ns_remove_root( self);
   [self autorelease];
}


- (void) pushToParentAutoreleasePool
{
   NSAutoreleasePool   *pool;
   
   pool = [NSAutoreleasePool parentAutoreleasePool];
   if( pool)
   {
      [self retain];
      [pool addObject:self];
      return;
   }
   
   [self becomeRootObject];
}


# pragma mark -
# pragma mark normal methods

- (instancetype) init
{
   return( self);
}


- (BOOL) isEqual:(id) other
{
   return( self == other);
}


// why it's code like this
// stipulation is, we have:  
//    unsigned int for retainCount
//    isa for objc
// + 2 ivars -> 16 bytes (32 bit) or
//  32 bytes (64 bit)
//
// compiler should optimize this to
// a single inlined rotation instruction since this
// can be all computed at compile time
//
static inline int   shift_factor( void)
{
   return( sizeof( uintptr_t) == 4 ? 4 : 5);
}


static inline int   max_factor( void)
{
   return( sizeof( uintptr_t) * 8);
}


static inline uintptr_t   rotate_uintptr( uintptr_t x)
{
   
   return( (x >> shift_factor()) | (x << (max_factor() - shift_factor())));
}


- (NSUInteger) hash
{
   return( (NSUInteger) rotate_uintptr( (uintptr_t) self));
}


- (Class) superclass
{
   return( _mulle_objc_class_get_superclass( _mulle_objc_object_get_class( self)));
}


//
// +class loops around to - class
//
- (nonnull Class) class
{
   struct _mulle_objc_class  *cls;

   cls = _mulle_objc_object_get_class( self);
   return( cls);
}


- (nonnull instancetype) self
{
   return( self);
}


- (id) performSelector:(SEL) sel
{
   return( mulle_objc_object_inline_variable_selector_call( self, sel, (void *) 0));
}


- (id) performSelector:(SEL) sel
            withObject:(id) obj
{
   return( mulle_objc_object_inline_variable_selector_call( self, sel, (void *) obj));
}


/* this is pretty much the worst case for the META-ABI,
   since we need to extract sel from _param and have to alloca and reshuffle
   everything 
 */
- (id) performSelector:(SEL) sel
            withObject:(id) obj1
            withObject:(id) obj2
{
   union
   {
      struct
      {
         id   obj1;
         id   obj2;
      } data;
      void   *space[ 5];      // IMPORTANT!!
   } param;
   
   param.data.obj1 = obj1;
   param.data.obj2 = obj2;
   
   return( mulle_objc_object_inline_variable_selector_call( self, sel, &param));
}
          

- (BOOL) isProxy
{
   return( NO);
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
   while( cls = _mulle_objc_class_get_superclass( cls));
   return( NO);
}


- (BOOL) isKindOfClass:(Class) otherClass
{
   Class   cls;
   
   cls = _mulle_objc_object_get_isa( self);
   do
   {
      if( cls == otherClass)
         return( YES);
   }
   while( cls = _mulle_objc_class_get_superclass( cls));
   return( NO);
}


- (BOOL) isMemberOfClass:(Class) cls
{
   return( (Class) _mulle_objc_object_get_isa( self) == cls);
}


- (BOOL) conformsToProtocol:(PROTOCOL) protocol
{
   return( (BOOL) _mulle_objc_class_conforms_to_protocol( _mulle_objc_object_get_isa( self), (mulle_objc_protocolid_t) protocol));
}


- (BOOL) respondsToSelector:(SEL) sel
{
   Class   cls;
   IMP     imp;
   
   cls = _mulle_objc_object_get_isa( self);
   imp = (IMP) _mulle_objc_class_lookup_or_search_methodimplementation_no_forward( cls, sel);
   return( imp ? YES : NO);
}


- (id) description
{
   return( nil);
}


+ (BOOL) instancesRespondToSelector:(SEL) sel
{
   IMP   imp;
   
   imp = (IMP) _mulle_objc_class_lookup_or_search_methodimplementation_no_forward( self, sel);
   return( imp ? YES : NO);
}


+ (IMP) instanceMethodForSelector:(SEL) sel
{
   // don't cache the forward entry yet
   return( (IMP) _mulle_objc_class_lookup_or_search_methodimplementation( self, sel));
}


- (IMP) methodForSelector:(SEL) sel
{
   return( (IMP) _mulle_objc_object_lookup_or_search_methodimplementation( (void *) self, sel));
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


- (NSUInteger) getOwnedObjects:(id *) objects
                        length:(NSUInteger) length
{
   Class                 cls;
   struct collect_info   info;
   
   assert( (! objects && ! length) || objects);
   
   info.self     = self;
   info.n        = 0;
   info.objects  = objects;
   info.sentinel = &objects[ length];
   
   cls = _mulle_objc_object_get_isa( self);
   _mulle_objc_class_walk_ivars( cls,
                                 _mulle_objc_class_get_inheritance( cls),
                                 (void *) collect,
                                 &info);
   return( info.n);
}


- (id) forwardingTargetForSelector:(SEL) sel
{
   return( nil);
}


- (void) doesNotRecognizeSelector:(SEL) sel
{
   struct _mulle_objc_class   *cls;
   
   cls = _mulle_objc_object_get_isa( self);
   _mulle_objc_class_raise_method_not_found_exception( cls, sel);
}


- (NSMethodSignature *) methodSignatureForSelector:(SEL) sel
{
   struct _mulle_objc_class    *cls;
   struct _mulle_objc_method   *method;
   
   cls    = _mulle_objc_object_get_isa( self);
   method = _mulle_objc_class_search_method( cls, sel, _mulle_objc_class_get_inheritance( cls));
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
      return( mulle_objc_object_inline_variable_selector_call( target, _cmd, _param));

   /*
    * the slowness of these operations can not even be charted
    * I need to code something better
    */
   signature = [self methodSignatureForSelector:_cmd];
   if( ! signature)
      [self doesNotRecognizeSelector:_cmd];
   
   invocation = [NSInvocation invocationWithMethodSignature:signature];
   [invocation setSelector:_cmd];
   [invocation setMetaABIFrame:_param];
   [self forwardInvocation:invocation];
   
   switch( [signature methodMetaABIReturnType])
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



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
#import "NSCopying.h"
#import "NSMutableCopying.h"
#import "NSAutoreleasePool.h"
#import "NSAllocation.h"


@implementation NSObject

+ (void) initialize
{
   // this is called by all subclasses, that don't implement #initialize
   // so don't do much/anything here (or protect against it)
#if DEBUG_INITIALIZE
   printf( "+[%s initialize] handled by %s\n", _mulle_objc_class_get_name( self), __PRETTY_FUNCTION__);
#endif   
}


+ (id) alloc
{
   return( _NSAllocateObject( self, 0, NULL));
}


+ (id) allocWithZone:(NSZone *) zone
{
   return( _NSAllocateObject( self, 0, NULL));
}


static int   zero_property( struct _mulle_objc_property *property, struct _mulle_objc_class *cls, void *self)
{
   switch( *_mulle_objc_property_get_signature( property))
   {
   case _C_COPY_ID   :
   case _C_RETAIN_ID :
      mulle_objc_object_call_no_fastmethod( self, property->setter, nil);
   }
   return( 0);
}

- (void) dealloc
{
   // walk through properties and release them
   struct _mulle_objc_class   *cls;
   
   cls = _mulle_objc_object_get_isa( self);
   _mulle_objc_class_walk_properties( cls, _mulle_objc_class_get_inheritance( cls), zero_property, self);
   NSDeallocateObject( self);
}


+ (id) new
{
   id   p;
   
   p = _NSAllocateObject( self, 0, NULL);
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



- (id) retain
{
   return( (id) mulle_objc_object_retain( (struct _mulle_objc_object *) self));
}


- (void) release
{
   mulle_objc_object_release( self);
}


- (id) autorelease
{
   return( (id) NSAutoreleaseObject( self));
}


- (NSUInteger) retainCount
{
   return( (NSUInteger) _mulle_objc_object_get_retaincount( self));
}



# pragma mark -
# pragma mark normal methods

- (id) init
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
   return( _mulle_objc_class_get_superclass( _mulle_objc_object_get_isa( self)));
}


- (Class) class
{
   struct _mulle_objc_class  *cls;

   cls = _mulle_objc_object_get_class( self);
   assert( cls);
   return( cls);
}


- (id) self
{
   return( self);
}


- (id) performSelector:(SEL) sel
{
   return( mulle_objc_object_inline_call( self, sel, (void *) 0));
}


- (id) performSelector:(SEL) sel
            withObject:(id) obj
{
   return( mulle_objc_object_inline_call( self, sel, (void *) obj));
}


- (id) performSelector:(SEL) sel
            withObject:(id) obj1
            withObject:(id) obj2
{
   abort(); // not yet
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
   imp = (IMP) _mulle_objc_class_get_cached_methodimplementation( cls, sel);
   if( imp)
      return( YES);
   if( mulle_objc_class_lookup_method( cls, sel))
      return( YES);
   return( NO);
}


- (id) description
{
   return( nil);
}


// yes it's +
+ (id) copyWithZone:(NSZone *) zone
{
   return( self);
}


// yes it's +
+ (id) mutableCopyWithZone:(NSZone *) zone
{
   return( self);  
}


- (id) copy
{
   return( [self copyWithZone:0]);
}


- (id) mutableCopy
{
   return( [self mutableCopyWithZone:(void *) 0]);
}


+ (BOOL) instancesRespondToSelector:(SEL) sel
{
   Class                       cls;
   struct _mulle_objc_method   *method;
   
   cls    = _mulle_objc_class_get_infraclass( self);
   method = mulle_objc_class_lookup_method( cls, sel);
   return( method != (void *) 0);
}


+ (IMP) instanceMethodForSelector:(SEL) sel
{
   Class   cls;
   
   cls = _mulle_objc_class_get_infraclass( self);
   return( (IMP) _mulle_objc_class_lookup_or_search_methodimplementation( cls, sel));
}


- (IMP) methodForSelector:(SEL) sel
{
   Class    cls;
   
   cls = _mulle_objc_object_get_isa( self);
   return( (IMP) _mulle_objc_class_lookup_or_search_methodimplementation( cls, sel));
}


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

@end


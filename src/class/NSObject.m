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
#import "import-private.h"

#import "NSObject.h"

// other files in this library
#import "mulle-objc-type.h"
#import "mulle-objc-classbit.h"
#import "MulleObjCExceptionHandler.h"
#import "MulleObjCExceptionHandler-Private.h"
#import "MulleObjCIntegralType.h"
#import "MulleObjCAllocation.h"
#import "MulleObjCSingleton.h"
#import "NSDebug.h"
#import "NSRange.h"
#import "NSCopying.h"
#import "NSAutoreleasePool.h"
#import "NSMethodSignature.h"
#import "NSInvocation.h"
#import "mulle-objc-exceptionhandlertable-private.h"
#import "mulle-objc-universefoundationinfo-private.h"


#pragma clang diagnostic ignored "-Wobjc-root-class"
#pragma clang diagnostic ignored "-Wparentheses"


@interface NSObject ( NSCopying)

- (instancetype) copy;

@end


@interface NSObject ( NSMutableCopying)

- (instancetype) mutableCopy;

@end


// intentonally a root object (!)
@interface _MulleObjCInstantiatePlaceholder
{
@public
   Class   _cls;
}

+ (Class) class;

@end


#pragma mark - ### _MulleObjCInstantiatePlaceholder ###

@implementation _MulleObjCInstantiatePlaceholder

+ (Class) class
{
   return( self);
}


- (void *) forward:(void *) _param
{
   id  obj;

   assert( _cls);

   // assert that we are calling an init method
#ifndef NDEBUG
   {
      struct _mulle_objc_method       *method;
      struct _mulle_objc_descriptor   *desc;
      struct _mulle_objc_class        *cls;

      cls = _mulle_objc_infraclass_as_class( _cls);
      method = mulle_objc_class_defaultsearch_method( cls,
                                                      (mulle_objc_methodid_t) _cmd);
      if( method)
      {
         desc = _mulle_objc_method_get_descriptor( method);
         assert( _mulle_objc_descriptor_is_init_method( desc));
      }
   }
#endif

   obj = [_cls alloc];
   obj = mulle_objc_object_call_variablemethodid_inline( obj, 
                                                         (mulle_objc_methodid_t) _cmd, 
                                                         _param);
   [obj autorelease];
   return( obj);
}


static id   _MulleObjCInstantiatePlaceholderNew( Class infraCls)
{
   mulle_objc_implementation_t   imp;
   mulle_objc_methodid_t         sel;
   struct _mulle_objc_universe   *universe;
   struct _mulle_objc_class      *cls;
   struct mulle_allocator        *allocator;
   struct _mulle_objc_object     *placeholder;

   //
   // so that the placeholder doesn't show up in leak tests
   // we place it into the universe allocator
   // if the __initClassCluster does allocations he should do the same
   // but that's gonna be a bit more tricky
   //
   universe    = _mulle_objc_infraclass_get_universe( infraCls);
   allocator   = _mulle_objc_universe_get_allocator( universe);
   placeholder = _mulle_objc_infraclass_allocator_alloc_instance_extra( infraCls, 0, allocator);

   cls         = _mulle_objc_infraclass_as_class( infraCls);
   sel         = @selector( __initInstantiate);
   imp         = _mulle_objc_class_lookup_implementation_noforward( cls, sel);
   if( imp)
      (*imp)( placeholder, sel, NULL);

   return( (id) placeholder);
}


//
// infraClass is the placeholder class, of which we create an instance
// the infraClass with classid is placed into the placeholder
//
static id
   _MulleObjCInstantiatePlaceholderNewForClass( Class placeholderInfracls,
                                                Class infraCls)
{
   _MulleObjCInstantiatePlaceholder    *placeholder;

   assert( placeholderInfracls);

   placeholder       = _MulleObjCInstantiatePlaceholderNew( placeholderInfracls);
   placeholder->_cls = infraCls;
   return( placeholder);
}


/*
 * because we don't allocate the placeholder using the infraClass
 * allocator, we must release it with a custom function, that
 * gets the proper allocator from the universe. Then the placeholder
 * won't appear as leaks in tests...
 */
- (void) dealloc
{
   struct _mulle_objc_universe   *universe;
   struct _mulle_objc_class      *cls;
   struct mulle_allocator        *allocator;

   cls       = _mulle_objc_object_get_isa( self);
   universe  = _mulle_objc_class_get_universe( cls);
   allocator = _mulle_objc_universe_get_allocator( universe);
   __mulle_objc_instance_free( (void *) self, allocator);
}


- (void) finalize
{
}


- (void) release
{
}

@end


#pragma mark - ### NSObject ###

@implementation NSObject

+ (instancetype) alloc
{
   return( _MulleObjCClassAllocateInstance( self, 0));
}


+ (instancetype) allocWithZone:(NSZone *) zone
{
   return( _MulleObjCClassAllocateInstance( self, 0));
}


+ (instancetype) new
{
   return( [_MulleObjCClassAllocateInstance( self, 0) init]);
}


- (NSZone *) zone  // always NULL
{
   return( (NSZone *) 0);
}


- (struct mulle_allocator *) mulleAllocator
{
   return( MulleObjCInstanceGetAllocator( self));
}


- (void) mullePerformFinalize
{
   _mulle_objc_object_perform_finalize( self);
}


- (BOOL) mulleIsFinalized
{
   return( _mulle_objc_object_is_finalized( self));
}


- (void) finalize
{
   _MulleObjCInstanceClearProperties( self);
}


- (void) dealloc
{
#if DEBUG
   struct _mulle_objc_universe                 *universe;
   struct _mulle_objc_universefoundationinfo   *config;

   universe = _mulle_objc_object_get_universe( self);
   config   = _mulle_objc_universe_get_universefoundationinfo( universe);

   if( config->object.zombieenabled)
   {
      if( [NSAutoreleasePool _countObject:self] )
         __mulle_objc_universe_raise_internalinconsistency( universe,
         					"deallocing object %p still in autoreleasepool", self);
   }
#endif
   _MulleObjCInstanceFree( self);
}


#pragma mark - lifetime management


//
// this "facility" catches release/autorelease mistakes, but only for
// single threaded programs. For multithreaded one would need to suspend all
// other threads and inspect their autorelease pools as well
//
#ifdef DEBUG
static void   checkAutoreleaseRelease( NSObject *self)
{
   struct _mulle_objc_universe                  *universe;
   struct _mulle_objc_universefoundationinfo   *config;

   universe = _mulle_objc_object_get_universe( self);
   config   = _mulle_objc_universe_get_universefoundationinfo( universe);

   if( config->object.zombieenabled)
   {
      NSUInteger   autoreleaseCount;
      NSUInteger   retainCount;

      autoreleaseCount = [NSAutoreleasePool _countObject:self];
      retainCount      = [self retainCount];
      if( autoreleaseCount >= retainCount)
      {
         __mulle_objc_universe_raise_internalinconsistency( universe,
               "object %p would be autoreleased too often", self);
   	}
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

   _mulle_objc_object_release_inline( self);
}


- (instancetype) autorelease
{
   checkAutoreleaseRelease( self);

   _MulleObjCAutoreleaseObject( self);
   return( self);
}


- (instancetype) retain
{
   return( (id) mulle_objc_object_retain( (struct _mulle_objc_object *) self));
}


- (NSUInteger) retainCount
{
   return( (NSUInteger) _mulle_objc_object_get_retaincount( self));
}


- (instancetype) self
{
   return( self);
}


#pragma mark - singleton/classcluster support

- (BOOL) __isSingletonObject
{
   return( NO);
}


- (BOOL) __isClassClusterObject
{
   return( NO);
}


#pragma mark - aam support

+ (Class) __instantiateClass
{
   return( [_MulleObjCInstantiatePlaceholder class]);
}


//
// This creates a _MulleObjCInstantiatePlaceholder object that will
// use forward: to wrap the following init... call with an
// autorelease.
//
// E.g.  [NSObject instantiate] creates a _MulleObjCInstantiatePlaceholder
// on the first run that contains [NSObject class] as its ivar. This will then
// be used to message init. The _MulleObjCInstantiatePlaceholder forward:
// method will then allocate an object from via the ivar class. Call init
// (which is the forward:ed selector) and then autorelease.
//
+ (instancetype) instantiate
{
   _MulleObjCInstantiatePlaceholder   *placeholder;
   Class                              placeholderClass;

retry:
   placeholder = (id) _mulle_objc_infraclass_get_instantiate( self);
   if( ! placeholder)
   {
      placeholderClass  = [self __instantiateClass];
      placeholder       = _MulleObjCInstantiatePlaceholderNewForClass( placeholderClass, self);
      if( ! _mulle_objc_infraclass_set_instantiate( self, (void *) placeholder))
      {
         [placeholder dealloc];
         goto retry;
      }
      _mulle_objc_object_constantify_noatomic( placeholder);
   }
   return( (id) placeholder);
}


+ (instancetype) instantiatedObject // alloc + autorelease + init
{
   return( [[self instantiate] init]);
}


+ (instancetype) object // same as above
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
                      maxCount:(NSUInteger) maxCount
{
   struct _mulle_objc_universefoundationinfo   *config;
   struct _mulle_objc_universe                 *universe;
   NSUInteger                                  count;
   struct mulle_setenumerator                  rover;
   id                                          obj;
   id                                          *sentinel;

   universe = _mulle_objc_infraclass_get_universe( self);

   _mulle_objc_universe_lock( universe);
   {
      _mulle_objc_universe_get_foundationspace( universe, (void **) &config, NULL);

      count    = mulle_set_get_count( config->object.roots);
      sentinel = &buf[ count < maxCount ? count : maxCount];

      rover = mulle_set_enumerate( config->object.roots);
      while( buf < sentinel)
      {
         mulle_setenumerator_next( &rover, (void **) &obj);
         assert( obj);
         *buf++ = obj;
      }
      mulle_setenumerator_done( &rover);
   }
   _mulle_objc_universe_unlock( universe);

   return( count);
}


- (BOOL) _isRootObject
{
   struct _mulle_objc_universefoundationinfo   *config;
   struct _mulle_objc_universe                 *universe;
   struct mulle_setenumerator                  rover;
   id                                          obj;

   universe = _mulle_objc_object_get_universe( self);
   obj      = nil;

   _mulle_objc_universe_lock( universe);
   {
      _mulle_objc_universe_get_foundationspace( universe, (void **) &config, NULL);

      rover = mulle_set_enumerate( config->object.roots);
      while( mulle_setenumerator_next( &rover, (void **) &obj))
      {
         if( obj == self)
            break;
      }
      mulle_setenumerator_done( &rover);
   }
   _mulle_objc_universe_unlock( universe);

   return( obj ? YES : NO);
}


- (id) _becomeRootObject
{
   struct _mulle_objc_universe   *universe;

   if( _mulle_objc_object_is_constant( self))
      return( self);

   assert( ! [self _isRootObject]);

   self = [self retain];
   universe = _mulle_objc_object_get_universe( self);
   _mulle_objc_universe_add_rootobject( universe, self);
   return( self);
}


- (id) _resignAsRootObject
{
   struct _mulle_objc_universe   *universe;

   if( _mulle_objc_object_is_constant( self))
      return( self);

   universe = _mulle_objc_object_get_universe( self);
   _mulle_objc_universe_remove_rootobject( universe, self);
   return( [self autorelease]);
}


- (id) _pushToParentAutoreleasePool
{
   NSAutoreleasePool   *pool;

   pool = [NSAutoreleasePool _parentAutoreleasePool];
   if( pool)
   {
      [self retain];
      [pool addObject:self];
      return( self);
   }

   return( [self _becomeRootObject]);
}


#if HAVE_CLASS_VALUE

# pragma mark - class "variable" support

/* The classvalues are all taken down when the runtime
   collapses. (before classes are deallocated !)
 */

+ (void) removeClassValueForKey:(id) aKey
{
   struct _mulle_objc_universe   *universe;
   struct _mulle_objc_object     *key;
   int                           rval;
   id                            old;

   key = (struct _mulle_objc_object *) aKey;
   assert( key);
   assert( _mulle_objc_object_is_constant( key));

   while( old = _mulle_objc_infraclass_get_cvar( self, key))
   {
      rval = _mulle_objc_infraclass_remove_cvar( self, key, old);
      if( ! rval)
      {
         [old autorelease];
         return;
      }

      if( rval == ENOENT)
         return;

      errno    = rval;
      universe = _mulle_objc_object_get_universe( self);
      __mulle_objc_universe_raise_errno( universe, "failed to remove key");
   }
}


+ (BOOL) insertClassValue:(id) value
                   forKey:(id) aKey
{
   struct _mulle_objc_universe   *universe;
   struct _mulle_objc_object     *key;
   int                           rval;

   key = (struct _mulle_objc_object *) aKey;
   assert( value);
   assert( key);
   assert( _mulle_objc_object_is_constant( key));

   [value retain];
   rval = _mulle_objc_infraclass_set_cvar( self, key, value);
   if( ! rval)
      return( YES);

   if( rval == EEXIST)
   {
      [value autorelease];
      return( NO);
   }

   [value autorelease];
   errno    = rval;
   universe = _mulle_objc_object_get_universe( self);
   __mulle_objc_universe_raise_errno( universe, "failed to insert key");
}


+ (void) setClassValue:(id) value
                forKey:(id) aKey
{
   if( ! value)
   {
      [self removeClassValueForKey:aKey];
      return;
   }

   //
   // predict an empty place, otherwise remove
   // previous
   //
   while( ! [self insertClassValue:value
                            forKey:aKey])
      [self removeClassValueForKey:aKey];
}


+ (id) classValueForKey:(id) aKey
{
   struct _mulle_objc_object   *key;

   key = (struct _mulle_objc_object *) aKey;
   assert( key);
   assert( _mulle_objc_object_is_constant( key));

   return( _mulle_objc_infraclass_get_cvar( self, key));
}

#endif


# pragma mark - regular methods

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


#pragma mark - object introspection

- (BOOL) isProxy
{
   return( NO);
}


#pragma mark - class introspection

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


- (char *) UTF8String
{
   char                       *result;
   char                       *s;
   struct _mulle_objc_class   *cls;

   cls = _mulle_objc_object_get_isa( self);
   s   = _mulle_objc_class_get_name( cls);

   mulle_asprintf( &result, "<%s %p>", s, self);
   MulleObjCAutoreleaseAllocation( result, NULL);

   return( result);
}


- (char *) colorizerPrefixUTF8String
{
   return( NULL);
}


- (char *) colorizerSuffixUTF8String
{
   return( "\033[0m");
}


- (char *) colorizedUTF8String
{
   char   *colorizedHeader;
   char   *colorizedFooter;
   char   *s;
   char   *result;

   s               = [self UTF8String];
   colorizedHeader = [self colorizerPrefixUTF8String];

   if( ! colorizedHeader)
      return( s);

   colorizedFooter = [self colorizerSuffixUTF8String];
   mulle_asprintf( &result, "%s%s%s", colorizedHeader, s, colorizedFooter);
   MulleObjCAutoreleaseAllocation( result, NULL);

   return( result);
}


#pragma mark - protocol introspection

- (BOOL) mulleContainsProtocol:(PROTOCOL) protocol
{
   struct _mulle_objc_class       *cls;
   struct _mulle_objc_classpair   *pair;

   cls  = _mulle_objc_object_get_isa( self);
   pair = _mulle_objc_class_get_classpair( cls);
   return( (BOOL) _mulle_objc_classpair_has_protocolid( pair,
                                                        (mulle_objc_protocolid_t) protocol));
}


- (BOOL) conformsToProtocol:(PROTOCOL) protocol
{
   struct _mulle_objc_class       *cls;
   struct _mulle_objc_classpair   *pair;

   cls  = _mulle_objc_object_get_isa( self);
   pair = _mulle_objc_class_get_classpair( cls);
   return( (BOOL) _mulle_objc_classpair_conformsto_protocolid( pair,
                                                              (mulle_objc_protocolid_t) protocol));
}


#pragma mark - method introspection

- (id) performSelector:(SEL) sel
{
   return( mulle_objc_object_call_variablemethodid_inline( self, (mulle_objc_methodid_t) sel, (void *) self));
}


- (id) performSelector:(SEL) sel
            withObject:(id) obj
{
   return( mulle_objc_object_call_variablemethodid_inline( self, (mulle_objc_methodid_t) sel, (void *) obj));
}


/* this is pretty much the worst case for the META-ABI,
   since we need to extract sel from _param and have to alloca and reshuffle
   everything
 */
- (id) performSelector:(SEL) sel
            withObject:(id) obj1
            withObject:(id) obj2
{
   mulle_metaabi_union( id,
                         struct
                         {
                             id   obj1;
                             id   obj2;
                         }) param;

   param.p.obj1 = obj1;
   param.p.obj2 = obj2;

   return( mulle_objc_object_call_variablemethodid_inline( self, (mulle_objc_methodid_t) sel, &param));
}


- (BOOL) respondsToSelector:(SEL) sel
{
   struct _mulle_objc_class   *cls;
   IMP                        imp;

   // OS X compatible
   if( ! sel)
      return( NO);

   cls = _mulle_objc_object_get_isa( self);
   imp = (IMP) _mulle_objc_class_lookup_implementation_noforward( cls,
                                                                  (mulle_objc_methodid_t) sel);
   return( imp ? YES : NO);
}


- (IMP) methodForSelector:(SEL) sel
{
   // this produces NSInvalidArgumentException on OS X for (SEL) 0
   return( (IMP) _mulle_objc_object_lookup_implementation( (void *) self,
                                                            (mulle_objc_methodid_t) sel));
}


+ (BOOL) instancesRespondToSelector:(SEL) sel
{
   struct _mulle_objc_class   *cls;
   IMP                        imp;

   // OS X compatible
   if( ! sel)
      return( NO);

   //
   // must be non caching for technical reasons (them being)
   // that the infraclass cache may not be ready yet
   //
   cls = _mulle_objc_infraclass_as_class( self);
   imp = (IMP) _mulle_objc_class_lookup_implementation_nocache_noforward( cls,
                                                                          (mulle_objc_methodid_t) sel);
   return( imp ? YES : NO);
}


+ (IMP) instanceMethodForSelector:(SEL) sel
{
   struct _mulle_objc_class   *cls;

   // this produces NSInvalidArgumentException on OS X for (SEL) 0

   //
   // must be non caching for technical reasons (them being)
   // that the infraclass cache may not be ready yet
   //
   cls = _mulle_objc_infraclass_as_class( self);
   return( (IMP) _mulle_objc_class_lookup_implementation_nocache( cls,
                                                                  (mulle_objc_methodid_t) sel));
}


#pragma mark - walk object graph support

struct collect_info
{
   id           self;
   NSUInteger   n;
   id           *objects;
   id           *sentinel;
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


+ (NSUInteger) _getOwnedObjects:(id *) objects
                         maxCount:(NSUInteger) maxCount
{
   return( 0);
}


- (NSUInteger) _getOwnedObjects:(id *) objects
                       maxCount:(NSUInteger) maxCount
{
   struct _mulle_objc_class   *cls;
   struct collect_info        info;

   assert( (! objects && ! maxCount) || objects);

   info.self     = self;
   info.n        = 0;
   info.objects  = objects;
   info.sentinel = &objects[ maxCount];

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


#pragma mark - forwarding

- (id) forwardingTargetForSelector:(SEL) sel
{
   return( nil);
}


- (void) doesNotForwardVariadicSelector:(SEL) sel
{
   __mulle_objc_universe_raise_internalinconsistency( _mulle_objc_object_get_universe( self), "variadic methods can not be forwarded using invocations");
}


- (void) doesNotRecognizeSelector:(SEL) sel
{
   struct _mulle_objc_universe   *universe;
   struct _mulle_objc_class      *cls;

   cls      = _mulle_objc_object_get_isa( self);
   universe = _mulle_objc_class_get_universe( cls);
   mulle_objc_universe_fail_methodnotfound( universe, cls, (mulle_objc_methodid_t) sel);
}


- (NSMethodSignature *) methodSignatureForSelector:(SEL) sel
{
   struct _mulle_objc_class    *cls;
   struct _mulle_objc_method   *method;

   // OS X compatible
   if( ! sel)
      return( nil);

   cls    = _mulle_objc_object_get_isa( self);
   method = mulle_objc_class_defaultsearch_method( cls,
                                                  (mulle_objc_methodid_t) sel);
   if( ! method)
      return( nil);

   return( [NSMethodSignature _signatureWithObjCTypes:method->descriptor.signature
                                       descriptorBits:method->descriptor.bits]);
}


+ (NSMethodSignature *) instanceMethodSignatureForSelector:(SEL) sel
{
   struct _mulle_objc_method   *method;

   // OS X compatible
   if( ! sel)
      return( nil);

   assert( _mulle_objc_class_is_infraclass( (void *)  self));
   method = mulle_objc_class_defaultsearch_method( _mulle_objc_infraclass_as_class( self),
                                                   (mulle_objc_methodid_t) sel);
   if( ! method)
      return( nil);

   return( [NSMethodSignature signatureWithObjCTypes:method->descriptor.signature]);
}


- (void *) forward:(void *) param
{
   id                  target;
   NSMethodSignature   *signature;
   NSInvocation        *invocation;
   void                *rval;

   target = [self forwardingTargetForSelector:_cmd];
   if( target)
      return( mulle_objc_object_call_variablemethodid_inline( target,
                                                             (mulle_objc_methodid_t) _cmd,
                                                             param));
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

   /*
    * Why not ? The MetaABI doesn't care or ?
    * Well it does, because though everything is nicely contained in
    * _param, we have to copy _param into the invocation, but don't know
    * its size.
    */
   if( [signature isVariadic])
   {
      [self doesNotForwardVariadicSelector:_cmd];
      return( NULL);
   }

   invocation = [NSInvocation invocationWithMethodSignature:signature];
   // could set target here, but seems pointless (Apple seems to do it though)
   // and a waste of time
   [invocation setSelector:_cmd];
   [invocation _setMetaABIFrame:param];
   [self forwardInvocation:invocation];

   switch( [signature _methodMetaABIReturnType])
   {
   case MulleObjCMetaABITypeVoid :
      return( NULL);

   case MulleObjCMetaABITypeVoidPointer :
      [invocation getReturnValue:&rval];
      return( rval);

   case MulleObjCMetaABITypeParameterBlock :
      [invocation getReturnValue:param];
      return( param);
   }
}


- (void) forwardInvocation:(NSInvocation *) anInvocation
{
   [self doesNotRecognizeSelector:[anInvocation selector]];
}


static int   get_ivar_offset( struct _mulle_objc_infraclass *infra,
                              mulle_objc_ivarid_t ivarid,
                              void *buf,
                              size_t size)
{
   struct _mulle_objc_ivar   *ivar;

   ivar = _mulle_objc_infraclass_search_ivar( infra, ivarid);
   if( ! ivar)
      return( -2);

#ifndef NDEBUG
   {
      char           *signature;
      unsigned int   ivar_size;
      unsigned int   ivar_align;

      signature = _mulle_objc_ivar_get_signature( ivar);
      mulle_objc_signature_supply_size_and_alignment( signature, &ivar_size, &ivar_align);
      assert( ivar_size == size);
      assert( ((intptr_t) buf & (ivar_align - 1)) == 0);
   }
#endif

   return( _mulle_objc_ivar_get_offset( ivar));
}


int   _MulleObjCObjectSetIvar( id self, mulle_objc_ivarid_t ivarid, void *buf, size_t size)
{
   int                        offset;
   struct _mulle_objc_class   *cls;

   cls = _mulle_objc_object_get_isa( self);

   assert( _mulle_objc_class_is_infraclass( cls));
   assert( mulle_objc_ivarid_is_sane( ivarid));
   assert( buf);

   offset = get_ivar_offset( (Class) cls, ivarid, buf, size);
   switch( offset)
   {
   case -2 :
      return( -1);
   case -1 :
      // hashed offset not yet implemented
      return( -1);
   default :
      break;
   }

   memcpy( &((char *) self)[ offset], buf, size);
   return( 0);
}


int   _MulleObjCObjectGetIvar( id self, mulle_objc_ivarid_t ivarid, void *buf, size_t size)
{
   int                        offset;
   struct _mulle_objc_class   *cls;

   cls = _mulle_objc_object_get_isa( self);

   assert( _mulle_objc_class_is_infraclass( cls));
   assert( mulle_objc_ivarid_is_sane( ivarid));
   assert( buf);

   offset = get_ivar_offset( (Class) cls, ivarid, buf, size);
   switch( offset)
   {
      case -2 :
         return( -1);
      case -1 :
         // hashed offset not yet implemented
         return( -1);
      default :
         break;
   }

   memcpy( buf, &((char *) self)[ offset], size);
   return( 0);
}


static void   throw_unknown_ivarid( struct _mulle_objc_class *cls,
                                    mulle_objc_ivarid_t ivarid)
{
   __mulle_objc_universe_raise_invalidargument( _mulle_objc_class_get_universe( cls),
                                              "Class %08x \"%s\" has no ivar with id %08x found",
                                               _mulle_objc_class_get_classid( cls),
                                               _mulle_objc_class_get_name( cls),
                                               ivarid);
}


id   MulleObjCObjectGetObjectIvar( id self, mulle_objc_ivarid_t ivarid)
{
   id   obj;

   if( ! self)
      return( nil);

   if( _MulleObjCObjectGetIvar( self, ivarid, &obj, sizeof( obj)))
      throw_unknown_ivarid( _mulle_objc_object_get_isa( self), ivarid);

   return( obj);
}


void   MulleObjCObjectSetObjectIvar( id self, mulle_objc_ivarid_t ivarid, id value)
{
   id                         old;
   struct _mulle_objc_class   *cls;
   struct _mulle_objc_ivar    *ivar;
   char                       *signature;
   char                       *typeinfo;
   int                        offset;
   id                         *p;

   if( ! self)
      return;

   cls = _mulle_objc_object_get_isa( self);

   assert( _mulle_objc_class_is_infraclass( cls));
   assert( mulle_objc_ivarid_is_sane( ivarid));

   ivar = _mulle_objc_infraclass_search_ivar( (Class) cls, ivarid);
   if( ! ivar)
      throw_unknown_ivarid( cls, ivarid);

   offset = _mulle_objc_ivar_get_offset( ivar);
   if( offset == -1)
      __mulle_objc_universe_raise_internalinconsistency( _mulle_objc_object_get_universe( self),
                                                         "hashed access not yet implemented");

   p         = (id *) &((char *) self)[ offset];
   signature = _mulle_objc_ivar_get_signature( ivar);
   typeinfo  = _mulle_objc_signature_skip_extendedtypeinfo( signature);

   switch( *typeinfo)
   {
   case _C_COPY_ID   :
      old   = *p;
      [old autorelease];
      value = [value copy];
      break;

   case _C_RETAIN_ID :
      old   = *p;
      [old autorelease];
      value = [value retain];
      break;
   }

   *p = value;
}

@end

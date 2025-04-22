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
#import "MulleObjCException.h"
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
#import "NSThread.h"
#import "mulle-objc-exceptionhandlertable-private.h"
#import "mulle-objc-universefoundationinfo-private.h"


#pragma clang diagnostic ignored "-Wobjc-root-class"
#pragma clang diagnostic ignored "-Wparentheses"


// intentonally a root object (!)
@interface _MulleObjCInstantiatePlaceholder <MulleObjCPlaceboRetainCount>
{
@public
   Class   _cls;
}

+ (Class) class;

@end


#pragma mark - ### _MulleObjCInstantiatePlaceholder ###

@implementation _MulleObjCInstantiatePlaceholder

+ (Class) class                        MULLE_OBJC_THREADSAFE_METHOD
{
   return( self);
}


- (void *) forward:(void *) _param     MULLE_OBJC_THREADSAFE_METHOD
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

   // MEMO: can't autorelease ahead of init, because init can return
   //       nil and release object, or release object and return another
   //       alloced one. So if -init raises, we leak and can't do much
   //       about. -raise during -init == BAD
   //
   obj = [_cls alloc];
   obj = mulle_objc_object_call_variable_inline( obj,
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
      mulle_objc_implementation_invoke( imp, placeholder, sel, placeholder);

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

@end


#pragma mark - ### NSObject ###

@implementation NSObject


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


+ (instancetype) object // same as above
{
   id   obj;

   //
   // we don't do the instantiate here, because we autorelease
   // anyway.
   //
   obj = [self alloc];
   obj = [obj init];
   obj = [obj autorelease];
   return( obj);
}


- (instancetype) mulleThreadSafeInstance
{
   id   obj;

   if( [self mulleIsThreadSafe])
      return( self);

   obj = [self immutableInstance];
   assert( [obj mulleIsThreadSafe]);
   return( obj);
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


char   *MulleObjCObjectUTF8String( NSObject *self)
{
   char                       *result;
   char                       *s;
   struct _mulle_objc_class   *cls;

   cls = _mulle_objc_object_get_isa( self);
   s   = _mulle_objc_class_get_name( cls);

   mulle_buffer_do_autoreleased_string( buffer, NULL, result)
   {
      if( MulleObjCDebugElideAddressOutput)
         mulle_buffer_sprintf( buffer, "<%s>", s);
      else
         mulle_buffer_sprintf( buffer, "<%s %p>", s, self);
   }

   return( result);
}


- (char *) nonLockingUTF8String
{
   return( MulleObjCObjectUTF8String( self));
}


- (char *) UTF8String
{
   return( MulleObjCObjectUTF8String( self));
}


+ (char *) nonLockingUTF8String
{
   return( MulleObjCClassUTF8String( self));
}


+ (char *) UTF8String
{
   return( MulleObjCClassUTF8String( self));
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

   s               = [self nonLockingUTF8String];
   colorizedHeader = [self colorizerPrefixUTF8String];

   if( ! colorizedHeader)
      return( s);

   colorizedFooter = [self colorizerSuffixUTF8String];
   mulle_buffer_do_autoreleased_string( buffer, NULL, result)
   {
      mulle_buffer_add_string( buffer, colorizedHeader);
      mulle_buffer_add_string( buffer, s);
      mulle_buffer_add_string( buffer, colorizedFooter);
   }

   return( result);
}


#pragma mark - forwarding

- (id) forwardingTargetForSelector:(SEL) sel
{
   return( nil);
}


- (void) doesNotForwardVariadicSelector:(SEL) sel
{
   struct _mulle_objc_universe   *universe;

   universe = _mulle_objc_object_get_universe( self);
   __mulle_objc_universe_raise_internalinconsistency( universe,
                     "variadic methods can not be forwarded using invocations");
}


- (void) doesNotRecognizeSelector:(SEL) sel
{
   struct _mulle_objc_universe   *universe;
   struct _mulle_objc_class      *cls;

   cls      = _mulle_objc_object_get_isa( self);
   universe = _mulle_objc_class_get_universe( cls);
   mulle_objc_universe_fail_methodnotfound( universe, cls, (mulle_objc_methodid_t) sel);
}


- (void *) forward:(void *) param
{
   id                  target;
   NSMethodSignature   *signature;
   NSInvocation        *invocation;
   void                *rval;

   target = [self forwardingTargetForSelector:_cmd];
   if( target)
      return( mulle_objc_object_call_variable_inline( target,
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


#pragma mark interposing

// change Subclass : Superclass to Subclass : InterposingClass
// where InterposingClass : Superclass
struct interpose_before_ctxt
{
   struct _mulle_objc_infraclass   *subclass;
};


static mulle_objc_walkcommand_t
   interpose_callback( struct _mulle_objc_universe *universe,
                       void *p,
                       enum mulle_objc_walkpointertype_t type,
                       char *key,
                       void *parent,
                       void *userinfo)
{
   struct interpose_before_ctxt    *ctxt = userinfo;
   struct _mulle_objc_infraclass   *infra = p;
   struct _mulle_objc_metaclass    *meta;

   if( mulle_objc_infraclass_is_subclass( infra, ctxt->subclass))
   {
      meta = _mulle_objc_infraclass_get_metaclass( infra);
      mulle_objc_class_invalidate_caches( _mulle_objc_infraclass_as_class( infra), NULL);
      mulle_objc_class_invalidate_caches( _mulle_objc_metaclass_as_class( meta), NULL);
   }
   return( mulle_objc_walk_ok);
}


void  MulleObjCClassInterposeBeforeClass( Class self, Class other)
{
   struct _mulle_objc_infraclass   *infra;
   struct _mulle_objc_infraclass   *super_infra;
   struct _mulle_objc_infraclass   *sub_infra;
   struct _mulle_objc_metaclass    *sub_meta;
   struct _mulle_objc_metaclass    *super_meta;
   struct _mulle_objc_class        *super_meta_superclass;
   struct _mulle_objc_universe     *universe;
   struct interpose_before_ctxt    ctxt;

   if( ! self || ! other)
      return;

   infra       = (struct _mulle_objc_infraclass *) self;
   sub_infra   = (struct _mulle_objc_infraclass *) other;
   super_infra = _mulle_objc_infraclass_get_superclass( sub_infra);

   // we don't do that, its not interposing is it ?
   if( ! super_infra)
      MulleObjCThrowInternalInconsistencyExceptionUTF8String( "the class \"%s\" to interpose is a root class",
               _mulle_objc_infraclass_get_name( sub_infra));

   if( super_infra != _mulle_objc_infraclass_get_superclass( infra))
      MulleObjCThrowInternalInconsistencyExceptionUTF8String( "the class \"%s\" to interpose has a different superclass",
               _mulle_objc_infraclass_get_name( sub_infra));

   // ensure that we don't have any ivars, else this can't work,
   // the base class can have some no problems
   if( _mulle_objc_infraclass_has_ivars( infra))
      MulleObjCThrowInternalInconsistencyExceptionUTF8String( "your interposing class \"%s\" has instance variables",
               _mulle_objc_infraclass_get_name( infra));

   universe = _mulle_objc_infraclass_get_universe( infra);
   _mulle_objc_universe_lock( universe);
   {
      _mulle_objc_class_set_superclass( (struct _mulle_objc_class *) sub_infra,
                                        (struct _mulle_objc_class *) infra);
      _mulle_objc_class_set_superclassid( (struct _mulle_objc_class *) sub_infra,
                                          infra->base.classid);

      sub_meta              = _mulle_objc_infraclass_get_metaclass( sub_infra);
      super_meta            = _mulle_objc_infraclass_get_metaclass( infra);
      super_meta_superclass =  super_meta ? &super_meta->base : &infra->base,

      _mulle_objc_class_set_superclass( (struct _mulle_objc_class *) sub_meta,
                                        (struct _mulle_objc_class *) super_meta_superclass);
      _mulle_objc_class_set_superclassid( (struct _mulle_objc_class *) infra,
                                          super_meta_superclass->classid);

      //
      // all direct subclasses os subClass must invalidate
      //
      ctxt.subclass = sub_infra;
      _mulle_objc_universe_walk_classes( universe, 0, interpose_callback, &ctxt);
   }
   _mulle_objc_universe_unlock( universe);
}

//
// this should be fairly harmless
//
+ (void) mulleInterposeBeforeClass:(Class) subClass
{
   MulleObjCClassInterposeBeforeClass( self, subClass);
}



- (instancetype) copiedInstance
{
   id   obj;

   obj = [(id <NSCopying>) self copy];
   obj = [obj autorelease];
   return( obj);
}


// TODO: move this to NSCopying ?
- (instancetype) immutableInstance
{
   id   obj;

   obj = [(id <MulleObjCImmutableCopying>) self immutableCopy];
   obj = [obj autorelease];
   assert( [obj conformsToProtocol:@protocol( MulleObjCImmutable)]);
   return( obj);
}


- (id) copyWithZone:(NSZone *) zone
{
   fprintf( stderr, "-[NSObject copyWithZone:] doesn't work anymore.\n"
"\n"
"Either rename your -copyWithZone: implementations to -copy or add a\n"
"-copy method to each class that implements -copyWithZone:\n"
"Your returned object must be immutable!\n"
"\n"
"Endless recursion awaits those, who don't heed this advice.\n");
   abort();
}

@end

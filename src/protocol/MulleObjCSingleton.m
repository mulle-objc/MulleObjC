//
//  MulleObjCSingleton.m
//  MulleObjC
//
//  Copyright (c) 2016 Nat! - Mulle kybernetiK.
//  Copyright (c) 2016 Codeon GmbH.
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

#import "MulleObjCSingleton.h"

#import "mulle-objc-type.h"
#import "mulle-objc-classbit.h"
#import "MulleObjCExceptionHandler.h"
#import "MulleObjCExceptionHandler-Private.h"
#import "MulleObjCIntegralType.h"
#import "MulleObjCAllocation.h"
#import "NSRange.h"
#import "MulleObjCVersion.h"

#import "mulle-objc-universefoundationinfo-private.h"


#pragma clang diagnostic ignored "-Wobjc-root-class"
#pragma clang diagnostic ignored "-Wprotocol"


PROTOCOLCLASS_IMPLEMENTATION( MulleObjCSingleton)

static struct
{
   int                               _useEphemeralSingleton;
   struct mulle_concurrent_hashmap   _ephemeralSingletonInstances;
} Self =
{
   -1
};


//
// MULLE_OBJC_IS_CLASSCLUSTER gets inherited by the class, that implements the
// protocol but JUST that class
//
void   MulleObjCSingletonMarkClassAsSingleton( Class self)
{
   struct _mulle_objc_classpair   *pair;

   // has is shallow, conforms is deep
   pair = _mulle_objc_infraclass_get_classpair( self);
   if( _mulle_objc_classpair_has_protocolid( pair, @protocol( MulleObjCSingleton)))
      _mulle_objc_infraclass_set_state_bit( self, MULLE_OBJC_INFRA_IS_SINGLETON);
#if DEBUG
   else
   {
      mulle_objc_universe_fprintf(
         _mulle_objc_infraclass_get_universe( self),
         stderr,
         "warning: Class %08x \"%s\" is a subclass of "
         "MulleObjCSingleton but does not implement it "
         "as a protocol\n",
         _mulle_objc_infraclass_get_classid( self),
         _mulle_objc_infraclass_get_name( self));
   }
#endif
}


+ (void) initialize
{
   struct _mulle_objc_universe   *universe;

   MulleObjCSingletonMarkClassAsSingleton( self);
   if( Self._useEphemeralSingleton == -1)
   {
      Self._useEphemeralSingleton = mulle_objc_environment_get_yes_no( "MULLE_OBJC_EPHEMERAL_SINGLETON");
      if( Self._useEphemeralSingleton > 0)
      {
         // universe allocator partakes in aba GC, but not the class allocator
         universe = _mulle_objc_infraclass_get_universe( self);
         _mulle_concurrent_hashmap_init( &Self._ephemeralSingletonInstances,
                                         16,
                                         _mulle_objc_universe_get_allocator( universe));
         fprintf( stderr, "warning: MulleObjCSingleton are ephemeral\n");
      }
   }
}

//
// why is this unload and not deinitialize ?
// because deinitialize is called before unload, but we need to stick
// around for other classes that depend on us to unload.
// TODO: should get rid of deinitialize ????
//
+ (void) unload
{
   if( Self._useEphemeralSingleton > 0)
   {
      _mulle_concurrent_hashmap_done( &Self._ephemeralSingletonInstances);
      Self._useEphemeralSingleton = -1;
   }
}


MULLE_C_NONNULL_RETURN
static id   MulleObjCSingletonNew( Class self)
{
   id <NSObject>                 singleton;
   mulle_objc_implementation_t   imp;
   mulle_objc_methodid_t         sel;
   struct _mulle_objc_class      *cls;
   struct _mulle_objc_universe   *universe;

   //
   // avoid +alloc here so that subclass can "abort" on alloc if desired
   // singletons mare allocated with the standard instance allocator,
   // because they are a) often complex like NSNotificationCenter and
   // b) the user will expect to "leak" there
   //

   // ensure +initialize has run though (like [self class])
   _mulle_objc_infraclass_setup_if_needed( self);

   universe = _mulle_objc_infraclass_get_universe( self);
   if( ! _mulle_objc_infraclass_get_state_bit( self, MULLE_OBJC_INFRA_IS_SINGLETON))
   {
      __mulle_objc_universe_raise_internalinconsistency( universe,
               "MULLE_OBJC_INFRA_IS_SINGLETON (%s) bit is missing on class "
               "\"%s\" %p with id %x (%s)",
               _mulle_objc_global_lookup_state_bit_name( MULLE_OBJC_INFRA_IS_SINGLETON),
               _mulle_objc_infraclass_get_name( self),
               self,
               _mulle_objc_infraclass_get_classid( self),
               Self._useEphemeralSingleton > 0 ? "ephemeral": "static");
   }

   singleton = _MulleObjCClassAllocateInstance( self, 0);

   // allow __initSingleton and init, but prefer __initSingleton
   cls       = _mulle_objc_infraclass_as_class( self);
   sel       = @selector( __initSingleton);
   imp       = _mulle_objc_class_lookup_implementation_noforward( cls, sel);
   if( ! imp)
   {
      sel    = @selector( init);
      imp    = _mulle_objc_class_lookup_implementation_noforward( cls, sel);
   }
   if( imp)
      singleton = (*imp)( singleton, sel, singleton);

   if( ! singleton)
      abort();

   // not really clear what to do/expect if singleton is nil
   return( (id) singleton);
}


//
// for the receiver the returnvalue is considered autoreleased, he doesn't
// have to retain it, if he doesn't want to keep it
//
id   MulleObjCSingletonCreate( Class self)
{
   id <NSObject>                 singleton;
   id <NSObject>                 dup;
   struct _mulle_objc_universe   *universe;

   //
   // if the universe is deinitializing, we are not creating singletons
   // anymore
   //
   universe = _mulle_objc_infraclass_get_universe( self);
   if( _mulle_objc_universe_is_deinitializing( universe))
      return( nil);

   assert( ! _mulle_objc_infraclass_get_state_bit( self, MULLE_OBJC_INFRA_IS_CLASSCLUSTER));

   if( Self._useEphemeralSingleton > 0)
   {
      singleton = _mulle_concurrent_hashmap_lookup( &Self._ephemeralSingletonInstances,
                                                   (intptr_t) self);
      if( singleton)
         return( singleton);

      singleton = [MulleObjCSingletonNew( self) autorelease];
      dup       = _mulle_concurrent_hashmap_register( &Self._ephemeralSingletonInstances,
                                                     (intptr_t) self,
                                                     singleton);
      if( dup == MULLE_CONCURRENT_INVALID_POINTER)
         abort();
      return( dup ? dup : singleton);
   }


   for(;;)
   {
      singleton = (id) _mulle_objc_infraclass_get_singleton( self);
      if( singleton)
      	return( singleton);

      singleton = MulleObjCSingletonNew( self);
      if( _mulle_objc_infraclass_set_singleton( self, (void *) singleton))
      {
         _mulle_objc_object_constantify_noatomic( singleton); // like autorelease

         universe = _mulle_objc_infraclass_get_universe( self);
         if( universe->debug.trace.class_add)
            mulle_objc_universe_trace( universe, "Class \"%s\" (%08x) gets a singleton %p",
                                                   _mulle_objc_infraclass_get_name( self),
                                                   _mulle_objc_infraclass_get_classid( self),
                                                   singleton);
         return( singleton);
      }
      [singleton release];
   }
}


- (void) dealloc
{
   IMP   imp;

   if( Self._useEphemeralSingleton > 0)
      _mulle_concurrent_hashmap_remove( &Self._ephemeralSingletonInstances,
                                       (intptr_t) _mulle_objc_object_get_isa( self),
                                       self);

   imp = MulleObjCObjectSearchOverriddenIMP( self,
                                             @selector( dealloc),
                                             @selector( MulleObjCSingleton),
                                             0);
   assert( imp != (IMP) _mulle_objc_class_lookup_implementation( _mulle_objc_object_get_isa( self),
                                                                 @selector( dealloc)));
   (*imp)( self, @selector( dealloc), self);
}


//
// a subclass can be installed and, when it's sharedInstance message is called
// it will override the superclass (and be stored in the superclass) provided
// that the subclass does not declare the protocol MulleObjCSingleton again
//
+ (instancetype) sharedInstance
{
   return( MulleObjCSingletonCreate( self));
}


- (BOOL) __isSingletonObject
{
   return( _mulle_objc_object_is_constant( self));
}

PROTOCOLCLASS_END()

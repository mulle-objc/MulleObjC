//
//  MulleObjCClassCluster.m
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

#import "MulleObjCClassCluster.h"

// other files in this library
#import "mulle-objc-type.h"
#import "mulle-objc-classbit.h"
#import "MulleObjCExceptionHandler.h"
#import "MulleObjCIntegralType.h"
#import "MulleObjCAllocation.h"
#import "NSObjectProtocol.h"
#import "NSRange.h"
#import "version.h"

#import "mulle-objc-universefoundationinfo-private.h"


// std-c and dependencies


#pragma clang diagnostic ignored "-Wobjc-root-class"
#pragma clang diagnostic ignored "-Wprotocol"

PROTOCOLCLASS_IMPLEMENTATION( MulleObjCClassCluster)


//
// MULLE_OBJC_IS_CLASSCLUSTER gets inherited by the class, that implements the
// protocol but JUST that class
//
void   MulleObjCClassClusterMarkClassAsClassCluster( Class self)
{
   struct _mulle_objc_classpair   *pair;

   // has is shallow, conforms is deep
   pair = _mulle_objc_infraclass_get_classpair( self);
   if( _mulle_objc_classpair_has_protocolid( pair, (mulle_objc_protocolid_t) @protocol( MulleObjCClassCluster)))
      _mulle_objc_infraclass_set_state_bit( self, MULLE_OBJC_INFRA_IS_CLASSCLUSTER);
}


+ (void) initialize
{
   // mark subclasses but not MulleObjCClassCluster itself
   if( _mulle_objc_infraclass_get_classid( self) != @selector( MulleObjCClassCluster))
      MulleObjCClassClusterMarkClassAsClassCluster( self);
}


/*
 * because we don't allocate the placeholder using the infraClass
 * allocator, we must release it with a custom function, that
 * gets the proper allocator from the universe
 */
- (void) __deallocPlaceholder
{
   struct _mulle_objc_universe     *universe;
   struct _mulle_objc_infraclass   *infra;
   struct mulle_allocator          *allocator;

   infra     = _mulle_objc_class_as_infraclass( _mulle_objc_object_get_isa( self));
   universe  = _mulle_objc_infraclass_get_universe( infra);
   allocator = _mulle_objc_universe_get_allocator( universe);
   __mulle_objc_object_free( (void *) self, allocator);
}


+ (Class) __placeholderClass
{
   return( self);
}


static id   MulleObjCNewClassClusterPlaceholder( Class infraCls)
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
   // if the __initPlaceholder does allocations he should do the same
   // but that's gonna be a bit more tricky
   //
   universe    = _mulle_objc_infraclass_get_universe( infraCls);
   allocator   = _mulle_objc_universe_get_allocator( universe);
   placeholder = __mulle_objc_infraclass_alloc_instance_extra( infraCls, 0, allocator);
   cls         = _mulle_objc_infraclass_as_class( infraCls);
   sel         = @selector( __initPlaceholder);
   imp         = _mulle_objc_class_lookup_implementation_noforward( cls, sel);
   if( imp)
      (*imp)( placeholder, sel, NULL);

   return( (MulleObjCClassCluster *) placeholder);
}


#if DEBUG
//
// provide a breakpoint opportunity. This warning is useful for the
// Foundation itself, not so much for user code though.
//
void   _mulle_objc_warn_classcluster( struct _mulle_objc_infraclass *self);
void   _mulle_objc_warn_classcluster( struct _mulle_objc_infraclass *self)
{
   char   *name;

   name = _mulle_objc_infraclass_get_name( self);
   if( ! strncmp( name, "NS", 2) ||
       ! strncmp( name, "MulleObjC", 9))
   {
      fprintf( stderr, "warning: Class %08x \"%s\" is a subclass of "
                       "MulleObjCClassCluster but it gets allocated directly.\n"
                       "(Non classcluster Foundation subclasses should implement "
                       "+alloc, for user classes this is fine as\n"
                       "NSAllocateObject will be used)\n"
                       "break on _mulle_objc_warn_classcluster to debug)\n",
                 _mulle_objc_infraclass_get_classid( self),
                 name);
   }
}
#endif


+ (instancetype) alloc
{
   struct _mulle_objc_object    *placeholder;
   struct _mulle_objc_universe  *universe;
   Class                        placeholderClass;

   //
   // only the class marked as MulleObjCClassCluster gets the
   // placeholder, subclasses use regular alloc.
   // The class being a classcluster marks itself during +initialize.
   //
   if( ! _mulle_objc_infraclass_get_state_bit( self, MULLE_OBJC_INFRA_IS_CLASSCLUSTER))
   {
#if DEBUG
      _mulle_objc_warn_classcluster( self);
#endif
      return( NSAllocateObject( self, 0, NULL));
   }

   assert( ! _mulle_objc_infraclass_get_state_bit( self, MULLE_OBJC_INFRA_IS_SINGLETON));

   for(;;)
   {
      placeholder = (struct _mulle_objc_object *) _mulle_objc_infraclass_get_placeholder( self);
      if( placeholder)
         return( (MulleObjCClassCluster *) placeholder);

      placeholderClass = [self __placeholderClass];
      placeholder      = (struct _mulle_objc_object *) MulleObjCNewClassClusterPlaceholder( placeholderClass);
      if( _mulle_objc_infraclass_set_placeholder( self, placeholder))
      {
         _mulle_objc_object_constantify_noatomic( placeholder);
         universe = _mulle_objc_infraclass_get_universe( self);
         if( universe->debug.trace.method_cache)
            mulle_objc_universe_trace( universe, "Class \"%s\" (%08x) gets a placeholder %p",
                                                   _mulle_objc_infraclass_get_classid( self),
                                                   _mulle_objc_infraclass_get_name( self),
                                                   placeholder);
         return( (MulleObjCClassCluster *) placeholder);
      }
   }
}


+ (instancetype) allocWithZone:(NSZone *) zone
{
   return( [self alloc]);
}


// this has to be implemented, because new is not alloc/init usually in NSObject
+ (instancetype) new
{
   return( [(id) [self alloc] init]);
}


- (BOOL) __isClassClusterPlaceholderObject
{
   return( _mulle_objc_object_is_constant( self));
}

PROTOCOLCLASS_END()

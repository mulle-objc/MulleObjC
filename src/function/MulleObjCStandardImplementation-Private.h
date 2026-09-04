//
//  MulleObjCStandard-Private.h
//  MulleObjC
//
//  Copyright (c) 2024 Nat! - Mulle kybernetiK.
//  All rights reserved.
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
#ifndef MulleObjCStandardImplementation_Private_h__
#define MulleObjCStandardImplementation_Private_h__

#include "MulleObjCStandardImplementation.h"
#include "MulleObjCAllocation.h"
#include "MulleObjCProperty.h"

#import "NSAutoreleasePool.h"
#import "mulle-objc-universefoundationinfo-private.h"
#import "MulleObjCExceptionHandler-Private.h"


//
// Inline variants of the standard IMPs. These are the single source of truth.
// The non-inline functions in MulleObjCStandard.m just call these.
// Fast paths (e.g. +instance) call these directly for zero overhead.
//


//
// Debug helper: catches release/autorelease mistakes in single-threaded
// programs. Checks if autoreleaseCount >= retainCount.
//
#ifdef DEBUG
# ifndef MulleObjCStandard_Private_checkAutoreleaseRelease_defined__
# define MulleObjCStandard_Private_checkAutoreleaseRelease_defined__

__attribute__(( unused))
static void   _MulleObjCStandardCheckAutoreleaseRelease( id self)
{
   struct _mulle_objc_universe                 *universe;
   struct _mulle_objc_universefoundationinfo   *config;

   universe = _mulle_objc_object_get_universe( self);
   config   = _mulle_objc_universe_get_universefoundationinfo( universe);

   if( config->object.singlethreadautoreleasecheckerenabled)
   {
      NSUInteger   autoreleaseCount;
      NSUInteger   retainCount;

      autoreleaseCount = [NSAutoreleasePool mulleCountObject:self];
      retainCount      = [self retainCount];
      if( autoreleaseCount >= retainCount)
      {
         __mulle_objc_universe_raise_internalinconsistency( universe,
               "object <%s %p> would be autoreleased too often",
                     MulleObjCInstanceGetClassNameUTF8String( self), self);
      }
   }
}
# endif
#else
static inline void   _MulleObjCStandardCheckAutoreleaseRelease( id self)
{
}
#endif


// family 1: +alloc
static inline id   _MulleObjCStandardAllocInline( id self, SEL sel, void *param)
{
   return( _MulleObjCClassAllocateInstance( self, 0));
}


// family 3: -init
static inline id   _MulleObjCStandardInitInline( id self, SEL sel, void *param)
{
   return( self);
}


// family 5: +new
static inline id   _MulleObjCStandardNewInline( id self, SEL sel, void *param)
{
   return( [_MulleObjCClassAllocateInstance( self, 0) init]);
}


// family 6: -autorelease
static inline id   _MulleObjCStandardAutoreleaseInline( id self, SEL sel, void *param)
{
   _MulleObjCStandardCheckAutoreleaseRelease( self);
   _MulleObjCAutoreleaseObject( self);
   return( self);
}


// family 7: -dealloc
static inline void   _MulleObjCStandardDeallocInline( id self, SEL sel)
{
#if DEBUG
   {
      struct _mulle_objc_universe                 *universe;
      struct _mulle_objc_universefoundationinfo   *config;

      universe = _mulle_objc_object_get_universe( self);
      config   = _mulle_objc_universe_get_universefoundationinfo( universe);

      if( config->object.singlethreadautoreleasecheckerenabled)
      {
         if( [NSAutoreleasePool mulleCountObject:self] )
            __mulle_objc_universe_raise_internalinconsistency( universe,
                           "deallocing object %p still in autoreleasepool", self);
      }
   }
#endif
   _MulleObjCInstanceFree( self);
}


// family 8: -finalize
static inline void   _MulleObjCStandardFinalizeInline( id self, SEL sel)
{
   _MulleObjCInstanceClearProperties( self, NO);
}


// family 9: -release
static inline void   _MulleObjCStandardReleaseInline( id self, SEL sel)
{
   _MulleObjCStandardCheckAutoreleaseRelease( self);

   // only place in mulle-objc where _mulle_objc_object_release_inline should
   // be called and not _mulle_objc_object_call_release
   _mulle_objc_object_release_inline( self);
}


// family 10: -retain
static inline id   _MulleObjCStandardRetainInline( id self, SEL sel, void *param)
{
   // only place in mulle-objc where _mulle_objc_object_retain_inline should
   // be called and not _mulle_objc_object_call_retain
   _mulle_objc_object_retain_inline( (struct _mulle_objc_object *) self);
   return( self);
}


// family 11: -retainCount
static inline NSUInteger   _MulleObjCStandardRetainCountInline( id self, SEL sel, void *param)
{
   return( (NSUInteger) _mulle_objc_object_get_retaincount_notps_noslow( self));
}


// family 12: -self
static inline id   _MulleObjCStandardSelfInline( id self, SEL sel, void *param)
{
   return( self);
}


#pragma mark - smart call inlines (check bitmask, fast path or dispatch)

//
// These check the standardimpmask and either inline the standard
// implementation or fall through to message dispatch. Use these in
// convenience constructors for automatic fast-path optimization.
//
// Read the mask once with MulleObjCClassGetStandardImplementationMask()
// and pass it to all calls.
//

static inline NSUInteger   MulleObjCClassGetStandardImplementationMask( Class cls)
{
   return( (NSUInteger) _mulle_objc_infraclass_get_standardimpmask( (struct _mulle_objc_infraclass *) cls));
}


static inline id   MulleObjCClassCallAllocInline( Class cls, NSUInteger mask)
{
   if( mask & (1 << _mulle_objc_methodfamily_alloc))
      return( _MulleObjCStandardAllocInline( (id) cls, 0, NULL));
   return( [(id) cls alloc]);
}


static inline id   MulleObjCInstanceCallInitInline( id self, NSUInteger mask)
{
   if( mask & (1 << _mulle_objc_methodfamily_init))
   {
      if( ! self)
         return( nil);
      return( _MulleObjCStandardInitInline( self, 0, NULL));
   }
   return( [self init]);
}


static inline id   MulleObjCInstanceCallAutoreleaseInline( id self, NSUInteger mask)
{
   if( mask & (1 << _mulle_objc_methodfamily_autorelease))
   {
      if( ! self)
         return( nil);
      return( _MulleObjCStandardAutoreleaseInline( self, 0, NULL));
   }
   return( [self autorelease]);
}

#endif

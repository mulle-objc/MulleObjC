//
//  NSAutoreleasePool.h
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
#ifndef MulleObjCAutoreleasePool_h__
#define MulleObjCAutoreleasePool_h__

#include "mulle-objc-threadfoundationinfo.h"


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-root-class"


static inline id   _MulleObjCAutoreleaseObject( id obj)
{
   struct _mulle_objc_poolconfiguration   *config;
   struct _mulle_objc_universe            *universe;

   universe = _mulle_objc_object_get_universe( obj);
   config   = mulle_objc_thread_get_poolconfiguration( universe);
   (*config->autoreleaseObject)( config, obj);
   return( obj);
}


static inline void
   _MulleObjCAutoreleaseObjects( id *objects,
                                 NSUInteger count,
                                 struct _mulle_objc_universe *universe)
{
   struct _mulle_objc_poolconfiguration   *config;

   config  = mulle_objc_thread_get_poolconfiguration( universe);
   (*config->autoreleaseObjects)( config, objects, count, sizeof( id));
}


static inline void
   _MulleObjCAutoreleaseSpacedObjects( id *objects,
                                       NSUInteger count,
                                       NSUInteger step,
                                       struct _mulle_objc_universe *universe)
{
   struct _mulle_objc_poolconfiguration   *config;

   config  = mulle_objc_thread_get_poolconfiguration( universe);
   (*config->autoreleaseObjects)( config, objects, count, step);
}


// for MulleObjCCorutine

MULLE_OBJC_GLOBAL
void   _mulle_objc_poolconfiguration_init( struct _mulle_objc_poolconfiguration *config, Class poolClass);

MULLE_OBJC_GLOBAL
void   _mulle_objc_poolconfiguration_reset( struct _mulle_objc_poolconfiguration *config);

MULLE_OBJC_GLOBAL
void   _mulle_objc_poolconfiguration_done( struct _mulle_objc_poolconfiguration *config);


// for NSThread
MULLE_OBJC_GLOBAL
void   mulle_objc_thread_new_poolconfiguration( struct _mulle_objc_universe *universe);

MULLE_OBJC_GLOBAL
void   mulle_objc_thread_reset_poolconfiguration( struct _mulle_objc_universe *universe);

MULLE_OBJC_GLOBAL
void   mulle_objc_thread_done_poolconfiguration( struct _mulle_objc_universe *universe);

// returns pointer as a convenience
MULLE_OBJC_GLOBAL
void   *MulleObjCAutoreleaseAllocation( void *pointer,
												    struct mulle_allocator *allocator);

#endif

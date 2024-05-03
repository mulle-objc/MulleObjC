//
//  ns_threadconfiguration.h
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

#ifndef mulle_objc_threadfoundationinfo__h__
#define mulle_objc_threadfoundationinfo__h__

#include "include.h"

#include "mulle-objc-type.h"
#include "MulleObjCIntegralType.h"


//
// MEMO: if we want to support coroutines, we need to switch the autorelease
//       pool around too. This would typically mean you'd switch the `tail`
//       and maybe `maxObjects` on a context switch. You'd probably drop the
//       object map debugging support. Each context would have its own
//       struct _mulle_objc_poolconfiguration, which would need to be
//       transferred into the execution thread for lookup.
//
struct _mulle_objc_poolconfiguration
{
   void   (*autoreleaseObject)( struct _mulle_objc_poolconfiguration *, id);
   void   (*autoreleaseObjects)( struct _mulle_objc_poolconfiguration *, id *, NSUInteger, NSUInteger);

   id                              tail;        // NSAutoreleasePool
   struct _mulle_objc_infraclass   *poolClass;


   void   *(*push)( struct _mulle_objc_poolconfiguration *);
   void   (*pop)( struct _mulle_objc_poolconfiguration *, id pool);

   int             releasing;
   // debugging support
   int             trace;
   unsigned int    maxObjects;  // coarse

   // used for debugging when MULLE_OBJC_AUTORELEASEPOOL_MAP is YES
   struct mulle_map                *object_map;
   struct mulle_map                _object_map;
};


struct _mulle_objc_threadfoundationinfo
{
   struct _mulle_objc_poolconfiguration   poolconfig;
   struct mulle_allocator                 *instance_allocator; // used with MULLE_OBJC_EMBEDDED_ALLOCATOR
};


static inline struct _mulle_objc_poolconfiguration *
   _mulle_objc_threadfoundationinfo_get_poolconfiguration( struct _mulle_objc_threadfoundationinfo *foundation)
{
   return( &foundation->poolconfig);
}


/*
 * Threadinfo interface
 */
MULLE_C_CONST_NONNULL_RETURN
static inline struct _mulle_objc_poolconfiguration *
   _mulle_objc_threadinfo_get_poolconfiguration( struct _mulle_objc_threadinfo *config)
{
   struct _mulle_objc_threadfoundationinfo   *foundation;

   foundation = _mulle_objc_threadinfo_get_foundationspace( config);
   return( &foundation->poolconfig);
}


/*
 * Universe interface
 */
MULLE_OBJC_GLOBAL
MULLE_C_CONST_NONNULL_RETURN
struct _mulle_objc_threadfoundationinfo *
   mulle_objc_thread_get_threadfoundationinfo( struct _mulle_objc_universe *universe);



static inline struct _mulle_objc_poolconfiguration *
   mulle_objc_thread_get_poolconfiguration( struct _mulle_objc_universe *universe)
{
   struct _mulle_objc_threadfoundationinfo   *foundation;

   foundation = mulle_objc_thread_get_threadfoundationinfo( universe);
   return( _mulle_objc_threadfoundationinfo_get_poolconfiguration( foundation));
}


static inline struct _mulle_objc_infraclass *
   _mulle_objc_thread_get_autoreleasepoolclass( struct _mulle_objc_universe *universe)
{
   struct _mulle_objc_poolconfiguration   *poolconfig;

   poolconfig = mulle_objc_thread_get_poolconfiguration( universe);
   return( poolconfig->poolClass);
}


#endif

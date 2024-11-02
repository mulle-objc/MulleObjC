//
//  MulleObjCIvar.m
//  MulleObjC
//
//  Copyright (c) 2024 Nat! - Mulle kybernetiK.
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
#import "import.h"

#include "mulle-objc-atomicid.h"


MULLE_OBJC_GLOBAL
int   _MulleObjCObjectSetIvar( id self, mulle_objc_ivarid_t ivarid, void *buf, size_t size);

MULLE_OBJC_GLOBAL
int   _MulleObjCObjectGetIvar( id self, mulle_objc_ivarid_t ivarid, void *buf, size_t size);


MULLE_OBJC_GLOBAL
id   MulleObjCObjectGetObjectIvar( id self, mulle_objc_ivarid_t ivarid);

MULLE_OBJC_GLOBAL
void   MulleObjCObjectSetObjectIvar( id self, mulle_objc_ivarid_t ivarid, id value);



// will not duplicate if *ivar == s
// Interface is kinda bad, because copy/pasting this to -dealloc makes me
// write:
//   MulleObjCInstanceDeallocateMemory( self, **&**_fontName); !! WRONG
// with the erroneus & before the _ivar
//
MULLE_OBJC_GLOBAL
void   MulleObjCObjectSetDuplicatedUTF8String( id self, char **ivar, char *s);


//
// MulleObjC : value added code for mulle_atomic_id_t
//             the lazy loader will call `lazyLoader` on `obj` to provide
//             the value if needed.
//
// lazyLoaderReturnType:
//     _C_ASSIGN_ID    returns autoreleased
//     _C_COPY_ID      returns a copy (not autoreleased)
//     _C_RETAIN_ID    returns already retained
//
MULLE_OBJC_GLOBAL
id   _MulleObjCAtomicIdGetLazy( mulle_atomic_id_t *ivar,
                                char ivarType,
                                id obj,
                                SEL lazyLoader,
                                char lazyLoaderReturnType);


static inline id   MulleObjCAtomicIdGetLazy( mulle_atomic_id_t *ivar,
                                             id obj,
                                             SEL lazyLoader)
{
   if( ! ivar)
      return( nil);

   return( _MulleObjCAtomicIdGetLazy( ivar,
                                      _C_RETAIN_ID,
                                      obj,
                                      lazyLoader,
                                      _C_ASSIGN_ID));
}



static inline id   MulleObjCAtomicIdGetLazyRetain( mulle_atomic_id_t *ivar,
                                                   id obj,
                                                   SEL lazyLoader)
{
   return( MulleObjCAtomicIdGetLazy( ivar, obj, lazyLoader));
}



static inline id   MulleObjCAtomicIdGetLazyCopy( mulle_atomic_id_t *ivar,
                                                 id obj,
                                                 SEL lazyLoader)
{
   if( ! ivar)
      return( nil);

   return( _MulleObjCAtomicIdGetLazy( ivar,
                                      _C_COPY_ID,
                                      obj,
                                      lazyLoader,
                                      _C_ASSIGN_ID));
}

static inline id   MulleObjCAtomicIdGetLazyAssign( mulle_atomic_id_t *ivar,
                                                   id obj,
                                                   SEL lazyLoader)
{
   if( ! ivar)
      return( nil);

   return( _MulleObjCAtomicIdGetLazy( ivar,
                                      _C_ASSIGN_ID,
                                      obj,
                                      lazyLoader,
                                      _C_ASSIGN_ID));
}



static inline id   MulleObjCAtomicIdGet( mulle_atomic_id_t *ivar)
{
   if( ! ivar)
      return( nil);

   return( _mulle_atomic_id_get( ivar));
}


static inline void   MulleObjCAtomicIdSet( mulle_atomic_id_t *ivar,
                                           id value)
{
   if( ivar)
      _mulle_atomic_id_update( ivar, _C_RETAIN_ID, value);
}


static inline void   MulleObjCAtomicIdSetRetain( mulle_atomic_id_t *ivar,
                                                 id value)
{
   if( ivar)
      _mulle_atomic_id_update( ivar, _C_RETAIN_ID, value);
}


static inline void   MulleObjCAtomicIdSetCopy( mulle_atomic_id_t *ivar,
                                               id value)
{
   if( ivar)
      _mulle_atomic_id_update( ivar, _C_COPY_ID, value);
}


static inline void   MulleObjCAtomicIdSetAssign( mulle_atomic_id_t *ivar,
                                                 id value)
{
   if( ivar)
      _mulle_atomic_id_update( ivar, _C_ASSIGN_ID, value);
}


static inline void   MulleObjCAtomicIdRelease( mulle_atomic_id_t *ivar)
{
   if( ivar)
      _mulle_atomic_id_release( ivar);
}

//
//  mulle-objc-atomicid.h
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
#ifndef mulle_objc_atomicid_h__
#define mulle_objc_atomicid_h__

#include "mulle-objc-type.h"

#include "include.h" // Needed for MULLE_OBJC_GLOBAL

#include <mulle-thread/mulle-thread.h>


//
// mulle_atomic_id_t 
// 
// This is useful for atomic instance variables (say f.e. delegate which is
// accessed by multiple threads)
//

union _mulle_objc_atomicid_t
{
   id                       object;      // dont read, except when debugging
   mulle_atomic_pointer_t   pointer;
};

typedef union _mulle_objc_atomicid_t   mulle_atomic_id_t;


// ivarType:
//     _C_ASSIGN_ID    for an ivar/property that is assign only (its a bug don't do this)
//     _C_COPY_ID      for an ivar/property that stores a copy
//     _C_RETAIN_ID    the default ivar stores the value retained
//


static inline id   _mulle_atomic_id_get( mulle_atomic_id_t *ivar)
{
   id   value;

   value = (id) _mulle_atomic_pointer_read( &ivar->pointer);
   return( value);
}


MULLE_OBJC_GLOBAL
id   _mulle_atomic_id_update( mulle_atomic_id_t *ivar,
                              char ivarType,
                              id value);

static inline void   _mulle_atomic_id_set( mulle_atomic_id_t *ivar,
                                           char ivarType,
                                           id value)
{
   (void) _mulle_atomic_id_update( ivar, ivarType, value);
}


MULLE_OBJC_GLOBAL
void   _mulle_atomic_id_release( mulle_atomic_id_t *ivar);



#endif

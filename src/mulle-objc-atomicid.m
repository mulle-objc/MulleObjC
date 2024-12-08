//
//  mulle-objc-atomicid.c
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

#import "mulle-objc-atomicid.h"

#import "import-private.h"

// MEMO: need this to get declarations for _call_ functions
//#include <mulle-objc-runtime/mulle-objc-builtin.h>



//
// mulle_atomic_id_t 
// 
// MEMO: must be compiled with mulle-objc compiler so we get proper TAO
//       definitions for C calls

id   _mulle_atomic_id_update( mulle_atomic_id_t *ivar,
                              char ivarType,
                              id value)
{
   id   old;

   if( ivarType == _C_COPY_ID)
      value = mulle_objc_object_call_copy( value);
   else
      if( ivarType == _C_RETAIN_ID)
         value = mulle_objc_object_call_retain( value);

   // MEMO: need to document why this is rereading pointer in the loop
   //       and not just once outside the loop and then using previous.
   //       from __cas. I benchmarked just using "cas" with a random value
   //       for retrieval, but a failing CAS is markedly worse.
   for(;;)
   {
      old = (id) _mulle_atomic_pointer_read( &ivar->pointer);

      // can't cas with same value
      if( old == value)
         return( old);

      if( _mulle_atomic_pointer_cas( &ivar->pointer, value, old))
      {
         if( ivarType != _C_ASSIGN_ID)
            old = mulle_objc_object_call_autorelease( old);
         return( old);
      }
   }
}


void   _mulle_atomic_id_release( mulle_atomic_id_t *ivar)
{
   id   value;

   for(;;)
   {
      value = (id) _mulle_atomic_pointer_read( &ivar->pointer);
      if( ! value)
         return;

      if( _mulle_atomic_pointer_cas( &ivar->pointer, NULL, value))
      {
         mulle_objc_object_call_release( value);
         return;
      }
   }
}


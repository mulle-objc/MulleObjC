//
//  MulleObjCIntegralType.h
//  MulleObjC
//
//  Copyright (c) 2018 Nat! - Mulle kybernetiK.
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
#ifndef MulleObjCIntegralType__h__
#define MulleObjCIntegralType__h__

#include <mulle-c11/mulle-c11-bool.h>
#include <mulle-c11/mulle-c11-integer.h>
#include <mulle-thread/mulle-thread.h>

typedef enum
{
   NSOrderedAscending = -1,
   NSOrderedSame       = 0,
   NSOrderedDescending = 1
} NSComparisonResult;


static inline char   *_NSComparisonResultUTF8String( NSComparisonResult result)
{
   return( result < 0 ? "<" : (result > 0 ? ">" : "="));
}



union _NSUIntegerAtomic
{
   NSUInteger               value;      // dont read, except when debugging
   mulle_atomic_pointer_t   pointer;
};

typedef union _NSUIntegerAtomic   NSUIntegerAtomic;


// ivarType:
//     _C_ASSIGN_ID    for an ivar/property that is assign only (its a bug don't do this)
//     _C_COPY_ID      for an ivar/property that stores a copy
//     _C_RETAIN_ID    the default ivar stores the value retained
//


static inline NSUInteger   NSUIntegerAtomicGet( NSUIntegerAtomic *ivar)
{
   NSUInteger   value;

   value = (NSUInteger) _mulle_atomic_pointer_read( &ivar->pointer);
   return( value);
}


static inline NSUInteger   NSUIntegerAtomicUpdate( NSUIntegerAtomic *ivar,
                                                   NSUInteger value)

{
   NSUInteger   old;

   for(;;)
   {
      old = (NSUInteger) _mulle_atomic_pointer_read( &ivar->pointer);

      // can't cas with same value
      if( old == value)
         return( old);

      if( _mulle_atomic_pointer_cas( &ivar->pointer, (void *) value, (void *) old))
      {
         return( old);
      }
   }
}


static inline NSUInteger   NSUIntegerAtomicMaskedOr( NSUIntegerAtomic *ivar,
                                                     NSUInteger mask,
                                                     NSUInteger bits)

{
   NSUInteger   old;
   NSUInteger   value;

   for(;;)
   {
      old   = (NSUInteger) _mulle_atomic_pointer_read( &ivar->pointer);
      value = (old & mask) | bits;

      // can't cas with same value
      if( old == value)
         return( old);

      if( _mulle_atomic_pointer_cas( &ivar->pointer, (void *) value, (void *) old))
      {
         return( old);
      }
   }
}


static inline NSUInteger   NSUIntegerAtomicOr( NSUIntegerAtomic *ivar,
                                               NSUInteger bits)

{
   NSUInteger   old;
   NSUInteger   value;

   for(;;)
   {
      old   = (NSUInteger) _mulle_atomic_pointer_read( &ivar->pointer);
      value = old | bits;

      // can't cas with same value
      if( old == value)
         return( old);

      if( _mulle_atomic_pointer_cas( &ivar->pointer, (void *) value, (void *) old))
      {
         return( old);
      }
   }
}


static inline void   NSUIntegerAtomicSet( NSUIntegerAtomic *ivar,
                                          NSUInteger value)
{
   (void) NSUIntegerAtomicUpdate( ivar, value);
}



union _NSIntegerAtomic
{
   NSInteger               value;      // dont read, except when debugging
   mulle_atomic_pointer_t   pointer;
};

typedef union _NSIntegerAtomic   NSIntegerAtomic;


// ivarType:
//     _C_ASSIGN_ID    for an ivar/property that is assign only (its a bug don't do this)
//     _C_COPY_ID      for an ivar/property that stores a copy
//     _C_RETAIN_ID    the default ivar stores the value retained
//


static inline NSInteger   NSIntegerAtomicGet( NSIntegerAtomic *ivar)
{
   NSInteger   value;

   value = (NSInteger) _mulle_atomic_pointer_read( &ivar->pointer);
   return( value);
}


static inline NSInteger   NSIntegerAtomicUpdate( NSIntegerAtomic *ivar,
                                                 NSInteger value)

{
   NSInteger   old;

   for(;;)
   {
      old = (NSInteger) _mulle_atomic_pointer_read( &ivar->pointer);

      // can't cas with same value
      if( old == value)
         return( old);

      if( _mulle_atomic_pointer_cas( &ivar->pointer, (void *) value, (void *) old))
      {
         return( old);
      }
   }
}


static inline void   NSIntegerAtomicSet( NSIntegerAtomic *ivar,
                                         NSInteger value)
{
   (void) NSIntegerAtomicUpdate( ivar, value);
}


#endif /* ns_int_type_h */

//
//  ns_int_type.h
//  MulleObjC
//
//  Created by Nat! on 29.03.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
//

// This should be includeable by C and not require linkage with MulleObjC

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

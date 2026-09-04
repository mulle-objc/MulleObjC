//
//  NSByteOrder.h
//  MulleObjC
//
//  Copyright (c) 2018 Nat! - Mulle kybernetiK.
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
// This header should be includeable by C and must not require inclusion
// or link of the runtime

#ifndef ns_byteorder_h__
#define ns_byteorder_h__

#include "MulleObjCIntegralType.h"
#include <stdint.h>
#include <mulle-c11/mulle-c11-endian.h>
#include <mulle-c11/mulle-c11-swap.h>


enum MulleObjCByteOrder
{
   NS_UnknownByteOrder,
   NS_LittleEndian,        // little end first (Intel)
   NS_BigEndian            // big end first (Power)
};


static inline long   NSHostByteOrder(void)
{
#if __BIG_ENDIAN__
   return( NS_BigEndian);
#else
   return( NS_LittleEndian);
#endif
}



static inline uint16_t   MulleObjCSwapUInt16( uint16_t value)
{
   return( mulle_swap_uint16( value));
}


static inline uint32_t   MulleObjCSwapUInt32( uint32_t value)
{
   return( mulle_swap_uint32( value));
}


static inline unsigned short   NSSwapShort( unsigned short value)
{
   return( mulle_swap_uint16( value));
}


static inline unsigned int   NSSwapInt( unsigned int value)
{
   return( mulle_swap_uint32( value));
}


static inline unsigned long long   NSSwapLongLong( unsigned long long value)
{
   return( mulle_swap_uint64( value));
}


static inline unsigned long   NSSwapLong( unsigned long value)
{
#if __LP64__
   return( mulle_swap_uint64( value));
#else
   return( mulle_swap_uint32( value));
#endif
}


static inline void   NSSwap10Bytes( unsigned char bytes[ 10])
{
   mulle_swap_10bytes( bytes);
}


static inline unsigned short   NSSwapBigShortToHost( unsigned short value)
{
   return( mulle_big_uint16_to_host( value));
}


static inline unsigned int   NSSwapBigIntToHost( unsigned int value)
{
   return( mulle_big_uint32_to_host( value));
}


static inline unsigned long   NSSwapBigLongToHost( unsigned long value)
{
#if __LP64__
   return( mulle_big_uint64_to_host( value));
#else
   return( mulle_big_uint32_to_host( value));
#endif
}


static inline unsigned long long   NSSwapBigLongLongToHost( unsigned long long value)
{
   return( mulle_big_uint64_to_host( value));
}


static inline unsigned short   NSSwapHostShortToBig( unsigned short value)
{
   return( mulle_host_uint16_to_big( value));
}


static inline unsigned int   NSSwapHostIntToBig( unsigned int value)
{
   return( mulle_host_uint32_to_big( value));
}


static inline unsigned long   NSSwapHostLongToBig( unsigned long value)
{
#if __LP64__
   return( mulle_host_uint64_to_big( value));
#else
   return( mulle_host_uint32_to_big( value));
#endif
}


static inline unsigned long long   NSSwapHostLongLongToBig( unsigned long long value)
{
   return( mulle_host_uint64_to_big( value));
}


static inline unsigned short   NSSwapLittleShortToHost( unsigned short value)
{
   return( mulle_little_uint16_to_host( value));
}


static inline unsigned int   NSSwapLittleIntToHost( unsigned int value)
{
   return( mulle_little_uint32_to_host( value));
}


static inline unsigned long   NSSwapLittleLongToHost( unsigned long value)
{
#if __LP64__
   return( mulle_little_uint64_to_host( value));
#else
   return( mulle_little_uint32_to_host( value));
#endif
}


static inline unsigned long long   NSSwapLittleLongLongToHost( unsigned long long value)
{
   return( mulle_little_uint64_to_host( value));
}


static inline unsigned short   NSSwapHostShortToLittle( unsigned short value)
{
   return( mulle_host_uint16_to_little( value));
}


static inline unsigned int   NSSwapHostIntToLittle( unsigned int value)
{
   return( mulle_host_uint32_to_little( value));
}


static inline unsigned long   NSSwapHostLongToLittle( unsigned long value)
{
#if __LP64__
   return( mulle_host_uint64_to_little( value));
#else
   return( mulle_host_uint32_to_little( value));
#endif
}


static inline unsigned long long   NSSwapHostLongLongToLittle( unsigned long long value)
{
   return( mulle_host_uint64_to_little( value));
}



typedef mulle_swapped_float        NSSwappedFloat;
typedef mulle_swapped_double       NSSwappedDouble;
typedef mulle_swapped_long_double  NSSwappedLongDouble;


static inline NSSwappedFloat   NSConvertHostFloatToSwapped( float value)
{
   return( mulle_host_float_to_swapped( value));
}


static inline float   NSConvertSwappedFloatToHost( NSSwappedFloat value)
{
   return( mulle_swapped_float_to_host( value));
}


static inline NSSwappedDouble   NSConvertHostDoubleToSwapped( double value)
{
   return( mulle_host_double_to_swapped( value));
}


static inline double   NSConvertSwappedDoubleToHost( NSSwappedDouble value)
{
   return( mulle_swapped_double_to_host( value));
}


static inline NSSwappedLongDouble   NSConvertHostLongDoubleToSwapped( long double value)
{
   return( mulle_host_long_double_to_swapped( value));
}


static inline long double   NSConvertSwappedLongDoubleToHost( NSSwappedLongDouble value)
{
   return( mulle_swapped_long_double_to_host( value));
}


#pragma mark - legacy floating point operations

static inline NSSwappedFloat   NSSwapFloat( NSSwappedFloat value)
{
   return( mulle_swap_float( value));
}


static inline NSSwappedDouble   NSSwapDouble( NSSwappedDouble value)
{
   return( mulle_swap_double( value));
}


static inline NSSwappedLongDouble   NSSwapLongDouble( NSSwappedLongDouble value)
{
   return( mulle_swap_long_double( value));
}


static inline float   NSSwapBigFloatToHost( NSSwappedFloat value)
{
   return( mulle_big_float_to_host( value));
}


static inline double   NSSwapBigDoubleToHost( NSSwappedDouble value)
{
   return( mulle_big_double_to_host( value));
}


static inline long double   NSSwapBigLongDoubleToHost( NSSwappedLongDouble value)
{
   return( mulle_big_long_double_to_host( value));
}


static inline NSSwappedFloat   NSSwapHostFloatToBig( float value)
{
   return( mulle_host_float_to_big( value));
}


static inline NSSwappedDouble   NSSwapHostDoubleToBig( double value)
{
   return( mulle_host_double_to_big( value));
}


static inline NSSwappedLongDouble   NSSwapHostLongDoubleToBig( long double value)
{
   return( mulle_host_long_double_to_big( value));
}


static inline float   NSSwapLittleFloatToHost( NSSwappedFloat value)
{
   return( mulle_little_float_to_host( value));
}


static inline double   NSSwapLittleDoubleToHost( NSSwappedDouble value)
{
   return( mulle_little_double_to_host( value));
}


static inline long double   NSSwapLittleLongDoubleToHost( NSSwappedLongDouble value)
{
   return( mulle_little_long_double_to_host( value));
}


static inline NSSwappedFloat   NSSwapHostFloatToLittle( float value)
{
   return( mulle_host_float_to_little( value));
}


static inline NSSwappedDouble   NSSwapHostDoubleToLittle( double value)
{
   return( mulle_host_double_to_little( value));
}


static inline NSSwappedLongDouble   NSSwapHostLongDoubleToLittle( long double value)
{
   return( mulle_host_long_double_to_little( value));
}


#endif

//
//  MulleObjCException.h
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

#import "NSObject.h"

#import "NSRange.h"
// base your exception subclass on this


@protocol MulleObjCException

@optional  // MulleObjCException implements this for you
           // Tip: Never mark an ObjC method (like: f.e. -raise) with `__attribute__(( noreturn))
           // Because of self == nil, it's wrong.
- (void) raise;
- (char *) UTF8String;

@end

@class MulleObjCException; // needed for the compiler to understand this is
                           // protocol class



/*
 * All these functions vector through the foundation data of the compiled
 * for universe. In a usual configuration the
 * MulleObjCStandardFoundation-startup or derived Foundation-startup will have
 * installed NSException generating code in the functions vectors of the
 * universe. So in the end this code will create and raise an NSException in
 * MulleObjCStandardFoundation.
 */
#define MulleObjCThrowInvalidArgumentException( ...) \
   _MulleObjCThrowInvalidArgumentException( __MULLE_OBJC_UNIVERSEID__, __VA_ARGS__)

#define MulleObjCThrowInvalidIndexException( index) \
   _MulleObjCThrowInvalidIndexException( __MULLE_OBJC_UNIVERSEID__, (index))

#define MulleObjCThrowInternalInconsistencyException( ...) \
   _MulleObjCThrowInternalInconsistencyException( __MULLE_OBJC_UNIVERSEID__, __VA_ARGS__)

#define MulleObjCThrowErrnoException( ...) \
   _MulleObjCThrowErrnoException( __MULLE_OBJC_UNIVERSEID__, __VA_ARGS__)

#define MulleObjCThrowInvalidRangeException( range) \
   _MulleObjCThrowInvalidRangeException( __MULLE_OBJC_UNIVERSEID__, (range))


MULLE_OBJC_GLOBAL
MULLE_C_NO_RETURN
void   _MulleObjCThrowInvalidIndexException( mulle_objc_universeid_t universeid,
                                             NSUInteger index);

MULLE_OBJC_GLOBAL
MULLE_C_NO_RETURN
void   _MulleObjCThrowInvalidRangeException( mulle_objc_universeid_t universeid,
                                             NSRange range);

MULLE_OBJC_GLOBAL
MULLE_C_NO_RETURN
void   _MulleObjCThrowInvalidArgumentException( mulle_objc_universeid_t universeid,
                                                id format, ...);

MULLE_OBJC_GLOBAL
MULLE_C_NO_RETURN
void   _MulleObjCThrowInternalInconsistencyException( mulle_objc_universeid_t universeid,
                                                      id format, ...);

MULLE_OBJC_GLOBAL
MULLE_C_NO_RETURN
void   _MulleObjCThrowErrnoException( mulle_objc_universeid_t universeid,
                                      id format, ...);


/*
 * C String interface
 */
#define MulleObjCThrowErrnoExceptionUTF8String( ...) \
   _MulleObjCThrowErrnoExceptionUTF8String( __MULLE_OBJC_UNIVERSEID__, __VA_ARGS__)

#define MulleObjCThrowInternalInconsistencyExceptionUTF8String( ...) \
   _MulleObjCThrowInternalInconsistencyExceptionUTF8String( __MULLE_OBJC_UNIVERSEID__, __VA_ARGS__)

#define MulleObjCThrowInvalidArgumentExceptionUTF8String( ...) \
   _MulleObjCThrowInvalidArgumentExceptionUTF8String( __MULLE_OBJC_UNIVERSEID__, __VA_ARGS__)


MULLE_OBJC_GLOBAL
MULLE_C_NO_RETURN
void   _MulleObjCThrowInvalidArgumentExceptionUTF8String( mulle_objc_universeid_t universeid,
                                                          char *format, ...);
MULLE_OBJC_GLOBAL
MULLE_C_NO_RETURN
void   _MulleObjCThrowInternalInconsistencyExceptionUTF8String( mulle_objc_universeid_t universeid,
                                                                char *format, ...);
MULLE_OBJC_GLOBAL
MULLE_C_NO_RETURN
void   _MulleObjCThrowErrnoExceptionUTF8String( mulle_objc_universeid_t universeid,
                                                char *format, ...);



static inline NSRange   MulleObjCValidateRangeAgainstLength( NSRange range,
                                                             NSUInteger length)
{
   NSUInteger  end;

   //
   // specialty, if length == -1, it means "full" range
   // this speeds up these cases, where you want to specify full range
   // but need to call -length first to create the range, and then
   // later call -length again to validate the range...
   //
   if( range.length == -1)
      range = NSRangeMake( range.location, length - range.location);

   //
   // assume NSUInteger is 8 bit, then we need to check for also for a
   // negative length/location value making things difficult { 3, 255 }
   //
   end = _mulle_range_get_max( range);
   if( end > length || end < range.location)
      MulleObjCThrowInvalidRangeException( range);

   return( range);
}



static inline NSRange   MulleObjCAdjustRangeForLength( NSRange range,
                                                       NSUInteger length)
{
   NSUInteger  end;

   //
   // specialty, if length == -1, it means "full" range
   // this speeds up these cases, where you want to specify full range
   // but need to call -length first to create the range, and then
   // later call -length again to validate the range...
   //
   if( range.length == -1)
      range = NSRangeMake( range.location, length - range.location);

   //
   // assume NSUInteger is 8 bit, then we need to check for also for a
   // negative length/location value making things difficult { 3, 255 }
   //
   end = _mulle_range_get_max( range);
   if( end > length || end < range.location)
      range.length = 0;

   return( range);
}


//
// When casting from id or some other base class to "cls", this code will
// assert that the class is as intended. When not running with asserts this
// code will evaporate within the compiler
//
// e.g.
// - (void) callback:(id) userInfo
// {
//    NSString *s = MULLE_OBJC_CLASS_CAST( NSString, userInfo);
// }
//
static inline id  _MULLE_OBJC_CLASS_CAST( Class cls, id x)
{
   assert( ! x || [x isKindOfClass:cls]);
   return( x);
}

#define MULLE_OBJC_CLASS_CAST( className, x)  \
   (className *) _MULLE_OBJC_CLASS_CAST( [className class], (x))

static inline id  _MULLE_OBJC_CLASS_CAST_OR_NIL( Class cls, id x)
{
   return( [x isKindOfClass:cls] ? x : nil);
}

#define MULLE_OBJC_CLASS_CAST_OR_NIL( className, x)  \
   (className *) _MULLE_OBJC_CLASS_CAST_OR_NIL( [className class], (x))


static inline id  _MULLE_OBJC_CLASS_CAST_NON_NIL( Class cls, id x)
{
   assert( [x isKindOfClass:cls]);
   return( x);
}

#define MULLE_OBJC_CLASS_CAST_NON_NIL( className, x)  \
   (className *) _MULLE_OBJC_CLASS_CAST_NON_NIL( [className class], (x))


//
// You can do the same for a protocol, not sure how useful this is though
// Probably it would be necessary to do multiple protocol conformance tests
//
static inline id  _MULLE_OBJC_PROTOCOL_CAST( PROTOCOL protocolName, id x)
{
   assert( ! x || [x conformsToProtocol:protocolName]);
   return( x);
}

// as receiver may have multiple protocols, just cast to id for now
#define MULLE_OBJC_PROTOCOL_CAST( protocolName, x)  \
   (id) _MULLE_OBJC_PROTOCOL_CAST( @protocol( protocolName), (x))



static inline id  _MULLE_OBJC_PROTOCOL_CAST_OR_NIL( PROTOCOL protocolName, id x)
{
   return( [x conformsToProtocol:protocolName] ? x : nil);
}

// as receiver may have multiple protocols, just cast to id for now
#define MULLE_OBJC_PROTOCOL_CAST_OR_NIL( protocolName, x)  \
   (id) _MULLE_OBJC_PROTOCOL_CAST_OR_NIL( @protocol( protocolName), (x))



static inline id  _MULLE_OBJC_PROTOCOL_CAST_NON_NIL( PROTOCOL protocolName, id x)
{
   assert( [x conformsToProtocol:protocolName]);
   return( x);
}

// as receiver may have multiple protocols, just cast to id for now
#define MULLE_OBJC_PROTOCOL_CAST_NON_NIL( protocolName, x)  \
   (id) _MULLE_OBJC_PROTOCOL_CAST_NON_NIL( @protocol( protocolName), (x))


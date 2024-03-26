//
//  NSMethodSignature.h
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
#import "NSObject.h"

#import "MulleObjCProtocol.h"
#import "NSCopying.h"


typedef enum
{
   MulleObjCMetaABITypeVoid           = 0,
   MulleObjCMetaABITypeVoidPointer    = 1,
   MulleObjCMetaABITypeParameterBlock = 2
} MulleObjCMetaABIType;


typedef struct mulle_objc_typeinfo    MulleObjCMethodSignatureTypeInfo;


@interface NSMethodSignature : NSObject < MulleObjCImmutableProtocols, NSCopying>
{
   uint32_t                            _bits;    // see method_descriptor
   uint16_t                            _count;
   uint16_t                            _extra;
   char                                *_types;
   MulleObjCMethodSignatureTypeInfo    *_infos;
   // careful when adding stuff below !! (#X#)
}

+ (NSMethodSignature *) signatureWithObjCTypes:(char *) types;

//
// this does not call init, for performance reasons. It's used by the
// forwarding mechanism
//
+ (NSMethodSignature *) _signatureWithObjCTypes:(char *) types
                                 descriptorBits:(NSUInteger) bits;

- (BOOL) isOneway;
- (BOOL) isVariadic;
- (NSUInteger) _descriptorBits;
- (NSUInteger) frameLength;

- (NSUInteger) methodReturnLength;
- (char *) methodReturnType;
// this uses the argument index, so 0 is self
- (char *) getArgumentTypeAtIndex:(NSUInteger) index;

- (NSUInteger) numberOfArguments;

// mulle additions

- (NSUInteger) mulleInvocationSize;  // actual extra bytes to allocate for NSInvocation

// trhere is no difference!
- (MulleObjCMetaABIType) _methodMetaABIReturnType;
- (MulleObjCMetaABIType) _methodMetaABIParameterType;

// This uses the internal index: use 0 to get rval, 1 for self etc.
- (MulleObjCMethodSignatureTypeInfo *) mulleSignatureTypeInfoAtIndex:(NSUInteger) i;

@end

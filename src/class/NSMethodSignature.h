//
//  NSMethodSignature.h
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
#import "NSObject.h"

#import "MulleObjCProtocol.h"
#import "NSCopying.h"


typedef enum
{
   // Values match the 2-bit fields stored in method descriptor bits 22-23
   // (rType) and 24-25 (pType).  VoidPointer=0 is the default (bits cleared),
   // which covers the most common case: id-returning methods.
   MulleObjCMetaABITypeVoidPointer    = 0,
   MulleObjCMetaABITypeVoid           = 1,
   MulleObjCMetaABITypeParameterBlock = 2
} MulleObjCMetaABIType;


// Combined callType = rType | (pType << 2).
// Low 2 bits = rType, bits 3-2 = pType.
typedef enum
{
   // pType = VoidPointer (0): single pointer-sized argument
   MulleObjCMetaABICallVoidPtrVoidPtr = 0,   // (0<<2)|0  -(id)foo:(id) — DEFAULT
   MulleObjCMetaABICallVoidPtrVoid    = 1,   // (0<<2)|1  -(void)foo:(id)
   MulleObjCMetaABICallVoidPtrBlock   = 2,   // (0<<2)|2  -(struct S)foo:(id)
   // pType = Void (1): no arguments
   MulleObjCMetaABICallVoidVoidPtr    = 4,   // (1<<2)|0  -(id)foo
   MulleObjCMetaABICallVoidVoid       = 5,   // (1<<2)|1  -(void)foo
   MulleObjCMetaABICallVoidBlock      = 6,   // (1<<2)|2  -(struct S)foo
   // pType = ParameterBlock (2): multiple/struct arguments
   MulleObjCMetaABICallBlockVoidPtr   = 8,   // (2<<2)|0  -(id)foo:(int)x ...
   MulleObjCMetaABICallBlockVoid      = 9,   // (2<<2)|1  -(void)foo:(int)x ...
   MulleObjCMetaABICallBlockBlock     = 10,  // (2<<2)|2  -(struct S)foo:(int)x ...
} MulleObjCMetaABICallType;


typedef struct mulle_methodsignature_arginfo    MulleObjCMethodSignatureTypeInfo;


// Slot index used in staticinstanceclass[] for NSMethodSignature static instances.
// Slots 0-2 are reserved for NSConstantString variants.
#define MULLE_OBJC_STATICINSTANCE_METHODSIGNATURE_INDEX  4

// C struct for a static NSMethodSignature instance.
// The mulle-objc object model stores the objectheader (containing isa)
// BEFORE the ivar area, so the "object pointer" is &instance._ivars, not
// &instance itself.
//
// Usage:
//   static struct _NSConstantMethodSignature  my_sig = MULLE_OBJC_CONSTANTMETHODSIGNATURE( "v@:", 3);
//   struct _mulle_objc_object *obj = MULLE_OBJC_CONSTANTMETHODSIGNATURE_OBJECT( &my_sig);
//   _mulle_objc_universe_add_staticinstance( universe, obj);

struct _NSConstantMethodSignature
{
   struct _mulle_objc_objectheader   _header;   // isa = MULLE_OBJC_STATICINSTANCE_METHODSIGNATURE_INDEX
   // NSMethodSignature ivars — the "object pointer" points here:
   uint32_t                         _bits;     // see method_descriptor; bits 22-23=rType, 24-25=pType. no others valid
   uint16_t                         _count;    // mulle_objc_signature_count_typeinfos( _types)
   uint16_t                         _extra;    // 0 — _types points to an external string, no inline extra memory
   char                             *_types;
   uint32_t                         _invocationSize; // precomputed mulleInvocationSize
   uint32_t                         _reserved;
   MulleObjCMethodSignatureTypeInfo _infos[3]; // compiler emits inline arginfos here (count >= 3 always)
};

// The ObjC object pointer for a static method signature (points past the header).
#define MULLE_OBJC_CONSTANTMETHODSIGNATURE_OBJECT( p)  \
   ((struct _mulle_objc_object *) &(p)->_bits)


//
// You can't SUBCLASS - NSMethodSignature. As you can't any properties or ivars
// currently, so only a category makes sense.
//
@interface NSMethodSignature : NSObject < MulleObjCImmutableProtocols, NSCopying>
{
   uint32_t                            _bits;    // see method_descriptor; bits 22-23=rType, 24-25=pType. no others valid
   uint16_t                            _count;
   uint16_t                            _extra;
   char                                *_types;
   uint32_t                            _invocationSize;
   uint32_t                            _reserved;
   MulleObjCMethodSignatureTypeInfo    _infos[3]; // inline for minimum (rval,self,_cmd); overflow in extra bytes
   // (#X#) extra bytes follow: [(count-3 overflow arginfos)] [types string (for dynamic instances)]
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

// there is no difference!
- (MulleObjCMetaABIType) _methodMetaABIReturnType;
- (MulleObjCMetaABIType) _methodMetaABIParameterType;


// the expected size of a call to a method
- (NSUInteger) mulleMetaABIFrameLength;

// This uses the internal index: use 0 to get rval, 1 for self etc.
- (MulleObjCMethodSignatureTypeInfo *) mulleSignatureTypeInfoAtIndex:(NSUInteger) i;

@end

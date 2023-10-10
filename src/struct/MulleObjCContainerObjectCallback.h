//
//  MulleObjCContainerCallback.h
//  MulleObjCStandardFoundation
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

//
// This is a hybrid. The header is C, but the actual implementation is
// in ObjC
//
#ifndef mulle_objc_container_callback_h__
#define mulle_objc_container_callback_h__

#include "include.h"

//
// these are "const" to make them reside possibly in
// writeprotected storage, which can be convenient for
// catching accidental writes into them
//
MULLE_OBJC_GLOBAL
const struct mulle_container_keyvaluecallback   _MulleObjCContainerKeyCopiedCStringValueRetainCallback;

MULLE_OBJC_GLOBAL
const struct mulle_container_keyvaluecallback   _MulleObjCContainerKeyRetainValueRetainCallback;
MULLE_OBJC_GLOBAL
const struct mulle_container_keyvaluecallback   _MulleObjCContainerKeyCopyValueRetainCallback;

// NSDictionary uses this for init sometimes
MULLE_OBJC_GLOBAL
const struct mulle_container_keyvaluecallback   _MulleObjCContainerKeyAssignValueAssignCallback;
// NSDictionary usually uses this
MULLE_OBJC_GLOBAL
const struct mulle_container_keyvaluecallback   _MulleObjCContainerKeyRetainValueCopyCallback;
MULLE_OBJC_GLOBAL
const struct mulle_container_keyvaluecallback   _MulleObjCContainerKeyCopyValueCopyCallback;

// i was too lazy to multiply it out, do it if needed
MULLE_OBJC_GLOBAL
const struct mulle_container_keycallback      _MulleObjCContainerKeyAssignCallback;
MULLE_OBJC_GLOBAL
const struct mulle_container_valuecallback    _MulleObjCContainerValueAssignCallback;

MULLE_OBJC_GLOBAL
const struct mulle_container_keycallback      _MulleObjCContainerKeyRetainPointerCompareCallback;

MULLE_OBJC_GLOBAL
 struct mulle_container_keycallback     *MulleObjCContainerKeyRetainCallback;
// NSSet usually uses this
MULLE_OBJC_GLOBAL
 struct mulle_container_keycallback     *MulleObjCContainerKeyCopyCallback;
MULLE_OBJC_GLOBAL
 struct mulle_container_valuecallback   *MulleObjCContainerValueRetainCallback;
MULLE_OBJC_GLOBAL
 struct mulle_container_valuecallback   *MulleObjCContainerValueCopyCallback;

// TODO: use these and kill code in MuleObjCStandardFoundation
// #define NSIntMapKeyCallBacks                   mulle_container_keycallback_int
// #define NSIntegerMapKeyCallBacks               mulle_container_keycallback_intptr
// #define NSNonOwnedPointerMapKeyCallBacks       mulle_container_keycallback_nonowned_pointer
// #define NSNonOwnedPointerOrNullMapKeyCallBacks mulle_container_keycallback_nonowned_pointer_or_null
// #define NSOwnedPointerMapKeyCallBacks          mulle_container_keycallback_owned_pointer
// 
// #define NSIntMapValueCallBacks                 mulle_container_valuecallback_int
// #define NSIntegerMapValueCallBacks             mulle_container_valuecallback_intptr
// #define NSNonOwnedPointerMapValueCallBacks     mulle_container_valuecallback_nonowned_pointer
// #define NSOwnedPointerMapValueCallBacks        mulle_container_valuecallback_owned_pointer

#define NSObjectMapKeyCallBacks                *MulleObjCContainerKeyCopyCallback
#define NSObjectMapValueCallBacks              *MulleObjCContainerValueRetainCallback
#define NSNonRetainedObjectMapKeyCallBacks     _MulleObjCContainerKeyAssignCallback
#define NSNonRetainedObjectMapValueCallBacks   _MulleObjCContainerValueAssignCallback

//MULLE_OBJC_CONTAINER_FOUNDATION_EXTERN_GLOBAL
//NSHashTableCallBacks   MulleObjCNonRetainedObjectHashCallBacks;
//
//MULLE_OBJC_CONTAINER_FOUNDATION_EXTERN_GLOBAL
//NSHashTableCallBacks   MulleObjCObjectHashCallBacks;
//
//MULLE_OBJC_CONTAINER_FOUNDATION_EXTERN_GLOBAL
//NSHashTableCallBacks   MulleObjCOwnedObjectIdentityHashCallBacks;



MULLE_OBJC_GLOBAL
uintptr_t
   mulle_container_keycallback_object_hash( struct mulle_container_keycallback *callback,
                                            void *obj);
MULLE_OBJC_GLOBAL
int
   mulle_container_keycallback_object_is_equal( struct mulle_container_keycallback *callback,
                                                void *obj,
                                                void *other);
// these will be casted anyway, so the signature can be wrong :)
MULLE_OBJC_GLOBAL
void   *
   mulle_container_callback_object_assign( void *callback,
                                           id obj,
                                           struct mulle_allocator *allocator);
MULLE_OBJC_GLOBAL
void   *
   mulle_container_callback_object_retain( void *callback,
                                           id obj,
                                           struct mulle_allocator *allocator);
MULLE_OBJC_GLOBAL
void   *
   mulle_container_callback_object_copy( void *callback,
                                         id obj,
                                         struct mulle_allocator *allocator);
MULLE_OBJC_GLOBAL
void
   mulle_container_callback_object_autorelease( void *callback,
                                                id obj,
                                                struct mulle_allocator *allocator);

// p_allocator is **! will be zeroed out
MULLE_OBJC_GLOBAL
char *
   mulle_container_callback_object_describe( void *callback,
                                             id obj,
                                             struct mulle_allocator **p_allocator);


// some mulle additions
MULLE_OBJC_GLOBAL
const struct mulle_container_keycallback   MulleNonOwnedCStringMapKeyCallBacks;

MULLE_OBJC_GLOBAL
const struct mulle_container_keycallback   MulleOwnedCStringMapKeyCallBacks;

MULLE_OBJC_GLOBAL
const struct mulle_container_keycallback   MulleCopiedCStringMapKeyCallBacks;

MULLE_OBJC_GLOBAL
const struct mulle_container_valuecallback   MulleNonOwnedCStringMapValueCallBacks;

MULLE_OBJC_GLOBAL
const struct mulle_container_valuecallback   MulleOwnedCStringMapValueCallBacks;

// struct mulle_container_valuecallback   MulleCopiedCStringMapValueCallBacks;

#endif

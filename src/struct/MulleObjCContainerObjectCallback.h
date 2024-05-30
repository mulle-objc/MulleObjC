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


// GLOSSARY:
//
//  | Adverb               | Key Type | On Insert | On Removal     | Comparison
//  |----------------------|----------|-----------|----------------|--------------
//  | Assign               | object   | nop       | nop            | `-isEqual`
//  | AssignRetained       | object   | nop       | `-autorelease` | `-isEqual`
//  | AssignCString        | cstring  | nop       | nop            | `strcmp`
//  | CopyCString          | cstring  | `strdup`  | `free`         | `strcmp`
//  | Copy                 | object   | `-copy`   | `-autorelease` | `-isEqual`
//  | FreeCString          | cstring  | nop       | `free`         | `strcmp`
//  | Integer              | void *   | nop       | nop            | `==`
//  | Retain               | object   | `-retain` | `-autorelease` | `-isEqual`
//  | RetainPointerCompare | object   | `-retain` | `-autorelease` | `==`
//
// these are "const" to make them reside possibly in writeprotected storage,
// which might be convenient for catching accidental writes into them.
//
MULLE_OBJC_GLOBAL
const struct mulle_container_keyvaluecallback   _MulleObjCContainerCopyCStringKeyRetainValueCallback;

MULLE_OBJC_GLOBAL
const struct mulle_container_keyvaluecallback   _MulleObjCContainerRetainKeyRetainValueCallback;
MULLE_OBJC_GLOBAL
const struct mulle_container_keyvaluecallback   _MulleObjCContainerCopyKeyRetainValueCallback;

MULLE_OBJC_GLOBAL
const struct mulle_container_keyvaluecallback   _MulleObjCContainerIntegerKeyRetainValueCallback;

// NSDictionary uses this for archiving sometimes, its dangerous!
MULLE_OBJC_GLOBAL
const struct mulle_container_keyvaluecallback   _MulleObjCContainerAssignRetainedKeyAssignRetainedValueCallback;
// NSDictionary usually uses this
MULLE_OBJC_GLOBAL
const struct mulle_container_keyvaluecallback   _MulleObjCContainerRetainKeyCopyValueCallback;
MULLE_OBJC_GLOBAL
const struct mulle_container_keyvaluecallback   _MulleObjCContainerCopyKeyCopyValueCallback;

// i was too lazy to multiply it out, do it if needed,
MULLE_OBJC_GLOBAL
const struct mulle_container_keycallback        _MulleObjCContainerAssignKeyCallback;
MULLE_OBJC_GLOBAL  
const struct mulle_container_keycallback        _MulleObjCContainerAssignRetainedKeyCallback;

MULLE_OBJC_GLOBAL
const struct mulle_container_keycallback        _MulleObjCContainerRetainPointerCompareKeyCallback;


#define _MulleObjCContainerAssignCStringKeyCallback    mulle_container_keycallback_nonowned_cstring
#define _MulleObjCContainerFreeCStringKeyCallback      mulle_container_keycallback_owned_cstring
#define _MulleObjCContainerCopyCStringKeyCallback      mulle_container_keycallback_copied_cstring


MULLE_OBJC_GLOBAL
const struct mulle_container_valuecallback    _MulleObjCContainerAssignValueCallback;
MULLE_OBJC_GLOBAL
const struct mulle_container_valuecallback    _MulleObjCContainerAssignRetainedValueCallback;


#define _MulleObjCContainerAssignCStringValueCallback    mulle_container_valuecallback_nonowned_cstring
#define _MulleObjCContainerFreeCStringValueCallback      mulle_container_valuecallback_owned_cstring
#define _MulleObjCContainerCopyCStringValueCallback      mulle_container_valuecallback_copied_cstring


#define MulleObjCContainerRetainKeyCallback    (*(struct mulle_container_keycallback *) &_MulleObjCContainerRetainKeyRetainValueCallback.keycallback)
#define MulleObjCContainerCopyKeyCallback      (*(struct mulle_container_keycallback *) &_MulleObjCContainerCopyKeyCopyValueCallback.keycallback)
#define MulleObjCContainerRetainValueCallback  (*(struct mulle_container_valuecallback *) &_MulleObjCContainerRetainKeyRetainValueCallback.valuecallback)
#define MulleObjCContainerCopyValueCallback    (*(struct mulle_container_valuecallback *) &_MulleObjCContainerCopyKeyCopyValueCallback.valuecallback)



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


// // some mulle additions
// MULLE_OBJC_GLOBAL
// const struct mulle_container_keycallback     _MulleNonOwnedCStringMapKeyCallBacks;
// 
// MULLE_OBJC_GLOBAL
// const struct mulle_container_keycallback     _MulleOwnedCStringMapKeyCallBacks;
// 
// MULLE_OBJC_GLOBAL
// const struct mulle_container_keycallback     _MulleCopiedCStringMapKeyCallBacks;
// 
// MULLE_OBJC_GLOBAL
// const struct mulle_container_valuecallback   _MulleNonOwnedCStringMapValueCallBacks;
// 
// MULLE_OBJC_GLOBAL
// const struct mulle_container_valuecallback   _MulleOwnedCStringMapValueCallBacks;
// 
// // struct mulle_container_valuecallback   MulleCopiedCStringMapValueCallBacks;



MULLE_OBJC_GLOBAL
const struct mulle_container_keyvaluecallback   _MulleObjCContainerPointerKeyIntegerValueCallback;

MULLE_OBJC_GLOBAL
const struct mulle_container_keyvaluecallback   _MulleObjCContainerIntegerKeyPointerValueCallback;

MULLE_OBJC_GLOBAL
const struct mulle_container_keyvaluecallback   _MulleObjCContainerPointerKeyAssignValueCallback;

#endif

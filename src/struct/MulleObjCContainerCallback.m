//
//  MulleObjCContainerCallback.m
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
#import "mulle-objc.h"


#import "import-private.h"

#import "mulle-objc-universeconfiguration-private.h"
#import "mulle-objc-universefoundationinfo-private.h"

#import "NSObjectProtocol.h"
#import "NSCopying.h"
#import "NSAutoreleasePool.h"


#pragma mark -
#pragma mark Int



struct mulle_container_keycallback      NSIntMapKeyCallBacks =
{
   mulle_container_keycallback_pointer_hash,
   mulle_container_keycallback_pointer_is_equal,
   mulle_container_keycallback_self,
   mulle_container_keycallback_nop,
   (mulle_container_keycallback_describe_t *) mulle_container_callback_int_describe,
   NSNotAnIntMapKey,
   NULL
};

struct mulle_container_keycallback      NSIntegerMapKeyCallBacks =
{
   mulle_container_keycallback_pointer_hash,
   mulle_container_keycallback_pointer_is_equal,
   mulle_container_keycallback_self,
   mulle_container_keycallback_nop,
   (mulle_container_keycallback_describe_t *)  mulle_container_callback_intptr_describe,
   NSNotAnIntegerMapKey,
   NULL
};


static uintptr_t   mulle_objc_keycallback_no_hash( struct mulle_container_keycallback *callback, void *p)
{
   return( (uintptr_t) p);
}


struct mulle_container_keycallback      MulleSELMapKeyCallBacks =
{
   mulle_objc_keycallback_no_hash,
   mulle_container_keycallback_pointer_is_equal,
   mulle_container_keycallback_self,
   mulle_container_keycallback_nop,
   (mulle_container_keycallback_describe_t *)  mulle_container_callback_intptr_describe,
   NSNotAnIntegerMapKey,
   NULL
};



struct mulle_container_valuecallback    NSIntMapValueCallBacks =
{
   mulle_container_valuecallback_self,
   mulle_container_valuecallback_nop,
   mulle_container_callback_int_describe,
   NULL
};



struct mulle_container_valuecallback    NSIntegerMapValueCallBacks =
{
   mulle_container_valuecallback_self,
   mulle_container_valuecallback_nop,
   mulle_container_callback_intptr_describe,
   NULL
};


#pragma mark -
#pragma mark Pointer

struct mulle_container_keycallback   NSNonOwnedPointerMapKeyCallBacks =
{
   mulle_container_keycallback_pointer_hash,
   mulle_container_keycallback_pointer_is_equal,
   mulle_container_keycallback_self,
   mulle_container_keycallback_nop,
   (mulle_container_keycallback_describe_t *) mulle_container_callback_pointer_describe,
   NULL,
   NULL
};


struct mulle_container_keycallback   NSNonOwnedPointerOrNullMapKeyCallBacks =
{
   mulle_container_keycallback_pointer_hash,
   mulle_container_keycallback_pointer_is_equal,
   mulle_container_keycallback_self,
   mulle_container_keycallback_nop,
   (mulle_container_keycallback_describe_t *) mulle_container_callback_pointer_describe,
   NSNotAPointerMapKey,
   NULL
};


struct mulle_container_keycallback   NSOwnedPointerMapKeyCallBacks =
{
   mulle_container_keycallback_pointer_hash,
   mulle_container_keycallback_pointer_is_equal,
   mulle_container_keycallback_self,
   _mulle_container_keycallback_pointer_free,
   (mulle_container_keycallback_describe_t *) mulle_container_callback_pointer_describe,
   NULL,
   NULL
};


struct mulle_container_valuecallback   NSNonOwnedPointerMapValueCallBacks =
{
   mulle_container_valuecallback_self,
   mulle_container_valuecallback_nop,
   mulle_container_callback_pointer_describe,
   NULL
};



struct mulle_container_valuecallback   NSOwnedPointerMapValueCallBacks =
{
   mulle_container_valuecallback_self,
   mulle_container_valuecallback_pointer_free,
   mulle_container_callback_pointer_describe,
   NULL
};


struct mulle_container_valuecallback   MulleSELMapValueCallBacks =
{
   mulle_container_valuecallback_self,
   mulle_container_valuecallback_nop,
   mulle_container_callback_pointer_describe,
   NULL
};



// use mulle-container instead ?
// #pragma mark -
// #pragma mark CString
//
// static char   *
//    mulle_container_callback_cstring_describe( struct mulle_container_valuecallback *callback,
//                                               void *p,
//                                               struct mulle_allocator **p_allocator)
// {
//    return( p);
// }
//
//
// const struct mulle_container_keycallback   MulleNonOwnedCStringMapKeyCallBacks =
// {
//    mulle_container_keycallback_cstring_hash,
//    mulle_container_keycallback_cstring_is_equal,
//    mulle_container_keycallback_self,
//    mulle_container_keycallback_nop,
//    (mulle_container_keycallback_describe_t *) mulle_container_callback_cstring_describe,
//    NULL,
//    NULL
// };
//
//
// const struct mulle_container_keycallback   MulleOwnedCStringMapKeyCallBacks =
// {
//    mulle_container_keycallback_cstring_hash,
//    mulle_container_keycallback_cstring_is_equal,
//    mulle_container_keycallback_self,
//    mulle_container_keycallback_pointer_free,
//    (mulle_container_keycallback_describe_t *) mulle_container_callback_cstring_describe,
//    NULL,
//    NULL
// };
//
//
// const struct mulle_container_keycallback   MulleCopiedCStringMapKeyCallBacks =
// {
//    mulle_container_keycallback_cstring_hash,
//    mulle_container_keycallback_cstring_is_equal,
//    mulle_container_keycallback_cstring_strdup,
//    mulle_container_keycallback_pointer_free,
//    (mulle_container_keycallback_describe_t *) mulle_container_callback_cstring_describe,
//    NULL,
//    NULL
// };
//
//
//
// const struct mulle_container_valuecallback   MulleNonOwnedCStringMapValueCallBacks =
// {
//    mulle_container_valuecallback_self,
//    mulle_container_valuecallback_nop,
//    mulle_container_callback_cstring_describe,
//    NULL
// };
//
//
// const struct mulle_container_valuecallback   MulleOwnedCStringMapValueCallBacks =
// {
//    mulle_container_valuecallback_self,
//    mulle_container_valuecallback_pointer_free,
//    mulle_container_callback_cstring_describe,
//    NULL
// };
//
//
// const struct mulle_container_valuecallback   MulleCopiedCStringMapValueCallBacks =
// {
//    mulle_container_keycallback_cstring_strdup,
//    mulle_container_valuecallback_pointer_free,
//    mulle_container_callback_cstring_describe,
//    NULL
// };
//


#pragma mark -
#pragma mark Object


uintptr_t
	mulle_container_keycallback_object_hash( struct mulle_container_keycallback *callback,
														  id obj)
{
   return( (uintptr_t) [obj hash]);
}


int
	mulle_container_keycallback_object_is_equal( struct mulle_container_keycallback *callback,
																id obj,
																id other)
{
   return( [obj isEqual:other]);
}



void   *
   mulle_container_callback_object_assign( void *callback,
                                           id obj,
                                           struct mulle_allocator *allocator)
{
   return( obj);
}


void   *
	mulle_container_callback_object_retain( void *callback,
													    id obj,
													    struct mulle_allocator *allocator)
{
   return( [obj retain]);
}


void   *
	mulle_container_callback_object_copy( void *callback,
													  id obj,
													  struct mulle_allocator *allocator)
{
   return( [obj copy]);
}


void
	mulle_container_callback_object_autorelease( void *callback,
															   id obj,
															   struct mulle_allocator *allocator)
{
   [obj autorelease];
}


char *
	mulle_container_callback_object_describe( void *callback,
															id obj,
															struct mulle_allocator **p_allocator)
{
   *p_allocator = NULL;
   return( mulle_objc_object_call( obj, @selector( cStringDescription), obj));
}



const struct mulle_container_keycallback
	_MulleObjCContainerKeyAssignCallback =
{
   (uintptr_t (*)()) mulle_container_keycallback_object_hash,
   (int (*)()) mulle_container_keycallback_object_is_equal,
   mulle_container_keycallback_self,
   mulle_container_keycallback_nop,
   (mulle_container_keycallback_describe_t *) mulle_container_callback_object_describe,

   nil,
   NULL
};


const struct mulle_container_keycallback
   _MulleObjCContainerKeyRetainPointerCompareCallback =
{
   mulle_container_keycallback_pointer_hash,
   mulle_container_keycallback_pointer_is_equal,
   (void *(*)()) mulle_container_callback_object_retain,
   (void (*)())  mulle_container_callback_object_autorelease,
   (mulle_container_keycallback_describe_t *) mulle_container_callback_object_describe,

   nil,
   NULL
};



const struct mulle_container_valuecallback
	_MulleObjCContainerValueAssignCallback =
{
   mulle_container_valuecallback_self,
   mulle_container_valuecallback_nop,
   (mulle_container_valuecallback_describe_t *) mulle_container_callback_object_describe,
   NULL
};


const struct mulle_container_keyvaluecallback
	_MulleObjCContainerKeyRetainValueRetainCallback =
{
   {
      (uintptr_t (*)()) mulle_container_keycallback_object_hash,
      (int (*)())   mulle_container_keycallback_object_is_equal,
      (void *(*)()) mulle_container_callback_object_retain,
      (void (*)())  mulle_container_callback_object_autorelease,
      (mulle_container_keycallback_describe_t *) mulle_container_callback_object_describe,

      nil,
      NULL
   },
   {
      (void *(*)()) mulle_container_callback_object_retain,
      (void (*)())  mulle_container_callback_object_autorelease,
      (mulle_container_valuecallback_describe_t *) mulle_container_callback_object_describe,
      NULL
   }
};


const  struct mulle_container_keyvaluecallback
	_MulleObjCContainerKeyCopyValueRetainCallback =
{
   {
      (uintptr_t (*)()) mulle_container_keycallback_object_hash,
      (int (*)())       mulle_container_keycallback_object_is_equal,
      (void *(*)())     mulle_container_callback_object_copy,
      (void (*)())      mulle_container_callback_object_autorelease,
      (mulle_container_keycallback_describe_t *)  mulle_container_callback_object_describe,

      nil,
      NULL
   },
   {
      (void *(*)()) mulle_container_callback_object_retain,
      (void (*)())  mulle_container_callback_object_autorelease,
      (mulle_container_valuecallback_describe_t *) mulle_container_callback_object_describe,
      NULL
   }
};

const  struct mulle_container_keyvaluecallback
	_MulleObjCContainerKeyRetainValueCopyCallback =
{
   {
      (uintptr_t (*)()) mulle_container_keycallback_object_hash,
      (int (*)())       mulle_container_keycallback_object_is_equal,
      (void *(*)())     mulle_container_callback_object_retain,
      (void (*)())      mulle_container_callback_object_autorelease,
      (mulle_container_keycallback_describe_t *) mulle_container_callback_object_describe,
      nil,
      NULL
   },
   {
      (void *(*)()) mulle_container_callback_object_copy,
      (void (*)())  mulle_container_callback_object_autorelease,
      (mulle_container_valuecallback_describe_t *) mulle_container_callback_object_describe,
      NULL
   }
};

const  struct mulle_container_keyvaluecallback
	_MulleObjCContainerKeyCopyValueCopyCallback =
{
   {
      (uintptr_t (*)()) mulle_container_keycallback_object_hash,
      (int (*)())       mulle_container_keycallback_object_is_equal,
      (void *(*)())     mulle_container_callback_object_copy,
      (void (*)())      mulle_container_callback_object_autorelease,
      (mulle_container_keycallback_describe_t *)     mulle_container_callback_object_describe,

      nil,
      NULL
   },
   {
      (void *(*)()) mulle_container_callback_object_copy,
      (void (*)())  mulle_container_callback_object_autorelease,
      (mulle_container_valuecallback_describe_t *) mulle_container_callback_object_describe,
      NULL
   }
};


// these still autorelease though
const  struct mulle_container_keyvaluecallback
   _MulleObjCContainerKeyAssignValueAssignCallback =
{
   {
      (uintptr_t (*)()) mulle_container_keycallback_object_hash,
      (int (*)())       mulle_container_keycallback_object_is_equal,
      (void *(*)())     mulle_container_callback_object_assign,
      (void (*)())      mulle_container_callback_object_autorelease,
      (mulle_container_keycallback_describe_t *)     mulle_container_callback_object_describe,

      nil,
      NULL
   },
   {
      (void *(*)()) mulle_container_callback_object_assign,
      (void (*)())  mulle_container_callback_object_autorelease,
      (mulle_container_valuecallback_describe_t *) mulle_container_callback_object_describe,
      NULL
   }
};


//extern struct mulle_container_keyvaluecallback   MulleObjCContainerKeyRetainValueCopyCallback;
//extern struct mulle_container_keyvaluecallback   MulleObjCContainerKeyCopyValueRetainCallback;
//extern struct mulle_container_keyvaluecallback   MulleObjCContainerKeyCopyValueCopyCallback;
//extern struct mulle_container_keyvaluecallback   MulleObjCContainerKeyAssignValueAssignCallback;

//extern struct mulle_container_keycallback     *MulleObjCContainerKeyRetainCallback;
//extern struct mulle_container_keycallback     *MulleObjCContainerKeyCopyCallback;
//extern struct mulle_container_valuecallback   *MulleObjCContainerValueRetainCallback;
//extern struct mulle_container_valuecallback   *MulleObjCContainerValueCopyCallback;

struct mulle_container_keycallback *
	MulleObjCContainerKeyRetainCallback    = (void *) &_MulleObjCContainerKeyRetainValueRetainCallback.keycallback;
struct mulle_container_valuecallback *
	MulleObjCContainerValueRetainCallback  = (void *) &_MulleObjCContainerKeyRetainValueRetainCallback.valuecallback;

struct mulle_container_keycallback *
	MulleObjCContainerKeyCopyCallback    = (void *) &_MulleObjCContainerKeyCopyValueCopyCallback.keycallback;
struct mulle_container_valuecallback *
	MulleObjCContainerValueCopyCallback  = (void *) &_MulleObjCContainerKeyCopyValueCopyCallback.valuecallback;

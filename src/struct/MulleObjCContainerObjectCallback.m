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
#import "MulleObjCContainerObjectCallback.h"

#import "import-private.h"

#import "NSObjectProtocol.h"
#import "NSCopying.h"


#pragma mark - Object


uintptr_t
	mulle_container_keycallback_object_hash( struct mulle_container_keycallback *callback,
														  void * obj)
{
   return( (uintptr_t) [(id) obj hash]);
}


int
	mulle_container_keycallback_object_is_equal( struct mulle_container_keycallback *callback,
																void *obj,
																void *other)
{
   return( [(id) obj isEqual:(id) other]);
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


//
// UTF8String is a bet on the future
// 
char *
   mulle_container_callback_object_describe( void *callback,
                                             id obj,
                                             struct mulle_allocator **p_allocator)
{
   *p_allocator = NULL;
   return( mulle_objc_object_call( obj, @selector( UTF8String), obj));
}



const struct mulle_container_keycallback
	_MulleObjCContainerKeyAssignCallback =
{
   (mulle_container_keycallback_hash_t *) mulle_container_keycallback_object_hash,
   (mulle_container_keycallback_is_equal_t *) mulle_container_keycallback_object_is_equal,
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
   (mulle_container_keycallback_retain_t *) mulle_container_callback_object_retain,
   (mulle_container_keycallback_release_t *) mulle_container_callback_object_autorelease,
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
   _MulleObjCContainerKeyCopiedCStringValueRetainCallback =
{
   {
      .hash     = mulle_container_keycallback_cstring_hash,
      .is_equal = mulle_container_keycallback_cstring_is_equal,
      .retain   = (void *(*)()) mulle_container_callback_cstring_copy,
      .release  = _mulle_container_keycallback_pointer_free,
      .describe = (mulle_container_keycallback_describe_t *) mulle_container_callback_cstring_describe,
      .notakey  = NULL,
      .userinfo = NULL
   },
   {
      (mulle_container_valuecallback_retain_t *)  mulle_container_callback_object_retain,
      (mulle_container_valuecallback_release_t *) mulle_container_callback_object_autorelease,
      (mulle_container_valuecallback_describe_t *) mulle_container_callback_object_describe,
      NULL
   }
};


const struct mulle_container_keyvaluecallback
	_MulleObjCContainerKeyRetainValueRetainCallback =
{
   {
      (mulle_container_keycallback_hash_t *)     mulle_container_keycallback_object_hash,
      (mulle_container_keycallback_is_equal_t *) mulle_container_keycallback_object_is_equal,
      (mulle_container_keycallback_retain_t *)   mulle_container_callback_object_retain,
      (mulle_container_keycallback_release_t *)  mulle_container_callback_object_autorelease,
      (mulle_container_keycallback_describe_t *) mulle_container_callback_object_describe,

      nil,
      NULL
   },
   {
      (mulle_container_valuecallback_retain_t *)  mulle_container_callback_object_retain,
      (mulle_container_valuecallback_release_t *) mulle_container_callback_object_autorelease,
      (mulle_container_valuecallback_describe_t *) mulle_container_callback_object_describe,
      NULL
   }
};


const  struct mulle_container_keyvaluecallback
	_MulleObjCContainerKeyCopyValueRetainCallback =
{
   {
      (mulle_container_keycallback_hash_t *)     mulle_container_keycallback_object_hash,
      (mulle_container_keycallback_is_equal_t *) mulle_container_keycallback_object_is_equal,
      (mulle_container_keycallback_retain_t *)   mulle_container_callback_object_copy,
      (mulle_container_keycallback_release_t *)  mulle_container_callback_object_autorelease,
      (mulle_container_keycallback_describe_t *) mulle_container_callback_object_describe,

      nil,
      NULL
   },
   {
      (mulle_container_valuecallback_retain_t *)  mulle_container_callback_object_retain,
      (mulle_container_valuecallback_release_t *) mulle_container_callback_object_autorelease,
      (mulle_container_valuecallback_describe_t *) mulle_container_callback_object_describe,
      NULL
   }
};

const  struct mulle_container_keyvaluecallback
	_MulleObjCContainerKeyRetainValueCopyCallback =
{
   {
      (mulle_container_keycallback_hash_t *)     mulle_container_keycallback_object_hash,
      (mulle_container_keycallback_is_equal_t *) mulle_container_keycallback_object_is_equal,
      (mulle_container_keycallback_retain_t *)   mulle_container_callback_object_retain,
      (mulle_container_keycallback_release_t *)  mulle_container_callback_object_autorelease,
      (mulle_container_keycallback_describe_t *) mulle_container_callback_object_describe,
      nil,
      NULL
   },
   {
      (mulle_container_valuecallback_retain_t *)  mulle_container_callback_object_copy,
      (mulle_container_valuecallback_release_t *) mulle_container_callback_object_autorelease,
      (mulle_container_valuecallback_describe_t *) mulle_container_callback_object_describe,
      NULL
   }
};

const  struct mulle_container_keyvaluecallback
	_MulleObjCContainerKeyCopyValueCopyCallback =
{
   {
      (mulle_container_keycallback_hash_t *)      mulle_container_keycallback_object_hash,
      (mulle_container_keycallback_is_equal_t *)  mulle_container_keycallback_object_is_equal,
      (mulle_container_keycallback_retain_t *)    mulle_container_callback_object_copy,
      (mulle_container_keycallback_release_t *)   mulle_container_callback_object_autorelease,
      (mulle_container_keycallback_describe_t *)  mulle_container_callback_object_describe,

      nil,
      NULL
   },
   {
      (mulle_container_valuecallback_retain_t *)   mulle_container_callback_object_copy,
      (mulle_container_valuecallback_release_t *)  mulle_container_callback_object_autorelease,
      (mulle_container_valuecallback_describe_t *) mulle_container_callback_object_describe,
      NULL
   }
};


// these still autorelease though
const  struct mulle_container_keyvaluecallback
   _MulleObjCContainerKeyAssignValueAssignCallback =
{
   {
      (mulle_container_keycallback_hash_t *)     mulle_container_keycallback_object_hash,
      (mulle_container_keycallback_is_equal_t *) mulle_container_keycallback_object_is_equal,
      (mulle_container_keycallback_retain_t *)   mulle_container_callback_object_assign,
      (mulle_container_keycallback_release_t *)  mulle_container_callback_object_autorelease,
      (mulle_container_keycallback_describe_t *) mulle_container_callback_object_describe,

      nil,
      NULL
   },
   {
      (mulle_container_valuecallback_retain_t *)   mulle_container_callback_object_assign,
      (mulle_container_valuecallback_release_t *)  mulle_container_callback_object_autorelease,
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

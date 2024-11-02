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


#define INTEGER_KEY_CALLBACK                                                                               \
   {                                                                                                       \
      .hash     = mulle_container_keycallback_pointer_hash,                                                \
      .is_equal = mulle_container_keycallback_intptr_is_equal,                                             \
      .retain   = mulle_container_keycallback_self,                                                        \
      .release  = mulle_container_keycallback_nop,                                                         \
      .describe = (mulle_container_keycallback_describe_t *) mulle_container_callback_intptr_describe,     \
      .notakey  = mulle_not_an_intptr,                                                                     \
      .userinfo = NULL                                                                                     \
   }


#define POINTER_KEY_CALLBACK                                                                               \
   {                                                                                                       \
      .hash     = mulle_container_keycallback_pointer_hash,                                                \
      .is_equal = mulle_container_keycallback_pointer_is_equal,                                            \
      .retain   = mulle_container_keycallback_self,                                                        \
      .release  = mulle_container_keycallback_nop,                                                         \
      .describe = (mulle_container_keycallback_describe_t *) mulle_container_callback_pointer_describe,    \
      .notakey  = NULL,                                                                                    \
      .userinfo = NULL                                                                                     \
   }


#define COPIED_CSTRING_KEY_CALLBACK                                                                        \
  {                                                                                                        \
      .hash     = mulle_container_keycallback_cstring_hash,                                                \
      .is_equal = mulle_container_keycallback_cstring_is_equal,                                            \
      .retain   = (void *(*)()) mulle_container_callback_cstring_copy,                                     \
      .release  = _mulle_container_keycallback_pointer_free,                                               \
      .describe = (mulle_container_keycallback_describe_t *) mulle_container_callback_cstring_describe,    \
      .notakey  = NULL,                                                                                    \
      .userinfo = NULL                                                                                     \
   }

#define ASSIGN_KEY_CALLBACK                                                                                \
   {                                                                                                       \
      .hash     = (mulle_container_keycallback_hash_t *)     mulle_container_keycallback_object_hash,      \
      .is_equal = (mulle_container_keycallback_is_equal_t *) mulle_container_keycallback_object_is_equal,  \
      .retain   = (mulle_container_keycallback_retain_t *)   mulle_container_callback_object_assign,       \
      .release  = (mulle_container_keycallback_release_t *)  mulle_container_keycallback_nop,              \
      .describe = (mulle_container_keycallback_describe_t *) mulle_container_callback_object_describe,     \
      .notakey  = nil,                                                                                     \
      .userinfo = NULL                                                                                     \
   }


#define ASSIGN_RETAINED_KEY_CALLBACK                                                                       \
   {                                                                                                       \
      .hash     = (mulle_container_keycallback_hash_t *)     mulle_container_keycallback_object_hash,      \
      .is_equal = (mulle_container_keycallback_is_equal_t *) mulle_container_keycallback_object_is_equal,  \
      .retain   = (mulle_container_keycallback_retain_t *)   mulle_container_callback_object_assign,       \
      .release  = (mulle_container_keycallback_release_t *)  mulle_container_callback_object_autorelease,  \
      .describe = (mulle_container_keycallback_describe_t *) mulle_container_callback_object_describe,     \
      .notakey  = nil,                                                                                     \
      .userinfo = NULL                                                                                     \
   }

#define RETAIN_KEY_CALLBACK                                                                                \
   {                                                                                                       \
      .hash     = (mulle_container_keycallback_hash_t *)     mulle_container_keycallback_object_hash,      \
      .is_equal = (mulle_container_keycallback_is_equal_t *) mulle_container_keycallback_object_is_equal,  \
      .retain   = (mulle_container_keycallback_retain_t *)   mulle_container_callback_object_retain,       \
      .release  = (mulle_container_keycallback_release_t *)  mulle_container_callback_object_autorelease,  \
      .describe = (mulle_container_keycallback_describe_t *) mulle_container_callback_object_describe,     \
      .notakey  = nil,                                                                                     \
      .userinfo = NULL                                                                                     \
   }

#define COPY_KEY_CALLBACK                                                                                  \
   {                                                                                                       \
      .hash     = (mulle_container_keycallback_hash_t *)     mulle_container_keycallback_object_hash,      \
      .is_equal = (mulle_container_keycallback_is_equal_t *) mulle_container_keycallback_object_is_equal,  \
      .retain   = (mulle_container_keycallback_retain_t *)   mulle_container_callback_object_copy,         \
      .release  = (mulle_container_keycallback_release_t *)  mulle_container_callback_object_autorelease,  \
      .describe = (mulle_container_keycallback_describe_t *) mulle_container_callback_object_describe,     \
      .notakey  = nil,                                                                                     \
      .userinfo = NULL                                                                                     \
   }

#define RETAIN_POINTER_COMPARE_KEY_CALLBACK                                                                \
   {                                                                                                       \
      .hash     = (mulle_container_keycallback_hash_t *)     mulle_container_keycallback_pointer_hash,     \
      .is_equal = (mulle_container_keycallback_is_equal_t *) mulle_container_keycallback_pointer_is_equal, \
      .retain   = (mulle_container_keycallback_retain_t *)   mulle_container_callback_object_retain,       \
      .release  = (mulle_container_keycallback_release_t *)  mulle_container_callback_object_autorelease,  \
      .describe = (mulle_container_keycallback_describe_t *) mulle_container_callback_object_describe,     \
      .notakey  = nil,                                                                                     \
      .userinfo = NULL                                                                                     \
   }


#define INTEGER_VALUE_CALLBACK                                                                             \
   {                                                                                                       \
      .retain   = mulle_container_valuecallback_self,                                                      \
      .release  = (mulle_container_valuecallback_release_t *) mulle_container_keycallback_nop,             \
      .describe = (mulle_container_valuecallback_describe_t *) mulle_container_callback_intptr_describe,   \
      .userinfo = NULL                                                                                     \
   }


#define POINTER_VALUE_CALLBACK                                                                             \
   {                                                                                                       \
      .retain   = mulle_container_valuecallback_self,                                                      \
      .release  = (mulle_container_valuecallback_release_t *) mulle_container_keycallback_nop,             \
      .describe = (mulle_container_valuecallback_describe_t *) mulle_container_callback_pointer_describe,  \
      .userinfo = NULL                                                                                     \
   }


#define ASSIGN_VALUE_CALLBACK                                                                              \
   {                                                                                                       \
      .retain   = mulle_container_valuecallback_self,                                                      \
      .release  = (mulle_container_valuecallback_release_t *) mulle_container_keycallback_nop,             \
      .describe = (mulle_container_valuecallback_describe_t *) mulle_container_callback_object_describe,   \
      .userinfo = NULL                                                                                     \
   }

#define ASSIGN_RETAINED_VALUE_CALLBACK                                                                     \
   {                                                                                                       \
      .retain   = mulle_container_valuecallback_self,                                                      \
      .release  = (mulle_container_valuecallback_release_t *) mulle_container_callback_object_autorelease, \
      .describe = (mulle_container_valuecallback_describe_t *) mulle_container_callback_object_describe,   \
      .userinfo = NULL                                                                                     \
   }

#define RETAIN_VALUE_CALLBACK                                                                              \
   {                                                                                                       \
      .retain   = (mulle_container_valuecallback_retain_t *)  mulle_container_callback_object_retain,      \
      .release  = (mulle_container_valuecallback_release_t *) mulle_container_callback_object_autorelease, \
      .describe = (mulle_container_valuecallback_describe_t *) mulle_container_callback_object_describe,   \
      .userinfo = NULL                                                                                     \
   }

#define COPY_VALUE_CALLBACK                                                                                \
   {                                                                                                       \
      .retain   = (mulle_container_valuecallback_retain_t *)  mulle_container_callback_object_copy,        \
      .release  = (mulle_container_valuecallback_release_t *) mulle_container_callback_object_autorelease, \
      .describe = (mulle_container_valuecallback_describe_t *) mulle_container_callback_object_describe,   \
      .userinfo = NULL                                                                                     \
   }

#define COPIED_CSTRING_VALUE_CALLBACK                                                                      \
  {                                                                                                        \
      .retain   = (void *(*)()) mulle_container_callback_cstring_copy,                                     \
      .release  = mulle_container_valuecallback_pointer_free,                                              \
      .describe = (mulle_container_valuecallback_describe_t *) mulle_container_callback_cstring_describe,  \
      .userinfo = NULL                                                                                     \
   }


const struct mulle_container_keycallback
   _MulleObjCContainerAssignKeyCallback = ASSIGN_KEY_CALLBACK;

const struct mulle_container_keycallback
   _MulleObjCContainerAssignRetainedKeyCallback = ASSIGN_RETAINED_KEY_CALLBACK;

const struct mulle_container_keycallback
   _MulleObjCContainerRetainPointerCompareKeyCallback = RETAIN_POINTER_COMPARE_KEY_CALLBACK;


const struct mulle_container_valuecallback
   _MulleObjCContainerAssignValueCallback = ASSIGN_VALUE_CALLBACK;

const struct mulle_container_valuecallback
   _MulleObjCContainerAssignRetainedValueCallback = ASSIGN_RETAINED_VALUE_CALLBACK;



const struct mulle_container_keyvaluecallback
   _MulleObjCContainerIntegerKeyRetainValueCallback =
{
   INTEGER_KEY_CALLBACK,
   RETAIN_VALUE_CALLBACK
};



const struct mulle_container_keyvaluecallback
   _MulleObjCContainerAssignKeyRetainValueCallback =
{
   ASSIGN_KEY_CALLBACK,
   RETAIN_VALUE_CALLBACK
};


const struct mulle_container_keyvaluecallback
   _MulleObjCContainerAssignRetainedKeyRetainValueCallback =
{
   ASSIGN_RETAINED_KEY_CALLBACK,
   RETAIN_VALUE_CALLBACK
};


const struct mulle_container_keyvaluecallback
   _MulleObjCContainerCopyCStringKeyRetainValueCallback =
{
   COPIED_CSTRING_KEY_CALLBACK,
   RETAIN_VALUE_CALLBACK
};


const struct mulle_container_keyvaluecallback
	_MulleObjCContainerRetainKeyRetainValueCallback =
{
   RETAIN_KEY_CALLBACK,
   RETAIN_VALUE_CALLBACK
};


const struct mulle_container_keyvaluecallback
	_MulleObjCContainerCopyKeyRetainValueCallback =
{
   COPY_KEY_CALLBACK,
   RETAIN_VALUE_CALLBACK
};

const struct mulle_container_keyvaluecallback
	_MulleObjCContainerRetainKeyCopyValueCallback =
{
   RETAIN_KEY_CALLBACK,
   COPY_VALUE_CALLBACK
};

const struct mulle_container_keyvaluecallback
	_MulleObjCContainerCopyKeyCopyValueCallback =
{
   COPY_KEY_CALLBACK,
   COPY_VALUE_CALLBACK
};


// these still autorelease though
const struct mulle_container_keyvaluecallback
   _MulleObjCContainerAssignRetainedKeyAssignRetainedValueCallback =
{
   ASSIGN_RETAINED_KEY_CALLBACK,
   ASSIGN_RETAINED_VALUE_CALLBACK
};



const struct mulle_container_keyvaluecallback
   _MulleObjCContainerPointerKeyIntegerValueCallback =
{
   POINTER_KEY_CALLBACK,
   INTEGER_VALUE_CALLBACK
};


const struct mulle_container_keyvaluecallback
   _MulleObjCContainerIntegerKeyPointerValueCallback =
{
   INTEGER_KEY_CALLBACK,
   POINTER_VALUE_CALLBACK
};


const struct mulle_container_keyvaluecallback
   _MulleObjCContainerPointerKeyAssignValueCallback =
{
   POINTER_KEY_CALLBACK,
   ASSIGN_VALUE_CALLBACK
};


const struct mulle_container_keyvaluecallback
   _MulleObjCContainerCopiedCStringIntegerValueCallback =
{
   COPIED_CSTRING_KEY_CALLBACK,
   INTEGER_VALUE_CALLBACK
};


const struct mulle_container_keyvaluecallback
   _MulleObjCContainerIntegerKeyCopiedCStringValueCallback =
{
   INTEGER_KEY_CALLBACK,
   COPIED_CSTRING_VALUE_CALLBACK
};


const struct mulle_container_keyvaluecallback
   _MulleObjCContainerCopiedCStringPointerValueCallback =
{
   COPIED_CSTRING_KEY_CALLBACK,
   POINTER_VALUE_CALLBACK
};


const struct mulle_container_keyvaluecallback
   _MulleObjCContainerPointerKeyCopiedCStringValueCallback =
{
   POINTER_KEY_CALLBACK,
   COPIED_CSTRING_VALUE_CALLBACK
};


//extern struct mulle_container_keyvaluecallback   MulleObjCContainerRetainKeyCopyValueCallback;
//extern struct mulle_container_keyvaluecallback   MulleObjCContainerCopyKeyRetainValueCallback;
//extern struct mulle_container_keyvaluecallback   MulleObjCContainerCopyKeyCopyValueCallback;
//extern struct mulle_container_keyvaluecallback   MulleObjCContainerAssignKeyAssignRetainedValueCallback;

//extern struct mulle_container_keycallback     *MulleObjCContainerRetainKeyCallback;
//extern struct mulle_container_keycallback     *MulleObjCContainerCopyKeyCallback;
//extern struct mulle_container_valuecallback   *MulleObjCContainerRetainValueCallback;
//extern struct mulle_container_valuecallback   *MulleObjCContainerCopyValueCallback;


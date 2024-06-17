//
//  MulleObjCProperty.m
//  MulleObjC
//
//  Copyright (c) 2024 Nat! - Mulle kybernetiK.
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
#ifdef __has_include
# if __has_include( "NSObject.h")
#  import "NSObject.h"
# endif
#endif

#import "import.h"


MULLE_OBJC_GLOBAL
int   _MulleObjCInstanceClearProperty( struct _mulle_objc_property *property,
                                       struct _mulle_objc_infraclass *cls,
                                       void *self);

MULLE_OBJC_GLOBAL
int   _MulleObjCInstanceClearPropertyNoReadOnly( struct _mulle_objc_property *property,
                                                 struct _mulle_objc_infraclass *cls,
                                                 void *self);
MULLE_OBJC_GLOBAL
int   _MulleObjCClassWalkClearableProperties( struct _mulle_objc_infraclass *infra,
                                              mulle_objc_walkpropertiescallback_t f,
                                              void *userinfo);

MULLE_OBJC_GLOBAL
void   _MulleObjCInstanceClearProperties( id obj, BOOL clearReadOnly);


//  MulleObjRecycle and MulleObjCAcquire are useful to transfer objects from
//  one thread to another.
//
//  `_MulleObjCAcquirePointerAtomically` is a thread-safe way to acquire a pointer
//  atomically. It will return the pointer value if it is not NULL, otherwise
//  it will return NULL.
//
//  `_MulleObjCRecyclePointerAtomically is a thread-safe way to recycle a pointer
//  atomically. It will return <> 0, if the pointer was successfully recycled, otherwise
//  it will return 0.
//
//  To transfer an object from one thread to another, it gets recycled by one
//  thread and acquired by the other thread. Notice that an object in its
//  recycled state is in limbo until the other thread has acquired it and must
//  not be messaged. It is the responsibility of the storing thread to
//  discard the object in its -dealloc method, if an object was recycled but
//  never acquired.
//
//  Code it thusly:
//
//  ``` objc
//  - (void) dealloc
//  {
//     id   obj;
//
//     obj = (id) _mulle_atomic_pointer_read_nonatomic( &self->_available);
//     [obj release];
//
//     [super dealloc];
//  }
//  ```
//
static inline void   *_MulleObjCAcquirePointerAtomically( mulle_atomic_pointer_t *p)
{
   void   *value;
   void   *actual;

   value = _mulle_atomic_pointer_read( p);
   if( ! value)
      return( NULL);

   for(;;)
   {
      // zero out p, if its contents are "value"
      // don't zero on mismatch
      // return the actual contents of p (before zeroing)
      actual = __mulle_atomic_pointer_cas( p, NULL, value);
      if( ! actual || actual == value)
         return( actual);
      value = actual;
   }
}


static inline id   _MulleObjCAcquireObjectAtomically( mulle_atomic_pointer_t *p)
{
   id    obj;

   obj = _MulleObjCAcquirePointerAtomically( p);
   return( [obj mulleGainAccess]);
}


static inline int   _MulleObjRecyclePointerAtomically( mulle_atomic_pointer_t *p,
                                                       void *value)
{
   assert( value);
   return( _mulle_atomic_pointer_cas( p, value, NULL));
}


//
// This can fail, if another thread already recycled an object. Its up to the
// caller to decide, if he wants to acquire and discard this value, or
// discard his object (or keep both)
//
static inline BOOL   _MulleObjCRecycleObjectAtomically( mulle_atomic_pointer_t *p,
                                                        id obj)
{
   int   rval;

   if( ! obj)
      return( YES);  // fine

   // this will remove the object from our autorelease pools
   // and its now retained
   [obj mulleRelinquishAccess];

   rval = _MulleObjRecyclePointerAtomically( p, obj);
   if( ! rval)
   {
      //MulleUICLog( "Failed to store %#@ into pointer %p", obj, p);
      [obj mulleGainAccess];  // if recycling, fails plop it back into our thread
                              // and let autoreleasepool reap it.
                              // This may not be wanted though!!
      return( NO);
   }
   return( YES);
}



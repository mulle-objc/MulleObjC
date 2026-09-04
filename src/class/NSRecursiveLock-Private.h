//
//  NSRecursiveLock-Private.h
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
// NSRecursiveLock-Private.h — delegates to mulle_thread_recursive_mutex_t.
// The ivar layout of NSRecursiveLock (NSLock._lock, _thread_id, _depth)
// matches mulle_thread_recursive_mutex_t (_mutex, _thread_id, _depth) exactly,
// so we can cast self to mulle_thread_recursive_mutex_t * directly.

static inline mulle_thread_recursive_mutex_t *
   _MulleObjCRecursiveLockGetMutex( NSRecursiveLock *self)
{
   return( (mulle_thread_recursive_mutex_t *) &((struct { @defs( NSLock); } *) self)->_lock);
}


static inline NSRecursiveLock  *_MulleObjCRecursiveLockInit( NSRecursiveLock *self)
{
   mulle_thread_recursive_mutex_init( _MulleObjCRecursiveLockGetMutex( self));
   return( self);
}


static inline void  _MulleObjCRecursiveLockDone( NSRecursiveLock *self)
{
   mulle_thread_recursive_mutex_done( _MulleObjCRecursiveLockGetMutex( self));
}


static inline void  _MulleObjCRecursiveLockLock( NSRecursiveLock *self)
{
   mulle_thread_recursive_mutex_lock( _MulleObjCRecursiveLockGetMutex( self));
}


static inline void  _MulleObjCRecursiveLockUnlock( NSRecursiveLock *self)
{
   mulle_thread_recursive_mutex_unlock( _MulleObjCRecursiveLockGetMutex( self));
}


static inline BOOL  _MulleObjCRecursiveLockTryLock( NSRecursiveLock *self)
{
   return( mulle_thread_recursive_mutex_trylock( _MulleObjCRecursiveLockGetMutex( self)) == 0);
}


static inline NSUInteger  _MulleObjCRecursiveLockGetLockingDepth( NSRecursiveLock *self)
{
   mulle_thread_recursive_mutex_t   *p;

   p = _MulleObjCRecursiveLockGetMutex( self);
   return( (NSUInteger) _mulle_atomic_pointer_read( &p->_depth));
}

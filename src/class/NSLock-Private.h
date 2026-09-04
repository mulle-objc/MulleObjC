//
//  NSLock-Private.h
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
// this is a semi-private interface so that NSRecursiveLock and NSLockedObject
// have a somewhat simpler time
//
static inline NSLock   *_MulleObjCLockInit( NSLock *self)
{
   if( mulle_thread_mutex_init( &((struct { @defs( NSLock); } *) self)->_lock))
   {
      // TODO: vector through universe
      fprintf( stderr, "%s could not acquire a mutex\n", __FUNCTION__);
      abort();
   }
   return( self);
}


static inline void   _MulleObjCLockDone( NSLock *self)
{
   mulle_thread_mutex_done( &((struct { @defs( NSLock); } *) self)->_lock);
}


static inline void  _MulleObjCLockLock( NSLock *self)
{
   int   rval;

   rval = mulle_thread_mutex_lock( &((struct { @defs( NSLock); } *) self)->_lock);
   assert( ! rval);
   MULLE_C_UNUSED( rval);
}


static inline void  _MulleObjCLockUnlock( NSLock *self)
{
   int   rval;

   rval = mulle_thread_mutex_unlock( &((struct { @defs( NSLock); } *) self)->_lock);
   assert( ! rval);
   MULLE_C_UNUSED( rval);
}


static inline BOOL  _MulleObjCLockTryLock( NSLock *self)
{
   int   rval;

   rval = mulle_thread_mutex_trylock( &((struct { @defs( NSLock); } *) self)->_lock);
   if( ! rval)
      return( YES);
   if( rval == EBUSY)
      return( NO);

   errno = rval;
   perror( "mulle_thread_mutex_trylock");
   abort();
   return( NO);
}

static inline NSRecursiveLock  *MulleObjCRecursiveLockInit( NSRecursiveLock *self)
{
   return( (NSRecursiveLock *) MulleObjCLockInit( self));
}


static inline void  MulleObjCRecursiveLockDone( NSRecursiveLock *self)
{
   MulleObjCLockDone( self);
}


static inline void  MulleObjCRecursiveLockLock( NSRecursiveLock *_self)
{
   mulle_thread_t                      this_thread;
   mulle_thread_t                      thread;
   struct { @defs( NSRecursiveLock); } *self = (void *) _self;

   //
   // if this thread already locked, then just return increment depth
   // otherwise lock and block (we could do a "cas" here probing for NULL
   // and if succeeds then lock)
   //
   this_thread = mulle_thread_self();
   thread      = (mulle_thread_t) _mulle_atomic_pointer_read( &self->_thread);

   // three outcomes:
   //  1. we get this_thread back (already locked by us) -> just ++depth
   //  2. we get NULL back (unlocked) -> lock
   //  3. we get other back (locked) -> lock
   if( thread != this_thread)
   {
      // otherwise this thread locks for the first time (blocks to wait for
      // other thread to finish)
      MulleObjCLockLock( _self);
      assert( NULL == _mulle_atomic_pointer_read( &self->_thread));
      _mulle_atomic_pointer_write( &self->_thread, (void *) this_thread);
   }

   // paranoia
   _mulle_atomic_pointer_increment( &self->_depth);
}


static inline void  MulleObjCRecursiveLockUnlock( NSRecursiveLock *_self)
{
   struct { @defs( NSRecursiveLock); } *self = (void *) _self;

   //
   // this thread must be locked already, only unlock once we reach depth 1
   // otherwise lock and block (we could do a "cas" here probing for NULL
   // and if succeeds then lock)
   //
   assert( mulle_thread_self() == (mulle_thread_t) _mulle_atomic_pointer_read( &self->_thread));
   if( (intptr_t) _mulle_atomic_pointer_decrement( &self->_depth) > 0x1)
      return;

   _mulle_atomic_pointer_write( &self->_thread, NULL);
   MulleObjCLockUnlock( _self);
}


static inline BOOL  MulleObjCRecursiveLockTryLock( NSRecursiveLock *_self)
{
   mulle_thread_t                      this_thread;
   mulle_thread_t                      thread;
   struct { @defs( NSRecursiveLock); } *self = (void *) _self;

   //
   // if this thread already locked, then just return increment depth
   // otherwise lock and block (we could do a "cas" here probing for NULL
   // and if succeeds then lock)
   //
   this_thread = mulle_thread_self();
   thread      = (mulle_thread_t) _mulle_atomic_pointer_read( &self->_thread);

   // three outcomes:
   //  1. we get this_thread back (already locked by us) -> just ++depth
   //  2. we get NULL back (unlocked) -> lock
   //  3. we get other back (locked) -> lock
   if( thread != this_thread)
   {
      // otherwise this thread locks for the first time (blocks to wait for
      // other thread to finish)
      if( ! MulleObjCLockTryLock( _self))
         return( NO);
      assert( NULL == _mulle_atomic_pointer_read( &self->_thread));
      _mulle_atomic_pointer_write( &self->_thread, (void *) this_thread);
   }

   _mulle_atomic_pointer_increment( &self->_depth);
   return( YES);
}


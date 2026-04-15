static inline NSRecursiveLock  *_MulleObjCRecursiveLockInit( NSRecursiveLock *self)
{
   return( (NSRecursiveLock *) _MulleObjCLockInit( self));
}


static inline void  _MulleObjCRecursiveLockDone( NSRecursiveLock *self)
{
   _MulleObjCLockDone( self);
}


static inline void  _MulleObjCRecursiveLockLock( NSRecursiveLock *_self)
{
   mulle_thread_id_t   curr_thread_id;
   mulle_thread_id_t   lock_thread_id;

   struct { @defs( NSRecursiveLock); } *self = (void *) _self;

   //
   // if this thread is already locked, then just return increment depth
   // otherwise lock and block (we could do a "cas" here probing for NULL
   // and if succeeds then lock)
   //
   curr_thread_id = mulle_thread_id();
   lock_thread_id = (mulle_thread_id_t) _mulle_atomic_pointer_read( &self->_thread_id);

   // mulle_test_trace( "thread %p locks %p (locked by %p with depth %td)\n", 
   //                    curr_thread_id, 
   //                    self, 
   //                    lock_thread_id, 
   //                    _mulle_atomic_pointer_read( &self->_depth));

   // three outcomes:
   //  1. we get this_thread back (already locked by us) -> just ++depth
   //  2. we get NULL back (unlocked) -> lock
   //  3. we get other back (locked) -> lock
   if( lock_thread_id != curr_thread_id)
   {
      // otherwise this thread locks for the first time (blocks to wait for
      // other thread to finish)
      _MulleObjCLockLock( _self);
      assert( NULL == _mulle_atomic_pointer_read( &self->_thread_id));
      _mulle_atomic_pointer_write( &self->_thread_id, (void *) curr_thread_id);
   }

   // paranoia
   _mulle_atomic_pointer_increment( &self->_depth);
}


static inline void  _MulleObjCRecursiveLockUnlock( NSRecursiveLock *_self)
{
   struct { @defs( NSRecursiveLock); } *self = (void *) _self;

   //
   // this thread must be locked already, only unlock once we reach depth 1
   // otherwise lock and block (we could do a "cas" here probing for NULL
   // and if succeeds then lock)
   //
   assert( mulle_thread_id() == (mulle_thread_id_t) _mulle_atomic_pointer_read( &self->_thread_id));

   //mulle_test_trace( "thread %p unlocks %p (with depth %td)\n", 
   //                   mulle_thread_id(), 
   //                   self, 
   //                   _mulle_atomic_pointer_read( &self->_depth));

   if( (intptr_t) _mulle_atomic_pointer_decrement( &self->_depth) > 0x1)
      return;

   _mulle_atomic_pointer_write( &self->_thread_id, NULL);
   _MulleObjCLockUnlock( _self);
}


static inline BOOL  _MulleObjCRecursiveLockTryLock( NSRecursiveLock *_self)
{
   mulle_thread_id_t                   curr_thread_id;
   mulle_thread_id_t                   lock_thread_id;
   struct { @defs( NSRecursiveLock); } *self = (void *) _self;

   //
   // if this thread already locked, then just return increment depth
   // otherwise lock and block (we could do a "cas" here probing for NULL
   // and if succeeds then lock)
   //
   curr_thread_id = mulle_thread_id();
   lock_thread_id = (mulle_thread_id_t) _mulle_atomic_pointer_read( &self->_thread_id);

   // mulle_test_trace( "thread %p tries to lock %p (locked by %p with depth %td)\n", 
   //                    curr_thread_id, 
   //                    self, 
   //                    lock_thread_id, 
   //                    _mulle_atomic_pointer_read( &self->_depth));

   // three outcomes:
   //  1. we get this_thread back (already locked by us) -> just ++depth
   //  2. we get NULL back (unlocked) -> lock
   //  3. we get other back (locked) -> lock
   if( lock_thread_id != curr_thread_id)
   {
      // otherwise this thread locks for the first time (blocks to wait for
      // other thread to finish)
      if( ! _MulleObjCLockTryLock( _self))
         return( NO);
      assert( NULL == _mulle_atomic_pointer_read( &self->_thread_id));
      _mulle_atomic_pointer_write( &self->_thread_id, (void *) curr_thread_id);
   }

   _mulle_atomic_pointer_increment( &self->_depth);
   return( YES);
}


static inline NSUInteger  _MulleObjCRecursiveLockGetLockingDepth( NSRecursiveLock *_self)
{
   struct { @defs( NSRecursiveLock); } *self = (void *) _self;
   NSUInteger   depth;

   depth = (NSUInteger) _mulle_atomic_pointer_read( &self->_depth);
   return( depth);
}


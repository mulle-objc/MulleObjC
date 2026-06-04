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

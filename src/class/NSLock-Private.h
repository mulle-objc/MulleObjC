//
// this is a semi-private interface so that NSRecursiveLock and NSLockedObject
// have a somewhat simpler time
//
static inline NSLock   *MulleObjCLockInit( NSLock *self)
{
   if( mulle_thread_mutex_init( &((struct { @defs( NSLock); } *) self)->_lock))
   {
      // TODO: vector through universe
      fprintf( stderr, "%s could not acquire a mutex\n", __FUNCTION__);
      abort();
   }
   return( self);
}


static inline void   MulleObjCLockDone( NSLock *self)
{
   mulle_thread_mutex_done( &((struct { @defs( NSLock); } *) self)->_lock);
}


static inline void  MulleObjCLockLock( NSLock *self)
{
   int   rval;

   rval = mulle_thread_mutex_lock( &((struct { @defs( NSLock); } *) self)->_lock);
   assert( ! rval);
   MULLE_C_UNUSED( rval);
}


static inline void  MulleObjCLockUnlock( NSLock *self)
{
   int   rval;

   rval = mulle_thread_mutex_unlock( &((struct { @defs( NSLock); } *) self)->_lock);
   assert( ! rval);
   MULLE_C_UNUSED( rval);
}


static inline BOOL  MulleObjCLockTryLock( NSLock *self)
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

static inline void   _MulleObjectLock( MulleObject *self)
{
   struct { @defs( MulleObject); } *_self = (void *) self;

   if( _self->__lock)
      _MulleObjCRecursiveLockLock( _self->__lock);
}


static inline BOOL   _MulleObjectTryLock( MulleObject *self)
{
   struct { @defs( MulleObject); } *_self = (void *) self;

   if( ! _self->__lock)
      return( NO);
   return( _MulleObjCRecursiveLockTryLock( _self->__lock));
}


static inline void   _MulleObjectUnlock( MulleObject *self)
{
   struct { @defs( MulleObject); } *_self = (void *) self;

   if( _self->__lock)
      _MulleObjCRecursiveLockUnlock( _self->__lock);
}


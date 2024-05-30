static inline void   MulleLockingObjectLock( MulleObject *self)
{
   struct { @defs( MulleObject); } *_self = (void *) self;

   if( ! _self->__lock)
      _self->__lock = [NSRecursiveLock new];
   MulleObjCRecursiveLockLock( _self->__lock);
}


static inline BOOL   MulleLockingObjectTryLock( MulleObject *self)
{
   struct { @defs( MulleObject); } *_self = (void *) self;

   if( ! _self->__lock)
      _self->__lock = [NSRecursiveLock new];
   return( MulleObjCRecursiveLockTryLock( _self->__lock));
}


static inline void   MulleLockingObjectUnlock( MulleObject *self)
{
   struct { @defs( MulleObject); } *_self = (void *) self;

   MulleObjCRecursiveLockUnlock( _self->__lock);
}


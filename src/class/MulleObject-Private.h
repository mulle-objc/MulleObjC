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



//
// the idea here was to separate self from __target which would then be
// proxied forward to. alas its not so easy, because we would have to
// change more in the code above, which makes it seem not very useful
//
MULLE_C_ALWAYS_INLINE
static inline
   void  *MulleObjectLockingForward( MulleObject *self,
                                     mulle_objc_methodid_t methodid,
                                     void *parameter)
{
   mulle_functionpointer_t            p;
   mulle_objc_implementation_t        imp;
   struct _mulle_objc_cache           *cache;
   struct _mulle_objc_cacheentry      *entries;
   struct _mulle_objc_impcachepivot   *cachepivot;
   struct _mulle_objc_class           *cls;
   struct _mulle_objc_method          *method;
   struct _mulle_objc_universe        *universe;
   void                               *rval;
   NSRecursiveLock                    *lock;

   assert( mulle_objc_uniqueid_is_sane( methodid));

   assert( sizeof( void *) >= sizeof( struct _mulle_objc_cachepivot));

   cls        = _mulle_objc_object_get_non_tps_isa( self);
   cachepivot = (struct _mulle_objc_impcachepivot *) &cls->userinfo;
   entries    = _mulle_objc_impcachepivot_get_entries_atomic( cachepivot);
   cache      = _mulle_objc_cacheentry_get_cache_from_entries( entries);
   p          = _mulle_objc_cache_probe_functionpointer( cache, methodid);
   imp        = (mulle_objc_implementation_t) p;

   if( ! imp)
   {
      method     = mulle_objc_class_search_method_nofail( cls, methodid);
      imp        = _mulle_objc_method_get_implementation( method);
      universe   = _mulle_objc_class_get_universe( cls);
      _mulle_objc_impcachepivot_fill( cachepivot,
                                      imp,
                                      methodid,
                                      MULLE_OBJC_CACHESIZE_GROW,
                                      universe);
   }

   lock = ((struct { @defs( MulleObject); } *) self)->__lock; // can be NULL

   // it's vital, that we increment and decrement the identical lock
   // for performance reasons, we don't retain it (users responsibility
   // not to torch it)
   if( lock)
      _MulleObjCRecursiveLockLock( lock);

#ifdef NDEBUG
   rval = mulle_objc_implementation_invoke( imp, self, methodid, parameter);
#else
   @try
   {
      rval = mulle_objc_implementation_invoke( imp, self, methodid, parameter);
   }
   @catch( id exception)
   {
      __mulle_objc_universe_raise_internalinconsistency( universe,
                               "An exception %@ is passing thru a -[%@ %s] "
                               "method call, which will lead to a deadlock",
                               exception,
                               MulleObjCObjectGetClass( self),
                               mulle_objc_universe_lookup_methodname( universe, methodid));
   }
#endif
   if( lock)
      _MulleObjCRecursiveLockUnlock( lock);

   return( rval);
}



MULLE_C_ALWAYS_INLINE
static inline
   void  *MulleObjectLockingSuperForward( MulleObject *self,
                                          mulle_objc_methodid_t methodid,
                                          void *parameter)

{
   void                               *rval;
   NSRecursiveLock                    *lock;
   mulle_objc_implementation_t        imp;
   struct _mulle_objc_impcachepivot   *cachepivot;
   struct _mulle_objc_impcache        *icache;
   struct _mulle_objc_class           *cls;
   struct _mulle_objc_method          *forward;

   cls        = _mulle_objc_object_get_non_tps_isa( self);
   cachepivot = (struct _mulle_objc_impcachepivot *) &cls->userinfo;
   icache     = _mulle_objc_impcachepivot_get_impcache_atomic( cachepivot);
   forward    = _mulle_atomic_pointer_read( &icache->callback.userinfo);
   if( ! forward)
   {
      forward    = mulle_objc_class_search_method_nofail( cls, @selector( forward:));
      _mulle_atomic_pointer_write( &icache->callback.userinfo, forward);
   }

   imp  = _mulle_objc_method_get_implementation( forward);
   lock = ((struct { @defs( MulleObject); } *) self)->__lock; // can be NULL

   // it's vital, that we increment and decrement the identical lock
   // for performance reasons, we don't retain it (users responsibility
   // not to torch it)
   if( lock)
      _MulleObjCRecursiveLockLock( lock);

#ifdef NDEBUG
   rval = mulle_objc_implementation_invoke( imp, self, methodid, parameter);
#else
   @try
   {
      rval = mulle_objc_implementation_invoke( imp, self, methodid, parameter);
   }
   @catch( id exception)
   {
      struct _mulle_objc_universe   *universe;

      universe = _mulle_objc_object_get_universe( self);
      __mulle_objc_universe_raise_internalinconsistency( universe,
                               "An exception %@ is passing thru a -[%@ %s] "
                               "method call, which will lead to a deadlock",
                               exception,
                               MulleObjCObjectGetClass( self),
                               mulle_objc_universe_lookup_methodname( universe, methodid));
   }
#endif
   if( lock)
      _MulleObjCRecursiveLockUnlock( lock);

   return( rval);
}


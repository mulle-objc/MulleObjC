//
//  MulleObject-Private.h
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


MULLE_C_STATIC_ALWAYS_INLINE
mulle_objc_implementation_t
   MulleObjectGetForwardImp( MulleObject *self,
                             mulle_objc_methodid_t methodid)
{
   mulle_functionpointer_t            p;
   mulle_objc_implementation_t        imp;
   struct _mulle_objc_cache           *cache;
   struct _mulle_objc_cacheentry      *entries;
   struct _mulle_objc_impcachepivot   *cachepivot;
   struct _mulle_objc_class           *cls;
   struct _mulle_objc_method          *method;
   struct _mulle_objc_universe        *universe;

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
      assert( imp != NULL && imp != (mulle_objc_implementation_t) -1);
      universe   = _mulle_objc_class_get_universe( cls);
      _mulle_objc_impcachepivot_fill( cachepivot,
                                      imp,
                                      methodid,
                                      MULLE_OBJC_CACHESIZE_GROW,
                                      universe);
   }
   return( imp);
}



MULLE_C_STATIC_ALWAYS_INLINE
mulle_objc_implementation_t
   MulleObjectGetSuperForwardImp( MulleObject *self,
                                  mulle_objc_methodid_t methodid)
{
   mulle_objc_implementation_t        imp;
   struct _mulle_objc_class           *cls;
   struct _mulle_objc_impcache        *icache;
   struct _mulle_objc_impcachepivot   *cachepivot;
   struct _mulle_objc_method          *forward;

   cls        = _mulle_objc_object_get_non_tps_isa( self);
   cachepivot = (struct _mulle_objc_impcachepivot *) &cls->userinfo;
   icache     = _mulle_objc_impcachepivot_get_impcache_atomic( cachepivot);
   forward    = _mulle_atomic_pointer_read( &icache->callback.userinfo);
   if( ! forward)
   {
      forward = mulle_objc_class_search_method_nofail( cls, @selector( forward:));
      _mulle_atomic_pointer_write( &icache->callback.userinfo, forward);
   }

   imp = _mulle_objc_method_get_implementation( forward);

   return( imp);
}




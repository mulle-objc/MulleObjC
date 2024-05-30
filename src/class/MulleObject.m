#import "MulleObject.h"

#import "import-private.h"

#import "MulleObjCException.h"

#import "MulleObjCExceptionHandler-Private.h"
#import "NSLock-Private.h"
#import "NSRecursiveLock-Private.h"
#import "MulleObject-Private.h"


@implementation MulleObject


static struct _mulle_objc_method   *
   threadSafeMethodForSelector_noforward( struct _mulle_objc_class *cls,
                                          mulle_objc_methodid_t methodid,
                                          struct _mulle_objc_searchresult *result)
{
   unsigned int                         inheritance;
   struct _mulle_objc_method            *method;
   struct _mulle_objc_searcharguments   search;

   inheritance = MULLE_OBJC_CLASS_DONT_INHERIT_PROTOCOL_CATEGORIES |
                 MULLE_OBJC_CLASS_DONT_INHERIT_INHERITANCE;

   _mulle_objc_searcharguments_init_default( &search, methodid);
   method = mulle_objc_class_search_method( cls,
                                            &search,
                                            inheritance,
                                            result);
   return( method);
}


static inline struct _mulle_objc_method *
   threadSafeSearchForwardMethod( struct _mulle_objc_class *cls,
                                  int *error)
{
   struct _mulle_objc_method         *method;
   struct _mulle_objc_searchresult   result;

   method = threadSafeMethodForSelector_noforward( cls, 
                                                   MULLE_OBJC_FORWARD_METHODID, 
                                                   &result);
   if( ! method)
   {
      method = cls->universe->classdefaults.forwardmethod;
      *error = result.error;
   }
   return( method);
}


struct _mulle_objc_method *
   threadSafeLazyGetForwardMethod( struct _mulle_objc_class *cls,
                                  int *error)
{
   struct _mulle_objc_method   *method;

   assert( mulle_objc_class_is_current_thread_registered( cls));

   method = _mulle_objc_class_get_forwardmethod( cls);
   if( ! method)
   {
      method = threadSafeSearchForwardMethod( cls, error);
      if( method)
         _mulle_objc_class_set_forwardmethod( cls, method);
   }
   return( method);
}



struct _mulle_objc_method *
   threadSafeLazyGetForwardMethod_nofail( struct _mulle_objc_class *cls,
                                          mulle_objc_methodid_t missing_method)
{  
   struct _mulle_objc_method   *method;
   int                         error;

   method = threadSafeLazyGetForwardMethod( cls, &error);
   if( method)
      return( method);

   _mulle_objc_class_fail_forwardmethodnotfound( cls, missing_method, error);
}


static struct _mulle_objc_method   *
   threadSafeSuperMethodForSelector_noforward( struct _mulle_objc_class *cls,
                                               mulle_objc_methodid_t superid,
                                               struct _mulle_objc_searchresult *result)
{
   unsigned int                         inheritance;
   struct _mulle_objc_method            *method;
   struct _mulle_objc_universe          *universe;
   struct _mulle_objc_super             *p;
   struct _mulle_objc_searcharguments   search;

   inheritance = MULLE_OBJC_CLASS_DONT_INHERIT_PROTOCOL_CATEGORIES |
                 MULLE_OBJC_CLASS_DONT_INHERIT_INHERITANCE;

   universe = _mulle_objc_class_get_universe( cls);
   p        = _mulle_objc_universe_lookup_super_nofail( universe, superid);

   _mulle_objc_searcharguments_init_super( &search, p->methodid, p->classid);
   method   = mulle_objc_class_search_method( cls,
                                              &search,
                                              inheritance,
                                              result);
   return( method);
}


// This basically how a struct _mulle_objc_cache looks like and what
// the cachepivot does.
//
//            +---+
//            | 4 | size
//            +---+
//            | 3 | count
//            +---+
// pivot ---> | a | entries[]
//            +---+
//            | b |
//            +---+
//            | c |
//            +---+
//            | 0 |
//            +---+
//
static BOOL  is_a_locking_descriptor( struct _mulle_objc_descriptor *desc,
                                      struct _mulle_objc_searchresult *result)
{
   if( ! _mulle_objc_descriptor_is_threadaffine( desc))
      return( NO);

   switch( _mulle_objc_descriptor_get_methodfamily( desc))
   {
   case _mulle_objc_methodfamily_init        :
   case _mulle_objc_methodfamily_dealloc     :
//   case _mulle_objc_methodfamily_release     :
//   case _mulle_objc_methodfamily_retain      :
//   case _mulle_objc_methodfamily_retaincount :
      return( NO);

   default : ;
   }
   return( YES);
}


static void   MulleLockingObjectFillSecondaryCache( MulleObject *self,
                                                    SEL sel,
                                                    IMP imp)
{
   struct _mulle_objc_cachepivot   *pivot;
   struct _mulle_objc_class        *cls;
   struct _mulle_objc_universe     *universe;
   struct mulle_allocator          *allocator;

   cls       = _mulle_objc_object_get_non_tps_isa( self);
   pivot     = (struct _mulle_objc_cachepivot *) &cls->userinfo;

   // all other methods enter our secondary cache
   universe  = _mulle_objc_class_get_universe( cls);
   allocator = _mulle_objc_universe_get_allocator( universe);
   _mulle_objc_cachepivot_fill_functionpointer( pivot,
                                                (mulle_functionpointer_t) imp,
                                                (mulle_objc_methodid_t) sel,
                                                60,
                                                allocator);
}


void   MulleLockingObjectFillCache( MulleObject *self, SEL sel, IMP imp, BOOL isThreadAffine)
{
   struct _mulle_objc_cacheentry   *entry;
   struct _mulle_objc_universe     *universe;
   struct _mulle_objc_class        *cls;

   cls = _mulle_objc_object_get_non_tps_isa( self);
   if( isThreadAffine || _mulle_objc_class_get_state_bit( cls, MULLE_OBJC_CLASS_IS_NOT_THREAD_AFFINE))
   {
      MulleLockingObjectFillSecondaryCache( self, sel, imp);
      return;
   }

   if( _mulle_objc_class_get_state_bit( cls, MULLE_OBJC_CLASS_ALWAYS_EMPTY_CACHE))
      return;

   universe = _mulle_objc_class_get_universe( cls);
   // when we trace method calls, we don't cache ever
   if( universe->debug.method_call & MULLE_OBJC_UNIVERSE_CALL_TRACE_BIT)
      return;

   if( universe->debug.method_call & MULLE_OBJC_UNIVERSE_CALL_TAO_BIT)
   {
      // check if method is threadsafe, if not, it won't get into the cache
      // when tao checking is enabled, if the class is not, then all methods
      // are fine.
      //
      // | class_is_threadaffine | method_is_threadaffine | threadsafe
      // |-----------------------|------------------------|------------
      // | NO                    | NO                     | YES
      // | NO                    | YES                    | YES
      // | YES                   | NO                     | YES
      // | YES                   | YES                    | NO
      //
      if( _mulle_objc_class_is_threadaffine( cls) && isThreadAffine)
         return;
   }


   // push it into the main cache
   entry = _mulle_objc_class_add_imp_to_impcachepivot( cls,
                                                       NULL,
                                                       (mulle_objc_implementation_t) imp,
                                                       (mulle_objc_methodid_t) sel);
#ifdef MULLE_OBJC_CACHEENTRY_REMEMBERS_THREAD_CLASS
   if( entry)
      entry->cls = cls;
#else
   MULLE_C_UNUSED( entry);
#endif
}


// 
// Methods that are defined in NSObject are assumed to be threadsafe and 
// will not be locked. (hmm)
//
// This function will be called by "partial", so we need to run through the
// main cache first (possibly again)...
//
static void   *_MulleLockingObjectCallClass( void *obj,
                                             mulle_objc_methodid_t methodid,
                                             void *parameter,
                                             struct _mulle_objc_class *cls)
{
   mulle_functionpointer_t           p;
   mulle_objc_cache_uint_t           mask;
   mulle_objc_cache_uint_t           offset;
   mulle_objc_implementation_t       imp;
   MulleObject                *self;
   struct _mulle_objc_cache          *cache;
   struct _mulle_objc_cacheentry     *entries;
   struct _mulle_objc_cacheentry     *entry;
   struct _mulle_objc_cachepivot     *pivot;
   struct _mulle_objc_descriptor     *desc;
   struct _mulle_objc_method         *method;
   struct _mulle_objc_searchresult   result;
   struct _mulle_objc_universe       *universe;
   struct mulle_allocator            *allocator;
   void                              *rval;

   assert( obj);
   assert( mulle_objc_uniqueid_is_sane( methodid));

   entries = _mulle_objc_cachepivot_get_entries_atomic( &cls->cachepivot.pivot);
   cache   = _mulle_objc_cacheentry_get_cache_from_entries( entries);
   mask    = cache->mask;

   offset  = (mulle_objc_cache_uint_t) methodid;
   for(;;)
   {
      offset = offset & mask;
      entry  = (void *) &((char *) entries)[ offset];

      if( entry->key.uniqueid == methodid)
      {
         p   = _mulle_atomic_functionpointer_nonatomic_read( &entry->value.functionpointer);
         imp = (mulle_objc_implementation_t) p;
         // direct cache hit, no trace(!), no tao check needed
         return( (*imp)( obj, methodid, parameter));
      }

      if( ! entry->key.uniqueid)
         break;
      offset += sizeof( struct _mulle_objc_cacheentry);
   }

   // NOW check secondary cache for cached "unsafe" methods
   assert( sizeof( void *) >= sizeof( struct _mulle_objc_cachepivot));

   pivot   = (struct _mulle_objc_cachepivot *) &cls->userinfo;
   entries = _mulle_objc_cachepivot_get_entries_atomic( pivot);
   cache   = _mulle_objc_cacheentry_get_cache_from_entries( entries);
   p       = _mulle_objc_cache_probe_functionpointer( cache, methodid);
   imp     = (mulle_objc_implementation_t) p;

   if( ! imp)
   {
      method = threadSafeMethodForSelector_noforward( cls, methodid, &result);
      if( method)
      {
         desc = _mulle_objc_method_get_descriptor( method);
         if( ! is_a_locking_descriptor( desc, &result))
         {
            // NSObject methods go into the main cache 
            imp = _mulle_objc_method_get_implementation( method);
            _mulle_objc_class_fill_impcache_method( cls, NULL, method, methodid);
            return( mulle_objc_implementation_invoke( imp, obj, methodid, parameter));
         }
      }

      //
      // All other methods enter our secondary cache.
      //
      // Failed idea: the secondary could also figure out, if an object is
      // returned and, if yes, it would retain/autorelease it. There are two
      // problems. 1) would need to add a bit to the imp to differentiate, but
      // with `cc -Os`, methods are byte aligned. Would need to use
      // -falign-functions=2 or some such. 2) can't figure it out for forward
      // methods. (THIS IS THE DEAL BREAKER).
      //
      universe = _mulle_objc_class_get_universe( cls);
      if( ! method)
      {
         // lazy will search with wrong inheritance defaults
         method = threadSafeLazyGetForwardMethod_nofail( cls, methodid);
      }

      imp       = _mulle_objc_method_get_implementation( method);
      allocator = _mulle_objc_universe_get_allocator( universe);
      _mulle_objc_cachepivot_fill_functionpointer( pivot, 
                                                   (mulle_functionpointer_t) imp, 
                                                   methodid, 
                                                   60,
                                                   allocator);
   }

   self = (MulleObject *) obj;

   MulleLockingObjectLock( self);
#ifdef NDEBUG
   rval = mulle_objc_implementation_invoke( imp, obj, methodid, parameter);
#else
   @try
   {
      rval = mulle_objc_implementation_invoke( imp, obj, methodid, parameter);
   }
   @catch( id ex)
   {
      __mulle_objc_universe_raise_internalinconsistency( universe,
                               "An exception %@ is passing thru a -[%@ %s] "
                               "method call, which will lead to a deadlock", 
                               ex, 
                               MulleObjCObjectGetClass( obj),
                               mulle_objc_universe_lookup_methodname( universe, methodid));
   }
#endif
   MulleLockingObjectUnlock( self);

   return( rval);
}


//
// super can store either into the second level cache or into the main
// cache, that depends on where the implementation is stored. If its 
// "below" MulleObject, it can move into the main cache
//
static void *   _MulleLockingObjectSuperCall( void *obj,
                                              mulle_objc_methodid_t methodid,
                                              void *parameter,
                                              mulle_objc_superid_t superid,
                                              struct _mulle_objc_class *cls)
{
   mulle_functionpointer_t           p;
   mulle_objc_cache_uint_t           mask;
   mulle_objc_cache_uint_t           offset;
   mulle_objc_implementation_t       imp;
   MulleObject                *self;
   struct _mulle_objc_cache          *cache;
   struct _mulle_objc_cacheentry     *entries;
   struct _mulle_objc_cacheentry     *entry;
   struct _mulle_objc_cachepivot     *pivot;
   struct _mulle_objc_descriptor     *desc;
   struct _mulle_objc_method         *method;
   struct _mulle_objc_searchresult   result;
   struct _mulle_objc_universe       *universe;
   struct mulle_allocator            *allocator;
   void                              *rval;

   assert( obj);
   assert( mulle_objc_uniqueid_is_sane( methodid));

   entries = _mulle_objc_cachepivot_get_entries_atomic( &cls->cachepivot.pivot);
   cache   = _mulle_objc_cacheentry_get_cache_from_entries( entries);
   mask    = cache->mask;

   offset  = (mulle_objc_cache_uint_t) superid;
   for(;;)
   {
      offset = offset & mask;
      entry  = (void *) &((char *) entries)[ offset];
      if( entry->key.uniqueid == superid)
      {
         p   = _mulle_atomic_functionpointer_nonatomic_read( &entry->value.functionpointer);
         imp = (mulle_objc_implementation_t) p;
         // do not TAO check, do not trace (never done for cached ones)
         return( (*imp)( obj, methodid, parameter));
      }
      if( ! entry->key.uniqueid)
      {
         break;
      }
      offset += sizeof( struct _mulle_objc_cacheentry);
   }
/*->*/

   assert( sizeof( void *) >= sizeof( struct _mulle_objc_cachepivot));

   pivot   = (struct _mulle_objc_cachepivot *) &cls->userinfo;
   entries = _mulle_objc_cachepivot_get_entries_atomic( pivot);
   cache   = _mulle_objc_cacheentry_get_cache_from_entries( entries);
   p       = _mulle_objc_cache_probe_functionpointer( cache, superid);
   imp     = (mulle_objc_implementation_t) p;

   if( ! imp)
   {
      method = threadSafeSuperMethodForSelector_noforward( cls, superid, &result);
      if( method)
      {
         desc = _mulle_objc_method_get_descriptor( method);
         if( ! is_a_locking_descriptor( desc, &result))
         {
            imp = _mulle_objc_method_get_implementation( method);
            _mulle_objc_class_fill_impcache_method( cls, NULL, method, superid);
            // do not TAO check, do not trace (done by the fill)
            return( (*imp)( obj, methodid, parameter));
         }
      }

      // all other methods enter our secondary cache
      universe = _mulle_objc_class_get_universe( cls);
      if( ! method)
         method = threadSafeLazyGetForwardMethod_nofail( cls, methodid);

      imp = _mulle_objc_method_get_implementation( method);

      allocator = _mulle_objc_universe_get_allocator( universe);
      _mulle_objc_cachepivot_fill_functionpointer( pivot, 
                                                   (mulle_functionpointer_t) imp, 
                                                   superid, 
                                                   60,
                                                   allocator);
   }

   self = (MulleObject *) obj;
   MulleLockingObjectLock( self);

#ifdef NDEBUG
   rval = mulle_objc_implementation_invoke( imp, obj, methodid, parameter);
#else
   @try
   {
      rval = mulle_objc_implementation_invoke( imp, obj, methodid, parameter);
   }
   @catch( MulleObjCException *ex)
   {
      __mulle_objc_universe_raise_internalinconsistency( universe,
                               "An exception %@ is passing thru a -[%@ %s] "
                               "method call, which will lead to a deadlock", 
                               ex, 
                               MulleObjCObjectGetClass( obj),
                               mulle_objc_universe_lookup_methodname( universe, methodid));
   }
#endif
   MulleLockingObjectUnlock( self);

   return( rval);
}


static void   *_MulleLockingObjectCall2( void *obj,
                                         mulle_objc_methodid_t methodid,
                                         void *parameter)
{
   struct _mulle_objc_class  *cls;

   cls = _mulle_objc_object_get_non_tps_isa( obj);
   return( _MulleLockingObjectCallClass( obj, methodid, parameter, cls));
}


void   MulleLockingObjectSetAutolockingEnabled( Class self, BOOL flag)
{
   struct _mulle_objc_infraclass   *infra;
   struct _mulle_objc_class        *cls;

   infra = (struct _mulle_objc_infraclass *) self;
   cls   = _mulle_objc_infraclass_as_class( infra);

   if( flag)
   {
   // search superclass, but don't inherit anything from myself
      cls->inheritance |= MULLE_OBJC_CLASS_DONT_INHERIT_CLASS
                          | MULLE_OBJC_CLASS_DONT_INHERIT_CATEGORIES
                          | MULLE_OBJC_CLASS_DONT_INHERIT_PROTOCOLS
                          | MULLE_OBJC_CLASS_DONT_INHERIT_PROTOCOL_CATEGORIES
                          | MULLE_OBJC_CLASS_DONT_INHERIT_PROTOCOL_META;
   // since we are clobbering with MULLE_OBJC_CLASS_DONT_INHERIT_PROTOCOL_CATEGORIES
   // the initialize of MulleObjCThreadSafe won't run, so we do this manually
     _mulle_objc_class_set_state_bit( cls, MULLE_OBJC_CLASS_IS_NOT_THREAD_AFFINE);
   }
   else
   {
      cls->inheritance &= ~(MULLE_OBJC_CLASS_DONT_INHERIT_CLASS
                            | MULLE_OBJC_CLASS_DONT_INHERIT_CATEGORIES
                            | MULLE_OBJC_CLASS_DONT_INHERIT_PROTOCOLS
                            // | MULLE_OBJC_CLASS_DONT_INHERIT_PROTOCOL_CATEGORIES
                            | MULLE_OBJC_CLASS_DONT_INHERIT_PROTOCOL_META);
      _mulle_objc_class_clear_state_bit( cls, MULLE_OBJC_CLASS_IS_NOT_THREAD_AFFINE);
   }
}


+ (void) initialize
{
   if( [self conformsToProtocol:@protocol( MulleAutolockingObject)])
      MulleLockingObjectSetAutolockingEnabled( self, YES);
}


// MEMO: doing this in +initialize is probably not so good, because the cache
//       hasn't been setup yet. we could call _mulle_objc_class_setup_initial_cache_if_needed
//       but then it would be still somewhat hackish. If this pains too much in
//       +alloc, then the runtime needs a +postInitialize of some sorts
//
+ (instancetype) alloc
{
   id                              obj;
   mulle_thread_mutex_t            *lock;
   struct _mulle_objc_cache        *fcache;
   // struct _mulle_objc_cache        *old_cache;
   struct _mulle_objc_cachepivot   *pivot;
   struct _mulle_objc_class        *cls;
   struct _mulle_objc_classpair    *pair;
   struct _mulle_objc_impcache     *icache;
   struct _mulle_objc_infraclass   *infra;
   struct _mulle_objc_universe     *universe;
   struct mulle_allocator          *allocator;

   infra = (struct _mulle_objc_infraclass *) self;
   cls   = _mulle_objc_infraclass_as_class( infra);

   //
   // ** late +initialize code ** >>>
   //
   if( ! _mulle_objc_class_get_userinfo( cls))  // cheapest test first
   {
      // this is supposed to run only once per class, not per instance
      if( _mulle_objc_class_get_state_bit( cls, MULLE_OBJC_CLASS_IS_NOT_THREAD_AFFINE))
      {
         pair = _mulle_objc_infraclass_get_classpair( infra);
         lock = _mulle_objc_classpair_get_lock( pair);
         mulle_thread_mutex_do( *lock)
         {
            if( ! _mulle_objc_class_get_userinfo( cls))
            {
               // code for +initialize
               // its a little too early, to setup the proper cache, but we gotta
               // do it here
               // _mulle_objc_class_setup_initial_cache_if_needed( cls);

               // when the cache is swapped, the callbacks of the old cache are
               // copied to the grown instance
               icache             = _mulle_objc_class_get_impcache( cls);
               icache->call       = _MulleLockingObjectCallClass;
               icache->call2      = _MulleLockingObjectCall2;
               icache->supercall  = _MulleLockingObjectSuperCall;
               icache->supercall2 = _MulleLockingObjectSuperCall; // same parameters, is OK

               universe  = _mulle_objc_class_get_universe( cls);
               allocator = _mulle_objc_universe_get_allocator( universe);
               fcache    = mulle_objc_cache_new( 128, allocator);

               pivot     = (struct _mulle_objc_cachepivot *) &cls->userinfo;
               _mulle_objc_cachepivot_swap( pivot, fcache, NULL, allocator);
            }
         }
      }
   }
   //
   // ** late +initialize code ** <<<
   //

   obj = _MulleObjCClassAllocateInstance( self, 0);

   //
   // we don't create lock initially, only lazy. this way we can avoid
   // generating short lived locks, if we wanted to

   return( obj);
}


- (void) dealloc
{
   [__lock release];
   [super dealloc];
}


+ (void) deinitialize
{
   struct _mulle_objc_cache        *cache;
   struct _mulle_objc_cachepivot   *pivot;
   struct _mulle_objc_class        *cls;
   struct _mulle_objc_infraclass   *infra;
   struct _mulle_objc_universe     *universe;
   struct mulle_allocator          *allocator;

   infra = (struct _mulle_objc_infraclass *) self;
   cls   = _mulle_objc_infraclass_as_class( infra);
   if( _mulle_objc_class_get_userinfo( cls))
   {
      universe  = _mulle_objc_class_get_universe( cls);
      allocator = _mulle_objc_universe_get_allocator( universe);

      pivot     = (struct _mulle_objc_cachepivot *) &cls->userinfo;
      cache     = _mulle_objc_cachepivot_get_cache_atomic( pivot);
      _mulle_objc_cachepivot_swap( pivot, NULL, cache, allocator);
   }
}


- (void) lock
{
   MulleLockingObjectLock( self);
}


- (void) unlock
{
   MulleLockingObjectUnlock( self);
}


- (BOOL) tryLock
{
   return( MulleLockingObjectTryLock( self));
}


//
// WHAT DO WE NEED ALL THIS FOR ???
//
// It also seems wrong, because we are only finding the threadSafe methods
//
#if 0
- (BOOL) respondsToSelector:(SEL) sel
{
   struct _mulle_objc_class   *cls;
   struct _mulle_objc_method  *method;

   // OS X compatible
   if( ! sel)
      return( NO);

   cls    = _mulle_objc_object_get_isa( self);
   method = threadSafeMethodForSelector_noforward( cls, (mulle_objc_methodid_t) sel, NULL);
   return( method ? YES : NO);
}


+ (BOOL) instancesRespondToSelector:(SEL) sel
{
   struct _mulle_objc_infraclass  *infra;
   struct _mulle_objc_class       *cls;
   struct _mulle_objc_method      *method;

   // OS X compatible
   if( ! sel)
      return( NO);

   infra  = (struct _mulle_objc_infraclass *) self;
   cls    = _mulle_objc_object_get_isa( infra);
   method = threadSafeMethodForSelector_noforward( cls, (mulle_objc_methodid_t) sel, NULL);
   return( method ? YES : NO);
}


- (IMP) methodForSelector:(SEL) sel
{
   struct _mulle_objc_class   *cls;
   struct _mulle_objc_method  *method;

   // this produces NSInvalidArgumentException on OS X for (SEL) 0
   cls    = _mulle_objc_object_get_isa( self);
   method = threadSafeMethodForSelector_noforward( cls, (mulle_objc_methodid_t) sel, NULL);
   return( (IMP) (method ? _mulle_objc_method_get_implementation( method) : 0));
}


+ (IMP) instanceMethodForSelector:(SEL) sel
{
   struct _mulle_objc_infraclass  *infra;
   struct _mulle_objc_class       *cls;
   struct _mulle_objc_method      *method;

   infra  = (struct _mulle_objc_infraclass *) self;
   cls    = _mulle_objc_object_get_isa( infra);
   method = threadSafeMethodForSelector_noforward( cls, (mulle_objc_methodid_t) sel, NULL);
   return( (IMP) (method ? _mulle_objc_method_get_implementation( method) : 0));
}


- (NSMethodSignature *) methodSignatureForSelector:(SEL) sel
{
   struct _mulle_objc_class    *cls;
   struct _mulle_objc_method   *method;

   // OS X compatible
   if( ! sel)
      return( nil);

   // this produces NSInvalidArgumentException on OS X for (SEL) 0
   cls    = _mulle_objc_object_get_isa( self);
   method = threadSafeMethodForSelector_noforward( cls, (mulle_objc_methodid_t) sel, NULL);
   if( ! method)
      return( nil); // TODO: need to call super for forwarding or ?

   return( [NSMethodSignature _signatureWithObjCTypes:method->descriptor.signature
                                       descriptorBits:method->descriptor.bits]);
}


+ (NSMethodSignature *) instanceMethodSignatureForSelector:(SEL) sel
{
   struct _mulle_objc_infraclass  *infra;
   struct _mulle_objc_class       *cls;
   struct _mulle_objc_method      *method;

   // OS X compatible
   if( ! sel)
      return( nil);

   infra  = (struct _mulle_objc_infraclass *) self;
   cls    = _mulle_objc_object_get_isa( infra);
   method = threadSafeMethodForSelector_noforward( cls, (mulle_objc_methodid_t) sel, NULL);
   if( ! method)
      return( nil); // TODO: need to call super for forwarding or ?

   return( [NSMethodSignature signatureWithObjCTypes:method->descriptor.signature]);
}

#endif


//
// if you sent other = nil, then self will return to a private lock
//
- (void) shareLockOfObject:(MulleObject *) other
{
   NSRecursiveLock   *lock;

   NSLockingDo( other)
   {
      lock = other ? other->__lock : nil;
      if( lock != self->__lock)
      {
         [self->__lock autorelease];
         self->__lock = [lock retain];
      }
   }
}

@end

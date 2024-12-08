#import "MulleObject.h"

#import "import-private.h"

#import "MulleObjCException.h"
#import "MulleObjCFunctions.h"

#import "MulleObjCExceptionHandler-Private.h"
#import "NSLock-Private.h"
#import "NSRecursiveLock-Private.h"
#import "MulleObject-Private.h"


PROTOCOLCLASS_IMPLEMENTATION( MulleAutolockingObject)

- (MulleObjCTAOStrategy) mulleTAOStrategy   MULLE_OBJC_THREADSAFE_METHOD
{
   return( MulleObjCTAOKnownThreadSafe);
}

PROTOCOLCLASS_END()



@implementation MulleObject

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


static struct _mulle_objc_method   *
   threadSafeMethodForSelector_noforward( struct _mulle_objc_class *cls,
                                          mulle_objc_methodid_t methodid)
{
   unsigned int                         inheritance;
   struct _mulle_objc_method            *method;
   struct _mulle_objc_descriptor        *desc;
   struct _mulle_objc_searcharguments   search;
   struct _mulle_objc_searchresult      result;

   search      = mulle_objc_searcharguments_make_default( methodid);
   inheritance = _mulle_objc_class_get_inheritance( cls);
   method      = mulle_objc_class_search_method( cls,
                                                 &search,
                                                 inheritance,
                                                 &result);
   if( method)
   {
      desc = _mulle_objc_method_get_descriptor( method);
      if( is_a_locking_descriptor( desc, &result))
         method = NULL;
   }
   return( method);
}


struct _mulle_objc_method *
   _MulleObjectRefreshMethodNofail( struct _mulle_objc_class *cls,
                                    mulle_objc_methodid_t methodid)
{
   struct _mulle_objc_method   *method;

   method = threadSafeMethodForSelector_noforward( cls, methodid);
   if( ! method)
      method = mulle_objc_class_defaultsearch_method( cls, @selector( __lockingForward:));
   assert( method);
   _mulle_objc_class_fill_impcache_method( cls, method, methodid);
   return( method);
}


//
// Super lookup is even easier. If the method exists, then we can assume
// that the caller (self) has been properly locked already, or, if the
// method is threadsafe then the super method must also be threadsafe.
// Therefore we don't need to sort out methods by the threadsafeness.
//
// If no method is found, then do lockingForward:
//
struct _mulle_objc_method *
   _MulleObjectRefreshSuperMethodNofail( struct _mulle_objc_class *cls,
                                         mulle_objc_superid_t superid)
{
   struct _mulle_objc_method         *method;
   struct _mulle_objc_impcache       *icache;
   struct _mulle_objc_impcachepivot  *cachepivot;

   method = _mulle_objc_class_supersearch_method( cls, superid);
   if( ! method)
   {
      cachepivot = (struct _mulle_objc_impcachepivot *) &cls->cachepivot;
      icache     = _mulle_objc_impcachepivot_get_impcache_atomic( cachepivot);
      method     = _mulle_atomic_pointer_read( &icache->callback.userinfo);
      if( ! method)
      {
         method  = mulle_objc_class_defaultsearch_method( cls, @selector( __lockingSuperForward:));
         // store this method in the "main" method cache
         _mulle_atomic_pointer_write( &icache->callback.userinfo, method);
      }
   }

   // fill actual class imp cache
   assert( method);
   _mulle_objc_class_fill_impcache_method( cls, method, superid);
   return( method);
}



//
// ## Cache Invalidation
//
// Much too clumsy, should be mostly in
// the runtime.
//
static MULLE_C_NEVER_INLINE
void   MulleObjectSwapInFreshSecondLevelCache( struct _mulle_objc_class *cls,
                                               enum mulle_objc_cachesizing_t strategy)
{
   struct _mulle_objc_impcache       *icache;
   struct _mulle_objc_impcache       *old_cache;
   struct _mulle_objc_impcachepivot  *cachepivot;
   struct _mulle_objc_universe       *universe;
   struct mulle_allocator            *allocator;

   cachepivot = (struct _mulle_objc_impcachepivot *) &cls->userinfo;
   old_cache  = _mulle_objc_impcachepivot_get_impcache_atomic( cachepivot);
   universe   = _mulle_objc_class_get_universe( cls);
   allocator  = _mulle_objc_universe_get_allocator( universe);
   // a new beginning.. let it be filled anew
   // could ask the universe here what to do as new size
   icache     = _mulle_objc_impcache_grow_with_strategy( old_cache, strategy, allocator);

   // if the set fails, then someone else was faster
   if( universe->debug.trace.method_cache)
      mulle_objc_universe_trace( universe,
                                 "new second level method cache %p "
                                 "(%u of %u size used) for %s %08x \"%s\"",
                                 icache,
                                 _mulle_objc_cache_get_count( &icache->cache),
                                 icache->cache.size,
                                 _mulle_objc_class_get_classtypename( cls),
                                 _mulle_objc_class_get_classid( cls),
                                 _mulle_objc_class_get_name( cls));


   assert( _mulle_atomic_pointer_read_nonatomic( &cachepivot->pivot.entries)
            != universe->empty_impcache.cache.entries);
   assert( _mulle_atomic_pointer_read_nonatomic( &cachepivot->pivot.entries)
            != universe->initial_impcache.cache.entries);

   // swaps out current old cache, do we need to ensure that the oldcache is
   // really the one we CAS ? i don't see why
   if( _mulle_objc_impcachepivot_convenient_swap( cachepivot, icache, universe))
   {
      if( universe->debug.trace.method_cache)
         mulle_objc_universe_trace( universe,
                                    "punted tmp second level method cache %p as a new one is available",
                                    icache);

      return;
   }

   if( universe->debug.trace.method_cache)
      mulle_objc_universe_trace( universe,
                                 "swapped old second level method cache %p with new method cache %p",
                                 old_cache,
                                 icache);
}


//
// pass uniqueid = MULLE_OBJC_NO_UNIQUEID, to invalidate all, otherwise we
// only invalidate all, if uniqueid is found
//
int   MulleObjectInvalidateSecondLevelCacheEntry( struct _mulle_objc_class *cls,
                                                  mulle_objc_methodid_t uniqueid)
{
   struct _mulle_objc_cacheentry     *entry;
   struct _mulle_objc_cache          *cache;
   struct _mulle_objc_impcache       *fcache;
   struct _mulle_objc_impcachepivot  *cachepivot;
   mulle_objc_uniqueid_t             offset;

   cachepivot = (struct _mulle_objc_impcachepivot *) &cls->userinfo;
   fcache     = _mulle_objc_impcachepivot_get_impcache_atomic( cachepivot);
   cache      = _mulle_objc_impcache_get_cache( fcache);
   if( ! _mulle_atomic_pointer_read( &cache->n))
      return( 0);

   if( uniqueid != MULLE_OBJC_NO_METHODID)
   {
      assert( mulle_objc_uniqueid_is_sane( uniqueid));

      offset = _mulle_objc_cache_probe_entryoffset( cache, uniqueid);
      entry  = (void *) &((char *) cache->entries)[ offset];

      // no entry is matching, fine
      if( ! entry->key.uniqueid)
         return( 0);
   }

   //
   // if we get NULL, from _mulle_objc_class_add_cacheentry_by_swapping_caches
   // someone else recreated the cache, fine by us!
   //
   MulleObjectSwapInFreshSecondLevelCache( cls, MULLE_OBJC_CACHESIZE_STAGNATE);

   return( 0x1);
}


void  MulleObjectInvalidateSecondLevelCache( struct _mulle_objc_class *cls,
                                             struct _mulle_objc_methodlist *list)
{
   struct _mulle_objc_method   *method;

   // NULL list, clean all uncnditionally
   if( ! list)
   {
      MulleObjectInvalidateSecondLevelCacheEntry( cls, MULLE_OBJC_NO_METHODID);
      return;
   }

   // if caches have been cleaned for class, it's done
   mulle_objc_methodlist_for( list, method)
   {
      if( MulleObjectInvalidateSecondLevelCacheEntry( cls, method->descriptor.methodid))
         break;
   }
}


//
// TODO: Can the two cache levels create a race of some sort ??
//       So that the first level gets filled again, and poisons the second
//       level ?
//
static void   MulleObjectInvalidateCaches( struct _mulle_objc_class *cls,
                                           struct _mulle_objc_methodlist *list)
{
   _mulle_objc_class_invalidate_caches_default( cls, list);

   MulleObjectInvalidateSecondLevelCache( cls, list);
}


void   MulleObjectSetAutolockingEnabled( Class self, BOOL flag)
{
   struct _mulle_objc_infraclass   *infra;
   struct _mulle_objc_class        *cls;

   infra = (struct _mulle_objc_infraclass *) self;
   cls   = _mulle_objc_infraclass_as_class( infra);

   if( flag)
   {
//   // search superclass, but don't inherit anything from myself
//      cls->inheritance |= MULLE_OBJC_CLASS_DONT_INHERIT_CLASS
//                          | MULLE_OBJC_CLASS_DONT_INHERIT_CATEGORIES
//                          | MULLE_OBJC_CLASS_DONT_INHERIT_PROTOCOLS
//                          | MULLE_OBJC_CLASS_DONT_INHERIT_PROTOCOL_CATEGORIES
//                          | MULLE_OBJC_CLASS_DONT_INHERIT_PROTOCOL_META;
//   // since we are clobbering with MULLE_OBJC_CLASS_DONT_INHERIT_PROTOCOL_CATEGORIES
//   // the initialize of MulleObjCThreadSafe won't run, so we do this manually
      _mulle_objc_class_set_state_bit( cls, MULLE_OBJC_CLASS_IS_NOT_THREAD_AFFINE);
   }
   else
   {
//      cls->inheritance &= ~(MULLE_OBJC_CLASS_DONT_INHERIT_CLASS
//                            | MULLE_OBJC_CLASS_DONT_INHERIT_CATEGORIES
//                            | MULLE_OBJC_CLASS_DONT_INHERIT_PROTOCOLS
//                            // | MULLE_OBJC_CLASS_DONT_INHERIT_PROTOCOL_CATEGORIES
//                            | MULLE_OBJC_CLASS_DONT_INHERIT_PROTOCOL_META);
      _mulle_objc_class_clear_state_bit( cls, MULLE_OBJC_CLASS_IS_NOT_THREAD_AFFINE);
   }
}


+ (void) initialize
{
   struct _mulle_objc_impcache                   *fcache;
   struct _mulle_objc_impcachepivot              *cachepivot;
   struct _mulle_objc_class                      *cls;
   struct _mulle_objc_universe                   *universe;
   struct mulle_allocator                        *allocator;
   static struct _mulle_objc_impcache_callback   threadsafe_callback;
   extern struct _mulle_objc_impcache_callback   _mulle_objc_impcache_callback_normal;
   int                                           was_needed;

   if( ! [self conformsToProtocol:@protocol( MulleAutolockingObject)])
      return;

   MulleObjectSetAutolockingEnabled( self, YES);

   cls = _mulle_objc_infraclass_as_class( self);
   if( _mulle_objc_class_get_userinfo( cls))
      return;

   cls->invalidate_caches = MulleObjectInvalidateCaches;

   memcpy( &threadsafe_callback,
           &_mulle_objc_impcache_callback_normal,
           sizeof( threadsafe_callback));

   threadsafe_callback.refresh_method_nofail      = _MulleObjectRefreshMethodNofail,
   threadsafe_callback.refresh_supermethod_nofail = _MulleObjectRefreshSuperMethodNofail,

   // code for +initialize
   // when the cache is swapped, the callbacks of the old cache are
   // copied to the grown instance
   universe  = _mulle_objc_class_get_universe( cls);
   allocator = _mulle_objc_universe_get_allocator( universe);

   // non-threadsafe methods are all others, so we can just use the default
   // lookup, install a cache now
   fcache    = mulle_objc_impcache_new( 128, NULL, allocator);

   cachepivot = (struct _mulle_objc_impcachepivot *) &cls->userinfo;
   _mulle_objc_impcachepivot_convenient_swap( cachepivot, fcache, universe);

   //
   // DO the cache change at the very last moment, so that no Objective-C
   // methods are triggered.
   //
   // setup instance cache code, which will only search for threadsafe
   // methods, class methods are initialized by default code
   was_needed = _mulle_objc_class_setup_initial_cache_if_needed( cls,
                                                                 &threadsafe_callback);
   assert( was_needed);
   MULLE_C_UNUSED( was_needed);
}


+ (void) deinitialize
{
   struct _mulle_objc_impcachepivot   *cachepivot;
   struct _mulle_objc_class           *cls;
   struct _mulle_objc_infraclass      *infra;
   struct _mulle_objc_universe        *universe;

   infra = (struct _mulle_objc_infraclass *) self;
   cls   = _mulle_objc_infraclass_as_class( infra);
   if( ! _mulle_objc_class_get_userinfo( cls))
      return;

   universe   = _mulle_objc_class_get_universe( cls);
   cachepivot = (struct _mulle_objc_impcachepivot *) &cls->userinfo;
   _mulle_objc_impcachepivot_convenient_swap( cachepivot, NULL, universe);

   // memo, how does that get rid of the icache though ?
}


- (void *) __lockingForward:(void *) parameter
{
   return( MulleObjectLockingForward( self, _cmd, parameter));
}


- (void *) __lockingSuperForward:(void *) parameter
{
   return( MulleObjectLockingSuperForward( self, _cmd, parameter));
}


+ (instancetype) locklessObject
{
   id   obj;

   obj = [self instantiate];
   obj = [obj initNoLock];
   return( obj);
}


- (instancetype) initNoLock
{
   self = [super init];

   // This particular object is really single threaded now, so we have to
   // turn it into thread affine until it gains a lock
   _mulle_objc_object_set_thread( (struct _mulle_objc_object *) self, mulle_thread_self());

   return( self);
}


- (instancetype) init
{
   self = [super init];
   __lock = [NSRecursiveLock new];
   return( self);
}



- (void) dealloc
{
   [__lock release];
   [super dealloc];
}



- (void) lock
{
   _MulleObjectLock( self);
}


- (void) unlock
{
   _MulleObjectUnlock( self);
}


- (BOOL) tryLock
{
   return( _MulleObjectTryLock( self));
}


//
// How this looks in "real" life. The MulleObject method dispatcher will always
// unlock the identical lock it used for locking.
//
//  | Action                                         | Shared Lock
//  |------------------------------------------------|--------------------
//  |                                                |    0
//  | > [view doStuff]                               | -> 1
//  |    > [view removeSubview:subview]              | -> 2
//  |        > [subview removeFromSuperview]         | -> 3
//  |           > [subview _removeFromSuperview]     | -> 4
//  |                [subview shareRecursiveLockWithObject:nil] | THREADSAFE
//  |           < [subview _removeFromSuperview]     | -> 3
//  |        < [subview removeFromSuperview]         | -> 2
//  |    < [view removeSubview:subview]              | -> 1
//  | < [view doStuff]                               | -> 0
//
// If we allowed share / share2 lets see what happens:
//
//  | Action                                    | View Lock  | Subview Lock
//  |-------------------------------------------|------------|-------
//  |                                           |    0       |    0
//  | > [view doStuff]                          | -> 1       |
//  |    > [view addSubview:subview]            | -> 2       |
//  |       > [subview willAddToSuperview:view] |            | -> 1
//  |       < [subview willAddToSuperview:view] |            | -> 0
//  |         [subview shareRecursiveLockWithObject:view]  | THREADSAFE |
//  |       > [subview didAddToSuperview:view]  | -> 3       |
//  |       < [subview didAddToSuperview:view]  | -> 2       |
//  |    < [view removeSubview:subview]         | -> 1       |
//  | < [view doStuff]                          | -> 0       |
//
// Looks like its harmless..
//

- (void) didShareRecursiveLock:(NSRecursiveLock *) lock
{
   //
   // if we have no lock (any more), change affinity to current thread
   // otherwise we iz now threadsafe
   //
   _mulle_objc_object_set_thread( (struct _mulle_objc_object *) self, lock
                                        ? mulle_objc_object_is_threadsafe
                                        : mulle_thread_self());
}


- (void) shareRecursiveLock:(NSRecursiveLock *) lock
{
   NSLockingDo( lock)
   {
      if( lock != self->__lock)
      {
         [self->__lock autorelease];
         self->__lock = [lock retain];

         [self didShareRecursiveLock:lock];
      }
   }
}


- (void) shareRecursiveLockWithObject:(MulleObject *) other
{
   [self shareRecursiveLock:other ? other->__lock : nil];
}

@end

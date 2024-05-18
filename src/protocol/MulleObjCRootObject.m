#import "MulleObjCRootObject.h"

#import "import-private.h"

#import "MulleObjCException.h"
#import "MulleObjCExceptionHandler.h"
#import "MulleObjCExceptionHandler-Private.h"
#import "MulleObjCProperty.h"
#import "NSAutoreleasePool.h"
#import "NSMethodSignature.h"
#import "NSThread.h"
#import "mulle-objc-exceptionhandlertable-private.h"
#import "mulle-objc-universefoundationinfo-private.h"


NS_ENUM_TABLE( MulleObjCTAOStrategy, 5) =
{
   NS_ENUM_ITEM( MulleObjCTAOCallerRemovesFromCurrentPool),
   NS_ENUM_ITEM( MulleObjCTAOCallerRemovesFromAllPools),
   NS_ENUM_ITEM( MulleObjCTAOReceiverPerformsFinalize),
   NS_ENUM_ITEM( MulleObjCTAOKnownThreadSafeMethods),
   NS_ENUM_ITEM( MulleObjCTAOKnownThreadSafe)
};


PROTOCOLCLASS_IMPLEMENTATION( MulleObjCRootObject)

+ (instancetype) alloc
{
   return( _MulleObjCClassAllocateInstance( self, 0));
}


+ (instancetype) allocWithZone:(NSZone *) zone
{
   return( _MulleObjCClassAllocateInstance( self, 0));
}


+ (instancetype) new
{
   return( [_MulleObjCClassAllocateInstance( self, 0) init]);
}


- (NSZone *) zone  // always NULL
{
   return( (NSZone *) 0);
}


- (struct mulle_allocator *) mulleAllocator
{
   return( MulleObjCInstanceGetAllocator( self));
}


- (void) mullePerformFinalize
{
   _mulle_objc_object_perform_finalize( self);
}


- (BOOL) mulleIsFinalized
{
   return( _mulle_objc_object_is_finalized( self));
}


- (void) finalize
{
   _MulleObjCInstanceClearProperties( self, NO);
}


- (void) dealloc
{
#if DEBUG
   struct _mulle_objc_universe                 *universe;
   struct _mulle_objc_universefoundationinfo   *config;

   universe = _mulle_objc_object_get_universe( self);
   config   = _mulle_objc_universe_get_universefoundationinfo( universe);

   if( config->object.zombieenabled)
   {
      if( [NSAutoreleasePool mulleCountObject:self] )
         __mulle_objc_universe_raise_internalinconsistency( universe,
                        "deallocing object %p still in autoreleasepool", self);
   }
#endif
   _MulleObjCInstanceFree( self);
}


#pragma mark - lifetime management


//
// this "facility" catches release/autorelease mistakes, but only for
// single threaded programs. For multithreaded one would need to suspend all
// other threads and inspect their autorelease pools as well
//
#ifdef DEBUG
static void   checkAutoreleaseRelease( id self)
{
   struct _mulle_objc_universe                  *universe;
   struct _mulle_objc_universefoundationinfo   *config;

   universe = _mulle_objc_object_get_universe( self);
   config   = _mulle_objc_universe_get_universefoundationinfo( universe);

   if( config->object.zombieenabled)
   {
      NSUInteger   autoreleaseCount;
      NSUInteger   retainCount;

      autoreleaseCount = [NSAutoreleasePool mulleCountObject:self];
      retainCount      = [self retainCount];
      if( autoreleaseCount >= retainCount)
      {
         __mulle_objc_universe_raise_internalinconsistency( universe,
               "object <%s %p> would be autoreleased too often",
                     MulleObjCInstanceGetClassNameUTF8String( self), self);
      }
   }
}
#else
static inline void   checkAutoreleaseRelease( NSObject *self)
{
}
#endif


- (void) release
{
   checkAutoreleaseRelease( self);

   _mulle_objc_object_release_inline( self);
}


- (instancetype) autorelease
{
   checkAutoreleaseRelease( self);

   _MulleObjCAutoreleaseObject( self);
   return( self);
}


- (instancetype) retain
{
   return( (id) mulle_objc_object_retain( (struct _mulle_objc_object *) self));
}


- (NSUInteger) retainCount
{
   return( (NSUInteger) _mulle_objc_object_get_retaincount_notps_noslow( self));
}



//
// do not override these, inherit MulleObjCThreadSafe or optionally
// MulleObjCThreadUnsafe
//
- (BOOL) mulleIsThreadSafe    MULLE_OBJC_THREADSAFE_METHOD
{
   return( NO);  // this is the default, so NSObject itself technically is thread safe
}


// class methods are deemed to be inherently thread safe, because there are
// no variables involved. If you do have state you gotta lock it.
+ (BOOL) mulleIsThreadSafe
{
   return( YES);
}


- (BOOL) mulleIsAccessible
{
   mulle_thread_t   osThread;
   mulle_thread_t   currentOSThread;

   osThread = _mulle_objc_object_get_thread( (struct _mulle_objc_object *) self);
   if( ! osThread)
      return( YES);
   currentOSThread = _NSThreadGetCurrentOSThread();
   return( osThread == currentOSThread);
}


- (BOOL) mulleIsAccessibleByThread:(NSThread *) threadObject
{
   mulle_thread_t   osThread;

   osThread = _mulle_objc_object_get_thread( (struct _mulle_objc_object *) self);
   if( ! osThread)
      return( YES);

   if( ! threadObject)
      threadObject = [NSThread currentThread];
   return( osThread == _NSThreadGetOSThread( threadObject));
}


- (BOOL) mulleIsAutoreleased
{
   return( [NSAutoreleasePool mulleCountObject:self] > 0);
}


//
// There are three kinds of TAO states:
//
//   1. Object belongs to no  threads (osThread == -1) lives in no autoreleasepool
//   2. Object belongs to one thread  (osThread == x)  lives in x's autoreleaspool
//   3. Object belongs to all threads (osThread == 0)  lives in all autoreleasepools (!)
//
// In terms of mulle-objc "always autoreleased" philosophy an object that is
// accessible by a thread, also lives in one of the autoreleasepools of the
// thread.
//
// mulleGainAccess       transitions:  1 -> 2, 3 -> 3
// mulleRelinquishAccess transitions:  2 -> 1, 3 -> 3
//
// A mulleGainAccess needs to be paired with a mulleRelinquishAccess.
//
// The transfer ensures that the object is placed into the autorelease pool
// of the receiving thread. mulleRelinquishAccess retains the object
//

- (id) mulleGainAccess
{
   mulle_thread_t   osThread;
   mulle_thread_t   currentOSThread;

   osThread = _mulle_objc_object_get_thread( (struct _mulle_objc_object *) self);
   if( osThread)
   {
#ifdef DEBUG
      currentOSThread = _NSThreadGetCurrentOSThread();
      if( osThread != (mulle_thread_t) -1)
      {
         // This can happen if you gain an [NSArray arrayWithObjets:foo, foo, nil];
         // So an object could have been already gainedAccess to. This is no
         // problem as the relinquish will have retaied twice also
         if( currentOSThread != osThread)
            MulleObjCThrowInternalInconsistencyExceptionUTF8String( "your thread %p "
                                                                    "can not gain access "
                                                                    "to object %p "
                                                                    "still owned by thread %p",
                                                                    currentOSThread,
                                                                    self,
                                                                    osThread);
      }
#else
      assert( osThread == -1 || currentOSThread == osThread);
#endif
      _mulle_objc_object_set_thread( (struct _mulle_objc_object *) self, currentOSThread);
   }

   // the relinquish will have added a -retain
   return( [self autorelease]);
}


- (void) mulleRelinquishAccessWithTAOStrategy:(MulleObjCTAOStrategy) strategy
{
   mulle_thread_t   osThread;
   mulle_thread_t   currentOSThread;

   [self retain];

   osThread = _mulle_objc_object_get_thread( (struct _mulle_objc_object *) self);
   if( ! osThread)
      return;

   //
   // MEMO: we don't need to make this check in Release
   //       as this is an error that appears during development quickly
#ifdef DEBUG
   currentOSThread = _NSThreadGetCurrentOSThread();
   if( currentOSThread != osThread)
   {
      // This can happen if you relinquish [NSArray arrayWithObjets:foo, foo, nil];
      // So an object could have been already relinquished. This is no problem
      // as the gain will also autorelease it twice
      if( osThread == (mulle_thread_t) -1)
         return;

      MulleObjCThrowInternalInconsistencyExceptionUTF8String( "you're thread %p "
                                                              "does not have access "
                                                              "to this object %p "
                                                              "owned by thread %p",
                                                              currentOSThread,
                                                              self,
                                                              osThread);
   }
#else
   assert( osThread != -1 || currentOSThread == osThread);
#endif
   //
   // add this now, before the object might get removed from current thread
   // autoreleasepool
   //
   switch( strategy)
   {
   case MulleObjCTAOKnownThreadSafe          :
      MulleObjCThrowInternalInconsistencyExceptionUTF8String( "you're assuming object %p "
                                                              "is threadsafe but it has an "
                                                              "affinity to thread %p (indicating it is not)",
                                                              self,
                                                              osThread);
      // the differentations are just for self commenting code
   case MulleObjCTAOKnownThreadSafeMethods   :
      // no way to check this, TAO will catch it
   case MulleObjCTAOReceiverPerformsFinalize :
      break;

   //
   // This should generally not be used over MulleObjCForceAutoreleaseCurrentPool.
   // It indicates that someone is still holding a reference and is likely to
   // fail in the future
   //
   case MulleObjCTAOCallerRemovesFromAllPools :
      [NSAutoreleasePool mulleReleaseObjects:&self
                                       count:1];
      break;

   case MulleObjCTAOCallerRemovesFromCurrentPool :
      [[NSAutoreleasePool mulleDefaultAutoreleasePool] mulleReleaseObjects:&self
                                                                     count:1];
#ifdef DEBUG
      if( [NSAutoreleasePool mulleContainsObject:self])
         MulleObjCThrowInternalInconsistencyExceptionUTF8String( "a parent autoreleasepool is still holding "
                                                                 "a reference to object %p ",
                                                                 self);
#endif
      break;
   }

   _mulle_objc_object_set_thread( (struct _mulle_objc_object *) self, (mulle_thread_t) -1);
}


- (MulleObjCTAOStrategy) mulleTAOStrategy
{
   return( MulleObjCTAOCallerRemovesFromCurrentPool);
}


- (void) mulleRelinquishAccess
{
   MulleObjCTAOStrategy   strategy;

   strategy = [self mulleTAOStrategy];
   [self mulleRelinquishAccessWithTAOStrategy:strategy];
}


# pragma mark - regular methods

- (instancetype) init
{
   return( self);
}


//
// +class loops around to - class
//
- (Class) class
{
   Class  cls;

   cls = _mulle_objc_object_get_infraclass( self);
   return( cls);
}


+ (Class) class
{
   return( self);
//   Class  cls;
//
//   cls = _mulle_objc_object_get_infraclass( self);
//   return( cls);
}


- (Class) superclass
{
   return( _mulle_objc_infraclass_get_superclass( _mulle_objc_object_get_infraclass( self)));
}


// YES if the receiving class is a subclass of—or identical to—aClass, otherwise NO.

+ (BOOL) isSubclassOfClass:(Class) otherClass
{
   return( MulleObjCClassIsSubclassOfClass( self, otherClass));
}


- (BOOL) isKindOfClass:(Class) otherClass
{
   return( NSObjectIsKindOfClass( self, otherClass));
}


+ (BOOL) isMemberOfClass:(Class) otherClass
{
   return( NO);  // seemingly the most compatible implementation...
}


- (BOOL) isMemberOfClass:(Class) otherClass
{
   return( MulleObjCInstanceIsMemberOfClass( self, otherClass));
}


#pragma mark - protocol introspection

- (BOOL) mulleContainsProtocol:(PROTOCOL) protocol
{
   struct _mulle_objc_class       *cls;
   struct _mulle_objc_classpair   *pair;

   cls  = _mulle_objc_object_get_isa( self);
   pair = _mulle_objc_class_get_classpair( cls);
   return( (BOOL) _mulle_objc_classpair_has_protocolid( pair,
                                                        (mulle_objc_protocolid_t) protocol));
}


- (BOOL) conformsToProtocol:(PROTOCOL) protocol
{
   struct _mulle_objc_class       *cls;
   struct _mulle_objc_classpair   *pair;

   // we know that these calls are meaningless,
#ifndef NDEBUG
   if( protocol == @protocol( MulleObjCThreadSafe) ||
       protocol == @protocol( MulleObjCThreadUnsafe))
   {
      fprintf( stderr, "-conformsToProtocol:@protocol( MulleObjCThreadSafe) (or MulleObjCThreadUnsafe) is not doing what you want\n");
   }
#endif

   cls  = _mulle_objc_object_get_isa( self);
   pair = _mulle_objc_class_get_classpair( cls);
   return( (BOOL) _mulle_objc_classpair_conformsto_protocolid( pair,
                                                              (mulle_objc_protocolid_t) protocol));
}


#pragma mark - method introspection


- (BOOL) respondsToSelector:(SEL) sel
{
   struct _mulle_objc_class   *cls;
   IMP                        imp;

   // OS X compatible
   if( ! sel)
      return( NO);

   cls = _mulle_objc_object_get_isa( self);
   imp = (IMP) _mulle_objc_class_lookup_implementation_noforward( cls,
                                                                  (mulle_objc_methodid_t) sel);
   return( imp ? YES : NO);
}


- (IMP) methodForSelector:(SEL) sel
{
   // this produces NSInvalidArgumentException on OS X for (SEL) 0
   return( (IMP) _mulle_objc_object_lookup_implementation( (void *) self,
                                                           (mulle_objc_methodid_t) sel));
}


+ (BOOL) instancesRespondToSelector:(SEL) sel
{
   struct _mulle_objc_class   *cls;
   IMP                        imp;

   // OS X compatible
   if( ! sel)
      return( NO);

   //
   // must be non caching for technical reasons (them being)
   // that the infraclass cache may not be ready yet
   //
   cls = _mulle_objc_infraclass_as_class( self);
   imp = (IMP) _mulle_objc_class_lookup_implementation_noforward_nofill( cls,
                                                                          (mulle_objc_methodid_t) sel);
   return( imp ? YES : NO);
}


+ (IMP) instanceMethodForSelector:(SEL) sel
{
   struct _mulle_objc_class   *cls;

   // this produces NSInvalidArgumentException on OS X for (SEL) 0

   //
   // must be non refreshing for technical reasons (them being,
   // that the infraclass cache may not be ready yet)
   //
   cls = _mulle_objc_infraclass_as_class( self);
   return( (IMP) _mulle_objc_class_lookup_implementation_nofill( cls,
                                                                  (mulle_objc_methodid_t) sel));
}


- (NSMethodSignature *) methodSignatureForSelector:(SEL) sel
{
   struct _mulle_objc_class    *cls;
   struct _mulle_objc_method   *method;

   // OS X compatible
   if( ! sel)
      return( nil);

   cls    = _mulle_objc_object_get_isa( self);
   method = mulle_objc_class_defaultsearch_method( cls,
                                                  (mulle_objc_methodid_t) sel);
   if( ! method)
      return( nil);

   return( [NSMethodSignature _signatureWithObjCTypes:method->descriptor.signature
                                       descriptorBits:method->descriptor.bits]);
}


+ (NSMethodSignature *) instanceMethodSignatureForSelector:(SEL) sel
{
   struct _mulle_objc_method   *method;

   // OS X compatible
   if( ! sel)
      return( nil);

   assert( _mulle_objc_class_is_infraclass( (void *)  self));
   method = mulle_objc_class_defaultsearch_method( _mulle_objc_infraclass_as_class( self),
                                                   (mulle_objc_methodid_t) sel);
   if( ! method)
      return( nil);

   return( [NSMethodSignature signatureWithObjCTypes:method->descriptor.signature]);
}


#pragma mark - method performs

- (id) performSelector:(SEL) sel
{
   return( mulle_objc_object_call_variable_inline( self,
                                                           (mulle_objc_methodid_t) sel,
                                                           (void *) self));
}


- (id) performSelector:(SEL) sel
            withObject:(id) obj
{
   return( mulle_objc_object_call_variable_inline( self,
                                                           (mulle_objc_methodid_t) sel,
                                                           (void *) obj));
}


/* this is pretty much the worst case for the META-ABI,
   since we need to extract sel from _param and have to alloca and reshuffle
   everything
 */
- (id) performSelector:(SEL) sel
            withObject:(id) obj1
            withObject:(id) obj2
{
   mulle_metaabi_union( id,
                         struct
                         {
                             id   obj1;
                             id   obj2;
                         }) param;

   param.p.obj1 = obj1;
   param.p.obj2 = obj2;

   return( mulle_objc_object_call_variable_inline( self,
                                                           (mulle_objc_methodid_t) sel,
                                                           &param));
}


//
// somewhat negelected code zone
//
#pragma mark - universe owned objects

+ (NSUInteger) _getRootObjects:(id *) buf
                      maxCount:(NSUInteger) maxCount
{
   struct _mulle_objc_universefoundationinfo   *config;
   struct _mulle_objc_universe                 *universe;
   NSUInteger                                  count;
   struct mulle_setenumerator                  rover;
   id                                          obj;
   id                                          *sentinel;

   universe = _mulle_objc_infraclass_get_universe( self);

   _mulle_objc_universe_lock( universe);
   {
      _mulle_objc_universe_get_foundationspace( universe, (void **) &config, NULL);

      count    = mulle_set_get_count( config->object.roots);
      sentinel = &buf[ count < maxCount ? count : maxCount];

      rover = mulle_set_enumerate( config->object.roots);
      while( buf < sentinel)
      {
         mulle_setenumerator_next( &rover, (void **) &obj);
         assert( obj);
         *buf++ = obj;
      }
      mulle_setenumerator_done( &rover);
   }
   _mulle_objc_universe_unlock( universe);

   return( count);
}


- (BOOL) _isRootObject
{
   struct _mulle_objc_universefoundationinfo   *config;
   struct _mulle_objc_universe                 *universe;
   struct mulle_setenumerator                  rover;
   id                                          obj;

   universe = _mulle_objc_object_get_universe( self);
   obj      = nil;

   _mulle_objc_universe_lock( universe);
   {
      _mulle_objc_universe_get_foundationspace( universe, (void **) &config, NULL);

      rover = mulle_set_enumerate( config->object.roots);
      while( mulle_setenumerator_next( &rover, (void **) &obj))
      {
         if( obj == self)
            break;
      }
      mulle_setenumerator_done( &rover);
   }
   _mulle_objc_universe_unlock( universe);

   return( obj ? YES : NO);
}


- (id) _becomeRootObject
{
   struct _mulle_objc_universe   *universe;

   if( _mulle_objc_object_is_constant( self))
      return( self);

   assert( ! [self _isRootObject]);

   self = [self retain];
   universe = _mulle_objc_object_get_universe( self);
   _mulle_objc_universe_add_rootobject( universe, self);
   return( self);
}


- (id) _resignAsRootObject
{
   struct _mulle_objc_universe   *universe;

   if( _mulle_objc_object_is_constant( self))
      return( self);

   universe = _mulle_objc_object_get_universe( self);
   _mulle_objc_universe_remove_rootobject( universe, self);
   return( [self autorelease]);
}


- (id) _pushToParentAutoreleasePool
{
   NSAutoreleasePool   *pool;

   pool = [NSAutoreleasePool mulleParentAutoreleasePool];
   if( pool)
   {
      [self retain];
      [pool addObject:self];
      return( self);
   }

   return( [self _becomeRootObject]);
}


// neglected code zone
#pragma mark - walk object graph support

struct collect_info
{
   id           self;
   NSUInteger   n;
   id           *objects;
   id           *sentinel;
};


static int   collect( struct _mulle_objc_ivar *ivar,
                      struct _mulle_objc_class *cls,
                      struct collect_info *info)
{
   char  *signature;

   signature = _mulle_objc_ivar_get_signature( ivar);
   switch( *signature)
   {
   case _C_RETAIN_ID :
   case _C_COPY_ID   :
      if( info->objects < info->sentinel)
      {
         *info->objects = _mulle_objc_object_get_pointervalue_for_ivar( info->self, ivar);
         if( *info->objects)
            info->objects++;
      }
      ++info->n;
   }
   return( 0);
}


+ (NSUInteger) _getOwnedObjects:(id *) objects
                       maxCount:(NSUInteger) maxCount
{
   return( 0);
}


- (NSUInteger) _getOwnedObjects:(id *) objects
                       maxCount:(NSUInteger) maxCount
{
   struct _mulle_objc_class   *cls;
   struct collect_info        info;

   assert( (! objects && ! maxCount) || objects);

   info.self     = self;
   info.n        = 0;
   info.objects  = objects;
   info.sentinel = &objects[ maxCount];

   cls = _mulle_objc_object_get_isa( self);
   if( _mulle_objc_class_is_metaclass( cls))
   {
      // could actually put class vars in maybe ?
      return( 0);
   }
   _mulle_objc_infraclass_walk_ivars( _mulle_objc_class_as_infraclass( cls),
                                      _mulle_objc_class_get_inheritance( cls),
                                      (int (*)()) collect,
                                      &info);
   return( info.n);
}


PROTOCOLCLASS_END();
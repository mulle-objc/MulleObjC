//
//  NSThread.m
//  MulleObjC
//
//  Copyright (c) 2011 Nat! - Mulle kybernetiK.
//  Copyright (c) 2011 Codeon GmbH.
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
#import "import-private.h"

#import "NSThread.h"

// other files in this library
#import "mulle-objc-type.h"
#import "MulleObjCAllocation.h"
#import "MulleObjCIntegralType.h"
#import "MulleObjCExceptionHandler.h"
#import "MulleObjCExceptionHandler-Private.h"
#import "NSAutoreleasePool.h"
#import "NSInvocation.h"
#import "mulle-objc-exceptionhandlertable-private.h"
#import "mulle-objc-universefoundationinfo-private.h"

// std-c and dependencies
#include <stdlib.h>


#pragma clang diagnostic ignored "-Wobjc-root-class"
#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"



@implementation NSThread


MULLE_OBJC_DEPENDS_ON_CLASS( NSAutoreleasePool);

static struct
{
   mulle_thread_mutex_t    _lock;
   BOOL                    _isMultiThreaded;
} Self;


// this is usually the very first ObjC method call, so assert a little
+ (void) load
{
   struct _mulle_objc_universe  *universe;

   assert( self);
   assert( _cmd == @selector( load));

   mulle_thread_mutex_init( &Self._lock);

   universe = _mulle_objc_infraclass_get_universe( self);
   assert( universe);

   _MulleThreadCreateMainThreadObjectInUniverse( universe);
}


+ (void) unload
{
   mulle_thread_mutex_done( &Self._lock);
}


+ (instancetype) mulleThreadWithInvocation:(NSInvocation *) invocation
{
   NSThread   *threadObject;

   threadObject = [self alloc];
   threadObject = [threadObject mulleInitWithInvocation:invocation];
   threadObject = [threadObject autorelease];
   return( threadObject);
}


+ (instancetype) mulleThreadWithTarget:(id) target
                              selector:(SEL) sel
                                object:(id) object
{
   NSThread   *threadObject;

   threadObject = [self alloc];
   threadObject = [threadObject initWithTarget:target
                                selector:sel
                                  object:object];
   threadObject = [threadObject autorelease];
   return( threadObject);
}


/*
 */
- (id) init
{
   _mulle_map_init( &self->_map,
                    0,
                    (void *) &_MulleObjCContainerCopyCStringKeyRetainValueCallback,
                    MulleObjCInstanceGetAllocator( self));
   return( self);
}



- (instancetype) initWithTarget:(id) target
                       selector:(SEL) sel
                         object:(id) object
{
   NSInvocation   *invocation;

   invocation = [NSInvocation mulleInvocationWithTarget:target
                                               selector:sel
                                                 object:object];
   [invocation retainArguments];

   return( [self mulleInitWithInvocation:invocation]);
}


- (instancetype) mulleInitWithInvocation:(NSInvocation *) invocation
{
   // for subclasses
   self = [self init];

   self->_invocation = [invocation retain];

   return( self);
}


- (instancetype) mulleInitWithFunction:(MulleThreadFunction_t) f
                              argument:(void *) argument
{
   if( ! f)
      __mulle_objc_universe_raise_invalidargument( _mulle_objc_object_get_universe( self),
                                                   "function must not be nil");
   // for subclasses
   self = [self init];

   self->_function         = f;
   self->_functionArgument = argument;

   return( self);
}


- (void) finalize
{
   id   runLoop;

   runLoop = [self mulleRunLoop];
   _mulle_atomic_pointer_write_nonatomic( &self->_runLoop, nil);

   [runLoop mullePerformFinalize];
   [runLoop autorelease];

   mulle_map_done( &self->_map);

   [self->_userInfo autorelease];
   self->_userInfo = nil;

   [self->_invocation autorelease];
   self->_invocation = nil;

   [super finalize];
}


- (void) dealloc
{
   assert( ! [self mulleRunLoop]);
   assert( ! self->_userInfo);

   MulleObjCInstanceDeallocateMemory( self, _nameUTF8String);
   _MulleObjCInstanceFree( self);
}


//static inline void  _NSThreadClearOSThread( NSThread *threadObject)
//{
//   _mulle_atomic_pointer_write( &threadObject->_osThread, NULL);
//}


// MEMO: this is only atomic because it will be set by both threads for
//       consistency in both threads
static inline void  _NSThreadSetOSThread( NSThread *threadObject, mulle_thread_t thread)
{
   _mulle_atomic_pointer_cas( &threadObject->_osThread, (void *) thread, NULL);
}


/*
 * setup ABA gc for thread
 * bond to universe by retaining it
 */
static void   _mulle_objc_thread_become_universethread( struct _mulle_objc_universe  *universe)
{
   struct _mulle_objc_universefoundationinfo  *info;

   //
   // the universe may have done this already for us if we are the
   // "main" thread
   //
   assert( mulle_thread_self() != _mulle_objc_universe_get_thread( universe));

   _mulle_objc_universe_retain( universe);

   // during the main thread bang, this is already done
   mulle_objc_thread_setup_threadinfo( universe);
   _mulle_objc_thread_register_universe_gc( universe);

   // for some ridiculous compatibility with Apple
   info = _mulle_objc_universe_get_universefoundationinfo( universe);
   _mulle_atomic_pointer_increment( &info->thread.n_threads);
   info->thread.was_multi_threaded = YES;
}


static void
   _mulle_objc_thread_resignas_universethread( struct _mulle_objc_universe *universe,
                                               BOOL unset)
{
   struct _mulle_objc_universefoundationinfo   *info;

   //
   // the universe will do this, if we are the
   // "main" thread
   //
   assert( mulle_thread_self() != _mulle_objc_universe_get_thread( universe));
   _mulle_objc_thread_remove_universe_gc( universe);
   if( unset)
      mulle_objc_thread_unset_threadinfo( universe);      // can't call Objective-C anymore

   info = _mulle_objc_universe_get_universefoundationinfo( universe);
   _mulle_atomic_pointer_decrement( &info->thread.n_threads);
   _mulle_objc_universe_release( universe);
}


// this is used by mulle_objc_thread_get_threadfoundationinfo to create
// a new NSThread on demand if needed
static void   _MulleThreadRegisterInUniverse( NSThread *threadObject,
                                              struct _mulle_objc_universe *universe)
{
   _mulle_objc_universe_add_threadobject( universe, threadObject); // does not retain
   _mulle_objc_thread_set_threadobject( universe, threadObject);   // this owns it!
}


static void   _MulleThreadDeregisterInUniverse( NSThread *threadObject,
                                                struct _mulle_objc_universe *universe)
{
   assert( _NSThreadGetOSThread( threadObject) == mulle_thread_self());

   _mulle_objc_universe_remove_threadobject( universe, threadObject); // does not retain
   _mulle_objc_thread_set_threadobject( universe, NULL);   // this owns it!
}


/*
 *
 */
NSThread   *_MulleThreadGetCurrentThreadObjectInUniverse( struct _mulle_objc_universe *universe)
{
   NSThread                                    *threadObject;
   struct _mulle_objc_universefoundationinfo   *info;

   info          = _mulle_objc_universe_get_universefoundationinfo( universe);
   threadObject  = _mulle_objc_universefoundationinfo_get_mainthreadobject( info);
   return( threadObject);
}


static NSThread   *__MulleThreadCreateThreadObjectInUniverse( struct _mulle_objc_universe *universe)
{
   NSThread   *threadObject;

   threadObject = [NSThread new];
   _mulle_atomic_pointer_write_nonatomic( &threadObject->_osThread, (void *) mulle_thread_self());

   //
   // create pool configuration, ahead of register so it can
   // send a notification
   //
   [NSAutoreleasePool class];
//   assert( mulle_objc_universe_lookup_infraclass_nofail( universe, @selector( NSAutoreleasePool)));
   mulle_objc_thread_new_poolconfiguration( universe);

   _MulleThreadRegisterInUniverse( threadObject, universe);

   return( threadObject);
}


NSThread   *_MulleThreadCreateThreadObjectInUniverse( struct _mulle_objc_universe *universe)
{
   _mulle_objc_thread_become_universethread( universe);
   return( __MulleThreadCreateThreadObjectInUniverse( universe));
}


void   _MulleThreadRemoveThreadObjectFromUniverse( NSThread *threadObject,
                                                   struct _mulle_objc_universe *universe)
{
#ifndef NDEBUG
   mulle_thread_t   thread;

   thread = _NSThreadGetOSThread( threadObject);
   assert( thread == mulle_thread_self());
   assert( thread != _mulle_objc_universe_get_thread( universe));
#endif
   _MulleThreadDeregisterInUniverse( threadObject, universe);
   [threadObject release];

   mulle_objc_thread_done_poolconfiguration( universe);

   _mulle_objc_thread_resignas_universethread( universe, YES);
}


/*
 * main thread is different
 */
NSThread   *_MulleThreadCreateMainThreadObjectInUniverse( struct _mulle_objc_universe *universe)
{
   NSThread                                    *threadObject;
   struct _mulle_objc_universefoundationinfo   *info;

   info = _mulle_objc_universe_get_universefoundationinfo( universe);
   if( _mulle_atomic_pointer_read_nonatomic( &info->thread.n_threads))
      __mulle_objc_universe_raise_internalinconsistency( universe, \
         "Universe %p is still or already multithreaded", universe);

   // universe thread is already existant, so just put up NSThread
   // and NSAutoreleasePool

   threadObject = __MulleThreadCreateThreadObjectInUniverse( universe);
   _mulle_objc_universefoundationinfo_set_mainthreadobject( info, threadObject); // does not retain

   return( threadObject);
}


//
// this can only be called during crunch time!
// it will autorelase the runloop and the thread dictionary
//
void   _MulleThreadFinalizeMainThreadObjectInUniverse( struct _mulle_objc_universe *universe)
{
   NSThread   *threadObject;

   threadObject = _MulleThreadGetMainThreadObjectInUniverse( universe);
   [threadObject mullePerformFinalize]; // [self finalize]
}


// this can only be called during crunch time!
void   _MulleThreadResignAsMainThreadObjectInUniverse( struct _mulle_objc_universe *universe)
{
   NSThread                                    *threadObject;
   struct _mulle_objc_universefoundationinfo   *info;

   threadObject = _MulleThreadGetMainThreadObjectInUniverse( universe);
   if( ! threadObject)
      return;

   if( _mulle_objc_universe_get_version( universe) != mulle_objc_universe_is_deinitializing)
      mulle_objc_universe_fail_inconsistency( universe,
         "_MulleThreadResignAsMainThreadObjectInUniverse can only be called inside the crunch");

   assert( _NSThreadGetOSThread( threadObject) == mulle_thread_self());
   assert( _NSThreadGetOSThread( threadObject) == _mulle_objc_universe_get_thread( universe));
   assert( [threadObject retainCount] == 1);

   _MulleThreadDeregisterInUniverse( threadObject, universe);
   [threadObject release];

   // we don't resign as universe thread, just pop the pools
   mulle_objc_thread_done_poolconfiguration( universe);

   info = _mulle_objc_universe_get_universefoundationinfo( universe);
   _mulle_objc_universefoundationinfo_set_mainthreadobject( info, NULL);
}


//
// this is a special function only to be called during universe teardown
//
NSThread   *_MulleThreadGetMainThreadObjectInUniverse( struct _mulle_objc_universe *universe)
{
   NSThread   *threadObject;

   if( ! universe)
      return( NULL);

   //
   // can happen in mulle-objc-list, that NSThread isn't really
   // there
   //
   if( ! _mulle_objc_universe_lookup_infraclass( universe, @selector( NSThread)))
      return( NULL);

   threadObject = _mulle_objc_thread_get_threadobject( universe);
   if( ! threadObject)
   {
      // i mean it's bad, but we are probably going down anyway
#if DEBUG
      fprintf( stderr, "*** Main thread was never set up. +[NSThread load] did not run!***\n");
#endif
      return( NULL);
   }

   assert( ! [NSThread mulleIsMultiThreaded]);

   return( threadObject);
}


void   _mulle_objc_threadinfo_destructor( struct _mulle_objc_threadinfo *info,
                                          void *foundationspace)
{
   NSThread                      *threadObject;
   struct _mulle_objc_universe   *universe;
   mulle_thread_tss_t            threadkey;

   threadObject = _mulle_objc_threadinfo_get_threadobject( info);
   if( ! threadObject)
      return;

   //
   // mulle_thread_tss_set is legal! according to:
   // https://pubs.opengroup.org/onlinepubs/9699919799/functions/pthread_setspecific.html
   // and
   // https://en.cppreference.com/w/c/thread/tss_set
   // we "reenable" our config, to be reachable so that NSThread currentThread
   // et al. works
   //
   universe  = _mulle_objc_threadinfo_get_universe( info);
   threadkey = _mulle_objc_universe_get_threadkey( universe);
   mulle_thread_tss_set( threadkey, info);

   _MulleThreadDeregisterInUniverse( threadObject, universe);
   [threadObject release];

   mulle_objc_thread_done_poolconfiguration( universe);

   _mulle_objc_thread_resignas_universethread( universe, NO);

   mulle_thread_tss_set( threadkey, NULL);
}



// called by bouncyBounce
- (void) main
{
   _rval = -1;  // just in case :)

   if( _function)
   {
      _rval = (*_function)( self, _functionArgument);
      return;
   }

   // bouncyBounce has made _invocation accessible
   [self->_invocation invoke];
}


// called via -mulleStartUndetachedWithTAOStrategy:
static mulle_thread_rval_t   bouncyBounce( void *arg)
{
   NSThread                      *self = arg;
   struct _mulle_objc_universe   *universe;

   // it's not sure that this is already set, depends if thread or caller
   // comes first
   _NSThreadSetOSThread( self, mulle_thread_self());

   universe = _mulle_objc_object_get_universe( self);

   // we are in the "naked" thread, but we already have a threadObject
   // so register this thread to be able to to ObjC calls
   _mulle_objc_thread_become_universethread( universe);

   //
   // create pool configuration, ahead of register so it can
   // send a notification
   //
   [NSAutoreleasePool class];

//   assert( mulle_objc_universe_lookup_infraclass_nofail( universe, @selector( NSAutoreleasePool)));
   mulle_objc_thread_new_poolconfiguration( universe);

   // make threadObject known to universe and thread
   _MulleThreadRegisterInUniverse( self, universe);

   // the caller will have retained it on our behalf already once,
   // so reduce this again, and also the thread count now
   //
   // for a short moment, the number of threads will be one too high
   // but its important so you don get races if you are polling
   // +mulleIsMultiThreaded
   //
   _mulle_objc_universe_release( universe);

   //
   // Our userinfo needs to be affine to the current thread. We can't put
   // stuff in there "from" the outside, so it has to be empty before the
   // start
   //
   assert( ! self->_userInfo);

   [self->_invocation mulleGainAccess];
   [self main];

   [NSThread exit];

   mulle_thread_return();
}


- (void) mulleStartUndetachedWithTAOStrategy:(MulleObjCTAOStrategy) strategy
{
   struct _mulle_objc_universe                 *universe;
   struct _mulle_objc_universefoundationinfo   *info;
   mulle_thread_t                              thread;
   intptr_t                                    n_threads;

   universe = _mulle_objc_object_get_universe( self);
   if( _NSThreadGetOSThread( self))
      __mulle_objc_universe_raise_internalinconsistency( universe, "thread already running");

   //
   // main thread is not counted anymore
   //
   info      = _mulle_objc_universe_get_universefoundationinfo( universe);
   n_threads = (intptr_t) _mulle_atomic_pointer_read( &info->thread.n_threads);
   if( n_threads == 0)
      [self __isGoingMultiThreaded];

   //
   // retain self and universe for bouncyBounce
   //
   [self retain];
   _mulle_objc_universe_retain( universe);

   [self->_invocation mulleRelinquishAccess];

   if( mulle_thread_create( bouncyBounce, self, &thread))
   {
      // undo this
      _mulle_objc_universe_release( universe);
      [self release];

      __mulle_objc_universe_raise_errno( universe, "thread creation");
   }

   // we can not be sure thread has done this already, but we want to
   // be up-to-date
   _NSThreadSetOSThread( self, thread);

   if( universe->debug.trace.thread)
      mulle_objc_universe_trace( universe, "%p started thread %p", mulle_thread_self(), thread);
}


- (void) mulleStartUndetached
{
   MulleObjCTAOStrategy   strategy;

   strategy = [MulleObjCObjectGetClass( self) mulleTAOStrategy];
   [self mulleStartUndetachedWithTAOStrategy:strategy];
}


- (void) start
{
   [self mulleStartUndetached];
   [self mulleDetach];
}



/*
 * this is called when a threadinfo is put up
 * on behalf of foundation we install our destructor Fhere
 * we could do a lot more though.... maybe later
 *
 */
void  _mulle_objc_threadinfo_initializer( struct _mulle_objc_threadinfo *config)
{
   config->foundation_destructor = &_mulle_objc_threadinfo_destructor;
}


//
// not 100% compatible to Apple, where this flag is "sticky"
//
+ (BOOL) isMultiThreaded
{
   BOOL   flag;

   mulle_thread_mutex_lock( &Self._lock);
   {
      flag = Self._isMultiThreaded;
   }
   mulle_thread_mutex_unlock( &Self._lock);
   return( flag);
}


- (void) _isProbablyGoingSingleThreaded
{
}


- (void) __isProbablyGoingSingleThreaded
{
   //
   // but still multi-threaded ATM (!)
   // another thread could be starting up right now from the main thread
   // also some thread destructors might be running
   //
   mulle_thread_mutex_lock( &Self._lock);
   {
      if( Self._isMultiThreaded)
      {
         Self._isMultiThreaded = NO;
         [self _isProbablyGoingSingleThreaded];
      }
   }
   mulle_thread_mutex_unlock( &Self._lock);
}



- (void) _isGoingMultiThreaded
{
}


- (void) __isGoingMultiThreaded
{
   //
   // when a notification fires here, it's for "technical" purposes still
   // single threaded. We serialize here, so that other threads don't
   // overtake us.
   //
   mulle_thread_mutex_lock( &Self._lock);
   {
      if( ! Self._isMultiThreaded)
      {
         Self._isMultiThreaded = YES;
         [self _isGoingMultiThreaded];
      }
   }
   mulle_thread_mutex_unlock( &Self._lock);
}


- (void) _threadWillExit
{
   // this will be done later by someone else
   // [[NSNotificationCenter defaultCenter]
   //    postNotificationName:NSThreadWillExitNotification
   //                  object:[NSThread currentThread]];
}


- (BOOL) wasAutocreated
{
   return( _invocation == nil);
}


- (id) mulleRunLoop
{
   return( _mulle_atomic_pointer_read( &self->_runLoop));
}


void   MulleThreadSetCurrentThreadUserInfo( id info)
{
   NSThread   *threadObject;

   // doing this for a finalized thread is not good

   threadObject = MulleThreadGetCurrentThread();
   assert( ! info || ! _mulle_objc_object_is_finalized( threadObject));
   assert( ! info || [info mulleIsAccessibleByThread:threadObject]);

   [threadObject->_userInfo autorelease];
   threadObject->_userInfo = [info retain];
}


- (id) mulleSetRunLoop:(id) runLoop
{
   id   otherRunloop;

   assert( ! runLoop || [runLoop mulleIsAccessibleByThread:self]);
   [runLoop retain];
   otherRunloop = __mulle_atomic_pointer_compare_and_swap( &self->_runLoop, runLoop, NULL);
   if( otherRunloop)
   {
      [runLoop autorelease];
      return( otherRunloop);
   }
   return( runLoop);
}


- (char *) mulleNameUTF8String
{
   char  *s;

   s = _mulle_atomic_pointer_read( &_nameUTF8String);
   return( s ? s : "unnamed");
}


- (void) mulleSetNameUTF8String:(char *) s
{
   struct mulle_allocator       *allocator;
   struct _mulle_objc_universe  *universe;
   void                         *actual;
   void                         *old;

   // need universe allocator for abafree
   universe  = _mulle_objc_object_get_universe( self);
   allocator = _mulle_objc_universe_get_allocator( universe);
   old       = _mulle_atomic_pointer_read( &_nameUTF8String);
   if( s)
      s = mulle_allocator_strdup( allocator, s);

   actual = __mulle_atomic_pointer_cas( &_nameUTF8String, s, old);

   if( actual == old)
      mulle_allocator_abafree( allocator, old);
   else
      mulle_allocator_free( allocator, s);
}


- (char *) UTF8String
{
   Class   cls;
   char    *s;

   s = _mulle_atomic_pointer_read( &_nameUTF8String);
   if( s)
      return( s);

   cls = [self class];
   if( [cls mainThread] == self)
      return( "NSMainThread");
   return( MulleObjC_asprintf( "<%s %p>", MulleObjCClassGetNameUTF8String( cls), self));
}


- (char *) colorizerPrefixUTF8String
{
   Class       cls;
   char        *result;
   char        *s;
   uintptr_t   hash;
   int         color;

   cls = [self class];
   if( [cls mainThread] == self)
      return( "\033[38;5;2m");

   // use a random color for this thread, thats not blackish or whitish
   // based on pointer address, it would be better to

   s = [self mulleNameUTF8String];
   if( s)
      hash = _mulle_string_hash( s);
   else
      hash  = mulle_pointer_hash( self);

   color  = (hash % (230 - 22)) + 22;
   mulle_asprintf( &result, "\033[38;5;%dm", color);;

   return( MulleObjCAutoreleaseAllocation( result, NULL));
}


+ (NSThread *) mainThread
{
   NSThread                                    *threadObject;
   struct _mulle_objc_universe                 *universe;
   struct _mulle_objc_universefoundationinfo   *info;

   universe     = _mulle_objc_infraclass_get_universe( self);
   info         = _mulle_objc_universe_get_universefoundationinfo( universe);
   threadObject = _mulle_objc_universefoundationinfo_get_mainthreadobject( info);
   return( threadObject);
}


+ (BOOL) mulleIsMainThread
{
   NSThread                                    *threadObject1;
   NSThread                                    *threadObject2;
   struct _mulle_objc_universe                 *universe;
   struct _mulle_objc_universefoundationinfo   *info;

   universe      = _mulle_objc_infraclass_get_universe( self);
   info          = _mulle_objc_universe_get_universefoundationinfo( universe);
   threadObject1 = _mulle_objc_universefoundationinfo_get_mainthreadobject( info);
   threadObject2 = _mulle_objc_thread_get_threadobject( universe);

   return( threadObject2 && threadObject1 == threadObject2);
}


+ (NSThread *) currentThread
{
   struct _mulle_objc_universe   *universe;

   universe = _mulle_objc_infraclass_get_universe( self);
   return( _mulle_objc_thread_get_threadobject( universe));
}


+ (BOOL) mulleMainThreadWaitsAtExit
{
   struct _mulle_objc_universe   *universe;

   universe = _mulle_objc_infraclass_get_universe( self);
   return( universe->config.wait_threads_on_exit);
}


+ (void) mulleSetMainThreadWaitsAtExit:(BOOL) flag
{
   struct _mulle_objc_universe   *universe;
   void
      __mulle_objc_universe_atexit_ifneeded( struct _mulle_objc_universe *universe);

   universe = _mulle_objc_infraclass_get_universe( self);
   // you can't flip/flop this, because we currently don't remove the
   // atexit handler.
   assert( ! universe->config.wait_threads_on_exit);

   universe->config.wait_threads_on_exit = flag;
   if( flag)
      __mulle_objc_universe_atexit_ifneeded( universe);
}


/*
   The pthread_detach() function marks the thread identified by thread as
   detached.  When a detached thread terminates, its resources are
   automatically released back to the system without the need for another
   thread to join with the terminated thread.
   Once a thread has been detached, it can't be joined with pthread_join(3) or
   be made joinable again.
*/
- (void) mulleDetach
{
   self->_isDetached = YES;
   mulle_thread_detach( _NSThreadGetOSThread( self));
}


/*
   The pthread_join() function waits for the thread specified by thread to
   terminate.  If that thread has already terminated, then pthread_join()
   returns immediately. The thread specified by thread must be joinable.
*/
- (void) mulleJoin
{
   struct _mulle_objc_universe   *universe;

   if( self->_isDetached)
   {
      universe = _mulle_objc_object_get_universe( self),
      __mulle_objc_universe_raise_internalinconsistency( universe,
                        "can't join a detached thread. Use -mulleStartUndetachedWithTAOStrategy:");
   }
   mulle_thread_join( _NSThreadGetOSThread( self));
}


- (int) mulleReturnStatus
{
   return( _rval);
}


- (BOOL) isCancelled
{
   return( _mulle_atomic_pointer_read( &_cancelled) == (void *) 1);
}


// TODO: figure out how to do pthread_cancel in windows, then maybe use it
//       instead
- (void) cancel
{
   _mulle_atomic_pointer_write( &_cancelled, (void *) 1);
}


+ (void) detachNewThreadSelector:(SEL) sel
                        toTarget:(id) target
                      withObject:(id) argument
{
   NSThread   *threadObject;

   threadObject = [NSThread alloc];
   threadObject = [threadObject initWithTarget:target
                                      selector:sel
                                        object:argument];
   threadObject = [threadObject autorelease];

   [threadObject start];
}


+ (void) mulleDetachNewThreadWithInvocation:(NSInvocation *) invocation
{
   NSThread   *threadObject;

   threadObject = [NSThread alloc];
   threadObject = [threadObject mulleInitWithInvocation:invocation];
   threadObject = [threadObject autorelease];

   [threadObject start];
}



+ (void) mulleDetachNewThreadWithFunction:(MulleThreadFunction_t *) f
                                 argument:(void *) argument
{
   NSThread   *threadObject;

   threadObject = [NSThread alloc];
   threadObject = [threadObject mulleInitWithFunction:f
                                             argument:argument];
   threadObject = [threadObject autorelease];

   [threadObject start];
}


+ (void) exit
{
   NSThread                                    *thread;
   struct _mulle_objc_universe                 *universe;
   struct _mulle_objc_universefoundationinfo   *info;
   intptr_t                                    n_threads;

   thread = [NSThread currentThread];
   assert( [NSThread mainThread] != thread);

   [thread _threadWillExit];

   universe  = _mulle_objc_object_get_universe( thread);
   info      = _mulle_objc_universe_get_universefoundationinfo( universe);
   n_threads = (intptr_t) _mulle_atomic_pointer_read( &info->thread.n_threads);
//   fprintf( stderr, "%s %p %ld\n", __PRETTY_FUNCTION__, (void *) mulle_thread_self(), n_threads);
   if( n_threads == 1)
      [thread __isProbablyGoingSingleThreaded];

   //
   // it's important to get rid of the invocation in this thread, so that
   // -finalizers run here. Consequently we gotta lose the invocation here
   // We also do this for the userInfo stuff, i.e. lets run a finalize
   [thread mullePerformFinalize];

   mulle_thread_exit( 0);
}


//
// could also check isMultiThreaded, but that doesn't count +new created
// NSThreads in C-spawned threads. This does count them
//
+ (BOOL) mulleIsMultiThreaded
{
   struct _mulle_objc_universefoundationinfo   *info;
   struct _mulle_objc_universe                 *universe;
   intptr_t                                    n_threads;

   universe  = _mulle_objc_infraclass_get_universe( self);
   info      = _mulle_objc_universe_get_universefoundationinfo( universe);
   n_threads = (intptr_t) _mulle_atomic_pointer_read( &info->thread.n_threads);
   return( n_threads >= 1);
}


#if DEBUG
- (instancetype) retain
{
   return( [super retain]);
}
#endif


@end

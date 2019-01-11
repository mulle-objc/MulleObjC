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
#import "mulle-objc-exceptionhandlertable-private.h"
#import "mulle-objc-universefoundationinfo-private.h"

// std-c and dependencies
#include <stdlib.h>


#pragma clang diagnostic ignored "-Wobjc-root-class"
#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"



@implementation NSThread

+ (struct _mulle_objc_dependency *) dependencies
{
   static struct _mulle_objc_dependency   dependencies[] =
   {
      { @selector( NSAutoreleasePool), 0 },
      { 0, 0 }
   };
   return( dependencies);
}


// this is usually the very first ObjC method call, so assert a little
+ (void) load
{
   struct _mulle_objc_universe  *universe;

   assert( self);
   assert( _cmd == @selector( load));

   universe = _mulle_objc_infraclass_get_universe( self);
   assert( universe);
   _NSThreadNewMainThreadObject( universe);
}


void   _mulle_objc_thread_become_universethread( struct _mulle_objc_universe  *universe)
{
   // the universe will have done this already for us
   if( mulle_thread_self() != universe->thread)
   {
      _mulle_objc_universe_retain( universe);
      mulle_objc_thread_setup_threadinfo( universe);
      _mulle_objc_thread_register_universe_gc( universe);
   }

   assert( _mulle_objc_universe_lookup_infraclass_nofail( universe, @selector( NSAutoreleasePool)));
   mulle_objc_thread_new_poolconfiguration( universe);
}


void  _mulle_objc_thread_resignas_universethread( struct _mulle_objc_universe *universe)
{
   mulle_objc_thread_done_poolconfiguration( universe);

   if( mulle_thread_self() != universe->thread)
   {
      _mulle_objc_thread_remove_universe_gc( universe);
      mulle_objc_thread_unset_threadinfo( universe);      // can't call Objective-C anymore
      _mulle_objc_universe_release( universe);
   }
}


extern void  NSAutoreleasePoolLoader( struct _mulle_objc_universe *universe);

NSThread  *_NSThreadNewUniverseThreadObject( struct _mulle_objc_universe *universe)
{
   NSThread                                    *thread;
   struct _mulle_objc_universefoundationinfo   *info;

   _mulle_objc_thread_become_universethread( universe);

   thread = [NSThread new];
   _mulle_objc_universe_add_rootthreadobject( universe, thread);           // does not retain
   [thread _setAsCurrentThread];

   info = _mulle_objc_universe_get_universefoundationinfo( universe);
   _mulle_atomic_pointer_increment( &info->thread.n_threads);

   return( thread);
}


void  _NSThreadResignAsUniverseThreadObjectAndDeallocate( NSThread *self)
{
   struct _mulle_objc_universefoundationinfo   *info;
   struct _mulle_objc_universe                 *universe;

   universe = _mulle_objc_object_get_universe( self);

   [self _performFinalize]; // get rid of NSThreadDictionary

  // remove as "root" object

   _mulle_objc_universe_remove_rootthreadobject( universe, self);

   assert( ! self->_target);
   assert( ! self->_argument);
   assert( [self retainCount] == 1);

   [self release];

   _mulle_objc_thread_resignas_universethread( universe);

   info  = _mulle_objc_universe_get_universefoundationinfo( universe);
   _mulle_atomic_pointer_decrement( &info->thread.n_threads);
//   _MulleObjCObjectFree( self);
}


NSThread  *_NSThreadNewMainThreadObject( struct _mulle_objc_universe *universe)
{
   NSThread                                    *thread;
   struct _mulle_objc_universefoundationinfo   *info;

   info = _mulle_objc_universe_get_universefoundationinfo( universe);
   if( _mulle_atomic_pointer_nonatomic_read( &info->thread.n_threads))
      __mulle_objc_universe_raise_internalinconsistency( universe, \
         "Universe %p is still or already multithreaded", universe);

   return( _NSThreadNewUniverseThreadObject( universe));
}


// this can only be called during crunch time!
void  _NSThreadResignAsMainThreadObject( struct _mulle_objc_universe *universe)
{
   NSThread   *thread;

   if( ! universe)
      return;

   //
   // can happen in mulle-objc-list, that NSThread isn't really
   // there
   //
   if( ! _mulle_objc_universe_lookup_infraclass( universe, @selector( NSThread)))
      return;

   thread = mulle_objc_thread_get_threadobject( universe);
   if( ! thread)
   {
      // i mean it's bad, but we are probably going down anyway
#if DEBUG
      fprintf( stderr, "*** Main thread was never set up. [NSThread load] did not run!***\n");
#endif
      return;
   }

   assert( ! [NSThread isMultiThreaded]);

   if( _mulle_objc_universe_get_version( universe)  != mulle_objc_universe_is_deinitializing)
      mulle_objc_universe_fail_inconsistency( universe,
         "_NSThreadResignAsMainThreadObject can only be called inside the crunch");

   _NSThreadResignAsUniverseThreadObjectAndDeallocate( thread);
}


/*
 */
- (instancetype) initWithTarget:(id) target
                       selector:(SEL) sel
                         object:(id) argument
{
   if( ! target || ! sel)
      __mulle_objc_universe_raise_invalidargument( _mulle_objc_object_get_universe( self),
                                                 "target and selector must not be nil");

   self->_target   = (target == self) ? self : [target retain];
   self->_selector = sel;
   self->_argument = (argument == self) ? self : [argument retain];

   return( self);
}


- (void) finalize
{
   [self->_userInfo autorelease];
   self->_userInfo = nil;
}


- (void) dealloc
{
   if( self->_target != self)
      [self->_target release];
   if( self->_argument != self)
      [self->_argument release];

   _MulleObjCObjectFree( self);
}


- (void) _setAsCurrentThread
{
   struct _mulle_objc_universe   *universe;

   universe = _mulle_objc_object_get_universe( self);

   // remember NSThread in mulle-thread
   mulle_objc_thread_set_threadobject( universe, self);
}


+ (NSThread *) currentThread
{
   struct _mulle_objc_universe   *universe;

   universe = _mulle_objc_infraclass_get_universe( self);
   return( mulle_objc_thread_get_threadobject( universe));
}


+ (void) _goingSingleThreaded
{
   // but still multi-threaded ATM (!)
   // another thread could be starting up right now from the main thread
   // also some thread destructors might be running
}


+ (void) _isGoingMultiThreaded
{
   //
   // when a notification fires here, it's for "technical" purposes still
   // single threaded.
   //
}


- (void) _threadWillExit
{
   // this will be done later by someone else
   // [[NSNotificationCenter defaultCenter]
   //    postNotificationName:NSThreadWillExitNotification
   //                  object:[NSThread currentThread]];
}


- (void) _begin
{
   struct _mulle_objc_universefoundationinfo   *info;
   struct _mulle_objc_universe                 *universe;

   universe = _mulle_objc_object_get_universe( self);
   info   = _mulle_objc_universe_get_universefoundationinfo( universe);
   info->thread.is_multi_threaded = YES;

   [self _setAsCurrentThread];
}


- (void) _end
{
   struct _mulle_objc_universefoundationinfo   *info;
   struct _mulle_objc_universe                 *universe;

   [self _threadWillExit];

   universe = _mulle_objc_object_get_universe( self);
   info   = _mulle_objc_universe_get_universefoundationinfo( universe);
   if( _mulle_atomic_pointer_decrement( &info->thread.n_threads) == (void *) 2)
   {
      [NSThread _goingSingleThreaded];
      info->thread.is_multi_threaded = NO;
   }

   _thread = (mulle_thread_t) 0;   // allow to start again (in case someone retained us)

   if( _isDetached)
   {
      _mulle_objc_universe_remove_rootobject( universe, self);
      _isDetached = NO;
      [self release];  // can't autorelease here
   }
}


static void   bouncyBounce( void *arg)
{
   NSThread                      *thread;
   struct _mulle_objc_universe   *universe;

   thread   = arg;
   universe = _mulle_objc_object_get_universe( thread);
   _mulle_objc_thread_become_universethread( universe);
   {
      [thread autorelease];

      [thread _begin];
      [thread main];
      [thread _end];
   }
   _mulle_objc_thread_resignas_universethread( universe);

   mulle_thread_exit( 0); // must call this
}


/*
   The pthread_detach() function marks the thread identified by thread as
   detached.  When a detached thread terminates, its resources are
   automatically released back to the system without the need for another
   thread to join with the terminated thread.
   Once a thread has been detached, it can't be joined with pthread_join(3) or
   be made joinable again.
*/
- (void) detach
{
   struct _mulle_objc_universe   *universe;

   [self retain];

   universe = _mulle_objc_object_get_universe( self);
   _mulle_objc_universe_add_rootobject( universe, self);

   self->_isDetached = YES;
   mulle_thread_detach( self->_thread);
}


/*
   The pthread_join() function waits for the thread specified by thread to
   terminate.  If that thread has already terminated, then pthread_join()
   returns immediately. The thread specified by thread must be joinable.
*/
- (void) join
{
   struct _mulle_objc_universe   *universe;

   if( self->_isDetached)
   {
      universe = _mulle_objc_object_get_universe( self),
      __mulle_objc_universe_raise_internalinconsistency( universe,
                        "can't join a detached thread. Use -startUndetached");
   }
   mulle_thread_join( self->_thread);
}


- (void) startUndetached
{
   struct _mulle_objc_universefoundationinfo   *info;
   struct _mulle_objc_universe                 *universe;

   if( self->_thread)
      __mulle_objc_universe_raise_internalinconsistency( universe, "thread already running");

   universe = _mulle_objc_object_get_universe( self);
   info   = _mulle_objc_universe_get_universefoundationinfo( universe);

   if( _mulle_atomic_pointer_increment( &info->thread.n_threads) == (void *) 1)
      [NSThread _isGoingMultiThreaded];

   [self retain]; // retain self for bouncyBounce, which will autorelease

   if( mulle_thread_create( bouncyBounce, self, &self->_thread))
      __mulle_objc_universe_raise_errno( universe, "thread creation");
}


- (void) start
{
   [self startUndetached];
   [self detach];
}


- (void) main
{
   mulle_objc_object_inlinecall_variablemethodid( self->_target,
                                                  (mulle_objc_methodid_t) self->_selector,
                                                  self->_argument);
}


+ (void) detachNewThreadSelector:(SEL) sel
                        toTarget:(id) target
                      withObject:(id) argument
{
   NSThread   *thread;

   thread = [[[NSThread alloc] initWithTarget:target
                                     selector:sel
                                       object:argument] autorelease];

   //   [thread becomeRootObject];  // investigate

   [thread start];
}


+ (void) exit
{
   mulle_thread_exit( 0);
}


+ (BOOL) isMultiThreaded
{
   struct _mulle_objc_universefoundationinfo   *info;
   struct _mulle_objc_universe                 *universe;

   universe = _mulle_objc_infraclass_get_universe( self);
   info   = _mulle_objc_universe_get_universefoundationinfo( universe);
   return( info->thread.is_multi_threaded);
}


#if DEBUG
- (instancetype) retain
{
   return( [super retain]);
}
#endif

@end

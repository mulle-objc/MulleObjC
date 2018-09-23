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
#import "NSAutoreleasePool.h"
#import "mulle-objc-exceptionhandlertable-private.h"
#import "mulle-objc-rootconfiguration-private.h"

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


/*
 */
- (instancetype) initWithTarget:(id) target
             selector:(SEL) sel
               object:(id) argument
{
   if( ! target || ! sel)
      mulle_objc_throw_invalid_argument_exception( "target and selector must not be nil");

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



+ (void) load
{
   _NSThreadNewMainThread();
}


void   _mulle_objc_threadbecome_runtime_thread( void)
{
   struct _mulle_objc_universe     *universe;

   universe = mulle_objc_get_universe();
   assert( universe);

   _mulle_objc_universe_retain( universe);
   mulle_objc_threadset_universe( universe);
   _mulle_objc_universe_register_current_thread_if_needed( universe);

   assert( _mulle_objc_universe_unfailingfastlookup_infraclass( universe, @selector( NSAutoreleasePool)));
   mulle_objc_threadnew_poolconfiguration();
}


static void  __mulle_objc_threadresignas_runtimethread( int debug)
{
   struct _mulle_objc_universe     *universe;
   NSThread                        *thread;

   universe = mulle_objc_inlineget_universe();

   thread = mulle_objc_threadget_threadobject();
   if( ! thread)
   {
      fprintf( stderr, "*** current thread no longer available as NSThread ***\n");
      abort();
   }

   if( debug)
      fprintf( stderr, "NSThread %p: No longer currentThread...\n", thread);
   mulle_objc_threadset_threadobject( NULL);

   if( debug)
      fprintf( stderr, "NSThread %p: Removing thread from pool configuration...\n", thread);
   mulle_objc_threaddone_poolconfiguration();

   if( debug)
      fprintf( stderr, "NSThread %p: Removing thread from universe...\n", thread);

   _mulle_objc_universe_unregister_current_thread( universe);

   if( debug)
      fprintf( stderr, "NSThread %p: Release the universe for this thread...\n", thread);

   // can't call Objective-C anymore
   _mulle_objc_universe_release( universe);
}


void  _mulle_objc_threadresignas_runtimethread( void)
{
   __mulle_objc_threadresignas_runtimethread( 0);
}


NSThread  *_NSThreadNewRuntimeThread()
{
   NSThread                       *thread;
   struct _mulle_objc_rootconfiguration   *config;

   config = _mulle_objc_get_rootconfiguration();

   _mulle_objc_threadbecome_runtime_thread();
   _mulle_atomic_pointer_increment( &config->thread.n_threads);

   thread = [NSThread new];
   mulle_objc_threadset_threadobject( thread);           // does not retain
   [thread _setAsCurrentThread];

   return( thread);
}


void  _NSThreadResignAsRuntimeThreadAndDeallocate( NSThread *self)
{
   struct _mulle_objc_rootconfiguration   *config;

   config = _mulle_objc_get_rootconfiguration();

   [self _performFinalize]; // get rid of NSThreadDictionary

   _mulle_atomic_pointer_decrement( &config->thread.n_threads);
   _mulle_objc_remove_threadobject( self);

   assert( ! self->_target);
   assert( ! self->_argument);
   assert( [self retainCount] == 1);

   _MulleObjCObjectFree( self);
}



NSThread  *_NSThreadNewMainThread( void)
{
   NSThread                       *thread;
   struct _mulle_objc_rootconfiguration   *config;

   config = _mulle_objc_get_rootconfiguration();

   if( _mulle_atomic_pointer_nonatomic_read( &config->thread.n_threads))
      mulle_objc_throw_internal_inconsistency_exception( "runtime is still or already multithreaded");
   _mulle_atomic_pointer_nonatomic_write( &config->thread.n_threads, (void *) 1);

   // this should have happened already in the runtime init for the main
   // thread
   // _mulle_objc_threadbecome_runtime_thread();

   thread = [NSThread new];
   _mulle_objc_add_threadobject( thread);           // does not retain
   [thread _setAsCurrentThread];

   //
   // why no autorelease (?)
   // the main runtime thread has one big problem, it has to shutdown ObjC and
   // then it wants to dealloc, but dealloc can't be called anymore.
   // For that reason it is an error to autorelease the runtime thread, so
   // it can be turned off deterministically
   //
   return( thread);
}


void  _NSThreadResignAsMainThread( void)
{
   struct _mulle_objc_universe  *universe;
   NSThread   *thread;
   int         debug;

   universe = mulle_objc_get_universe();

   if( ! universe)
      return;

   //
   // can happen in mulle-objc-list, that NSThread isn't really
   // there
   //
   if( ! _mulle_objc_universe_fastlookup_infraclass( universe, @selector( NSThread)))
      return;

   //
   // keep current thread around, which is a root
   // that way we also have an AutoreleasePool in place
   //
   assert( ! [NSThread isMultiThreaded]);

   thread = mulle_objc_threadget_threadobject();
   if( ! thread)
   {
      // i mean it's bad, but we are probably going down anyway
      fprintf( stderr, "*** Main thread was never set up. [NSThread load] did not run!***\n");
#if DEBUG
      abort();
#endif
      return;
   }

   debug = mulle_objc_is_debug_enabled();
   if( debug)
      fprintf( stderr, "NSThread %p: Releasing Root objects...\n", thread);
   _mulle_objc_release_roots();          //

   if( debug)
      fprintf( stderr, "NSThread %p: Releasing Singleton objects...\n", thread);
   _mulle_objc_release_singletons();     //

   if( debug)
      fprintf( stderr, "NSThread %p: Releasing Placeholder objects...\n", thread);
   _mulle_objc_release_placeholders();

   assert( _mulle_atomic_pointer_read( &universe->retaincount_1) == 0);

   if( debug)
      fprintf( stderr, "NSThread %p: Resigning as main NSThread...\n", thread);
   _NSThreadResignAsRuntimeThreadAndDeallocate( thread);

   __mulle_objc_threadresignas_runtimethread( debug);
}


- (void) _setAsCurrentThread
{
   mulle_objc_threadset_threadobject( self);
}


+ (NSThread *) currentThread
{
   return( mulle_objc_threadget_threadobject());
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
   // [[NSNotificationCenter defaultCenter] postNotificationName:NSThreadWillExitNotification
   //                                                     object:[NSThread currentThread]];
}

- (void) _begin
{
   struct _mulle_objc_rootconfiguration   *config;

   config = _mulle_objc_get_rootconfiguration();
   config->thread.is_multi_threaded = YES;

   [self _setAsCurrentThread];
}


- (void) _end
{
   struct _mulle_objc_rootconfiguration   *config;

   [self _threadWillExit];

   config = _mulle_objc_get_rootconfiguration();
   if( _mulle_atomic_pointer_decrement( &config->thread.n_threads) == (void *) 2)
   {
      [NSThread _goingSingleThreaded];
      config->thread.is_multi_threaded = NO;
   }

   _thread = (mulle_thread_t) 0;   // allow to start again (in case someone retained us)

   if( _isDetached)
   {
      _mulle_objc_remove_root( self);
      _isDetached = NO;
      [self release];  // can't autorelease here
   }
}


static void   bouncyBounce( void *arg)
{
   NSThread   *thread;

   thread = arg;
   _mulle_objc_threadbecome_runtime_thread();
   {
      [thread autorelease];

      [thread _begin];
      [thread main];
      [thread _end];
   }
   _mulle_objc_threadresignas_runtimethread();

   mulle_thread_exit( 0); // must call this
}


- (void) detach
{
   [self retain];
   _mulle_objc_add_root( self);

   self->_isDetached = YES;
   mulle_thread_detach( self->_thread);
}


- (void) startUndetached
{
   struct _mulle_objc_rootconfiguration   *config;

   if( self->_thread)
      mulle_objc_throw_internal_inconsistency_exception( "thread already running");

   config = _mulle_objc_get_rootconfiguration();
   if( _mulle_atomic_pointer_increment( &config->thread.n_threads) == (void *) 1)
      [NSThread _isGoingMultiThreaded];

   [self retain]; // retain self for thread
   if( mulle_thread_create( bouncyBounce, self, &self->_thread))
      mulle_objc_throw_errno_exception( "thread creation");
}


- (void) start
{
   [self startUndetached];
   [self detach];
}


- (void) main
{
   mulle_objc_object_inline_variable_methodid_call( self->_target,
                                                    (mulle_objc_methodid_t) self->_selector,
                                                    self->_argument);
}


- (void) join
{
   if( self->_isDetached)
      mulle_objc_throw_internal_inconsistency_exception( "can't join a "
         "detached thread. Use -startUndetached");
   mulle_thread_join( self->_thread);
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
   [thread detach];
}


+ (void) exit
{
   mulle_thread_exit( 0);
}


+ (BOOL) isMultiThreaded
{
   struct _mulle_objc_rootconfiguration   *config;

   config = _mulle_objc_get_rootconfiguration();
   return( config->thread.is_multi_threaded);
}


#if DEBUG
- (instancetype) retain
{
   return( [super retain]);
}
#endif

@end

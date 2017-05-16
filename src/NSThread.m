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
#import "NSThread.h"

// other files in this library
#import "NSAutoreleasePool.h"
#import "MulleObjCAllocation.h"

// std-c and dependencies
#include <mulle_thread/mulle_thread.h>
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


#define NSAUTORELEASEPOOL_HASH   0x5b791fc6  // NSAutoreleasePool

void   _mulle_become_objc_runtime_thread( void)
{
   struct _mulle_objc_runtime     *runtime;

   runtime = mulle_objc_get_runtime();
   assert( runtime);

   _mulle_objc_runtime_retain( runtime);
   mulle_objc_set_thread_runtime( runtime);
   _mulle_objc_runtime_register_current_thread_if_needed( runtime);
   if( _mulle_objc_runtime_get_or_lookup_infraclass( runtime, MULLE_OBJC_CLASSID( NSAUTORELEASEPOOL_HASH))) // NSAutoreleasePool
      _ns_poolconfiguration_set_thread();
}


void  _mulle_resignas_objc_runtime_thread( void)
{
   struct _mulle_objc_runtime     *runtime;

   if( ! _ns_get_thread())
      return;

   _ns_set_thread( NULL);
   _ns_poolconfiguration_unset_thread();

   runtime = mulle_objc_inlined_get_runtime();
   _mulle_objc_runtime_unregister_current_thread( runtime);

   // can't call Objective-C anymore
   _mulle_objc_runtime_release( runtime);
}


NSThread  *_NSThreadNewRuntimeThread()
{
   NSThread                       *thread;
   struct _ns_rootconfiguration   *config;

   config = _ns_get_rootconfiguration();

   _mulle_become_objc_runtime_thread();
   _mulle_atomic_pointer_increment( &config->thread.n_threads);

   thread = [NSThread new];
   _ns_add_thread( thread);           // does not retain
   [thread _setAsCurrentThread];

   return( thread);
}


void  _NSThreadResignAsRuntimeThreadAndDeallocate( NSThread *self)
{
   struct _ns_rootconfiguration   *config;

   config = _ns_get_rootconfiguration();

   [self _performFinalize]; // get rid of NSThreadDictionary

   _mulle_atomic_pointer_decrement( &config->thread.n_threads);
   _ns_remove_thread( self);

   assert( ! self->_target);
   assert( ! self->_argument);
   assert( [self retainCount] == 1);

   _MulleObjCObjectFree( self);
}



NSThread  *_NSThreadNewMainThread( void)
{
   NSThread                       *thread;
   struct _ns_rootconfiguration   *config;

   config = _ns_get_rootconfiguration();

   if( _mulle_atomic_pointer_nonatomic_read( &config->thread.n_threads))
      mulle_objc_throw_internal_inconsistency_exception( "runtime is still or already multithreaded");
   _mulle_atomic_pointer_nonatomic_write( &config->thread.n_threads, (void *) 1);

   // this should have happened already in the runtime init for the main
   // thread
   // _mulle_become_objc_runtime_thread();

   thread = [NSThread new];
   _ns_add_thread( thread);           // does not retain
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
   NSThread   *thread;
   int         debug;

   //
   // keep current thread around, which is a root
   // that way we also have an AutoreleasePool in place
   //
   assert( ! [NSThread isMultiThreaded]);

   thread = [NSThread currentThread];

   debug = _ns_rootconfiguration_is_debug_enabled();
   if( debug)
      fprintf( stderr, "Releasing Root objects...\n");
   _ns_release_roots();          //

   if( debug)
      fprintf( stderr, "Releasing Singleton objects...\n");
   _ns_release_singletons();     //

   if( debug)
      fprintf( stderr, "Releasing Placeholder objects...\n");
   _ns_release_placeholders();

   assert( _mulle_atomic_pointer_read( &mulle_objc_get_runtime()->retaincount_1) == 0);

   if( debug)
      fprintf( stderr, "Resigning as main NSThread...\n");
   _NSThreadResignAsRuntimeThreadAndDeallocate( thread);

   if( debug)
      fprintf( stderr, "Resign as main Objective-C thread...\n");
   _mulle_resignas_objc_runtime_thread();
}


- (void) _setAsCurrentThread
{
   _ns_set_thread( self);
}


+ (NSThread *) currentThread
{
   return( _ns_get_thread());
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
   struct _ns_rootconfiguration   *config;

   config = _ns_get_rootconfiguration();
   config->thread.is_multi_threaded = YES;

   [self _setAsCurrentThread];
}


- (void) _end
{
   struct _ns_rootconfiguration   *config;

   [self _threadWillExit];

   config = _ns_get_rootconfiguration();
   if( _mulle_atomic_pointer_decrement( &config->thread.n_threads) == (void *) 2)
   {
      [NSThread _goingSingleThreaded];
      config->thread.is_multi_threaded = NO;
   }

   _thread = (mulle_thread_t) 0;   // allow to start again (in case someone retained us)

   if( _isDetached)
   {
      _ns_remove_root( self);
      _isDetached = NO;
      [self release];  // can't autorelease here
   }
}


static void   bouncyBounce( void *arg)
{
   NSThread   *thread;

   thread = arg;
   _mulle_become_objc_runtime_thread();
   {
      [thread autorelease];

      [thread _begin];
      [thread main];
      [thread _end];
   }
   _mulle_resignas_objc_runtime_thread();

   mulle_thread_exit( 0); // must call this
}


- (void) detach
{
   [self retain];
   _ns_add_root( self);

   self->_isDetached = YES;
   mulle_thread_detach( self->_thread);
}


- (void) startUndetached
{
   struct _ns_rootconfiguration   *config;

   if( self->_thread)
      mulle_objc_throw_internal_inconsistency_exception( "thread already running");

   config = _ns_get_rootconfiguration();
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
   mulle_objc_object_inline_variable_methodid_call( self->_target, (mulle_objc_methodid_t) self->_selector, self->_argument);
}


- (void) join
{
   if( self->_isDetached)
      mulle_objc_throw_internal_inconsistency_exception( "can't join a detached thread. Use -startUndetached");
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
   struct _ns_rootconfiguration   *config;

   config = _ns_get_rootconfiguration();
   return( config->thread.is_multi_threaded);
}


#if DEBUG
- (instancetype) retain
{
   return( [super retain]);
}
#endif

@end

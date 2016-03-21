/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSThread.m is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSThread.h"

#import "NSAutoreleasePool.h"
#import "NSAllocation.h"

#include <mulle_thread/mulle_thread.h>
#include <stdlib.h>


@implementation NSThread


/*
 */
- (id) initWithTarget:(id) target
             selector:(SEL) sel
               object:(id) argument
{
   if( ! target || ! sel)
      __NSThrowInvalidArgumentException( "target and selector must not be nil");

   self->_target   = (target == self) ? self : [target retain];
   self->_selector = sel;
   self->_argument = (argument == self) ? self : [argument retain];
   
   return( self);
}


- (void) dealloc
{
   if( self->_target != self)
      [self->_target release];
   if( self->_argument != self)
      [self->_argument release];

   _MulleObjCDeallocateObject( self);
}


+ (void) load
{
   NSThreadInstantiateRuntimeThread();
}


void   _mulle_become_objc_runtime_thread( void)
{
   struct _mulle_objc_runtime     *runtime;
   
   runtime = mulle_objc_get_runtime();
   assert( runtime);

   _mulle_objc_runtime_retain( runtime);
   mulle_objc_set_thread_runtime( runtime);
   _mulle_objc_runtime_register_current_thread_if_needed( runtime);
   
   if( _mulle_objc_runtime_lookup_class( runtime, MULLE_OBJC_CLASSID( 0x511c9ac972f81c49)))
      _ns_poolconfiguration_set_thread();
}


void  _mulle_stepdown_as_objc_runtime_thread( void)
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


NSThread  *NSThreadInstantiateRuntimeThread()
{
   NSThread                       *thread;
   struct _ns_rootconfiguration   *config;

   config = _ns_rootconfiguration();

   if( _mulle_atomic_pointer_nonatomic_read( &config->thread.n_threads))
      __NSThrowInternalInconsistencyException( "runtime is still or already multithreaded");
   _mulle_atomic_pointer_nonatomic_write( &config->thread.n_threads, (void *) 1);

   // this should have happened already in the runtime init
   // _mulle_become_objc_runtime_thread();

   thread = [NSThread new];
   _ns_add_root( thread);           // does not retain
   [thread _setAsCurrentThread];
   
   //
   // why no autorelease (?)
   // the runtime thread has one big problem, it has to shutdown ObjC and
   // then it wants to dealloc, but dealloc can't be called anymore.
   // For that reason it is an error to autorelease the runtime thread, so
   // it can be turned off deterministically
   //
   return( thread);
}


void  NSThreadDeallocateRuntimeThread( NSThread *self)
{
   struct _ns_rootconfiguration   *config;

   config = _ns_rootconfiguration();

   if( _mulle_atomic_pointer_read( &config->thread.n_threads) != (void *) 1)
      __NSThrowInternalInconsistencyException( "runtime is still or already multithreaded");
   _mulle_atomic_pointer_nonatomic_write( &config->thread.n_threads, (void *) 0);
   assert( ! config->thread.is_multi_threaded);
   
   _ns_remove_root( self);
   
   assert( ! self->_target);
   assert( ! self->_argument);
   assert( [self retainCount] == 1);
   
   _MulleObjCDeallocateObject( self);
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
   
   config = _ns_rootconfiguration();
   config->thread.is_multi_threaded = YES;
   
   [self _setAsCurrentThread];
}


- (void) _end
{
   struct _ns_rootconfiguration   *config;

   [self _threadWillExit];

   config = _ns_rootconfiguration();
   if( _mulle_atomic_pointer_decrement( &config->thread.n_threads) == (void *) 2)
   {
      [NSThread _goingSingleThreaded];
      config->thread.is_multi_threaded = NO;
   }
   
   _thread = NULL;   // allow to start again (in case someone retained us)
   
   if( _isDetached)
   {
      _ns_remove_root( self);
      _isDetached = NO;
      [self release];  // can't autorelease here
   }
}


static void   *bouncyBounce( NSThread *thread)
{
   _mulle_become_objc_runtime_thread();
   {
      [thread autorelease];
      [thread _begin];
      [thread main];
      [thread _end];
   }
   _mulle_stepdown_as_objc_runtime_thread();
   
   return( NULL);
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
      __NSThrowInternalInconsistencyException( "thread already running");
   
   config = _ns_rootconfiguration();
   if( _mulle_atomic_pointer_increment( &config->thread.n_threads) == (void *) 1)
      [NSThread _isGoingMultiThreaded];

   [self retain]; // retain self for thread
   if( mulle_thread_create( (void *(*)( void *)) bouncyBounce, self, &self->_thread))
      __NSThrowErrnoException( "thread creation");
}


- (void) start
{
   [self startUndetached];
   [self detach];
}


- (void) main
{
   mulle_objc_object_call_no_fastmethod( self->_target, self->_selector, self->_argument);
}


- (void) join
{
   if( self->_isDetached)
      __NSThrowInternalInconsistencyException( "can't join a detached thread. Use -startUndetached");
   mulle_thread_join( self->_thread);
}


+ (void) detachNewThreadSelector:(SEL) sel
                        toTarget:(id) target
                      withObject:(id) argument
{
   NSThread   *thread;
   
   thread = [[NSThread instantiate] initWithTarget:target
                                          selector:sel
                                            object:argument];
   [thread start];
   [thread detach];
}


+ (void) exit
{
   mulle_thread_cancel();
}


+ (BOOL) isMultiThreaded
{
   struct _ns_rootconfiguration   *config;

   config = _ns_rootconfiguration();
   return( config->thread.is_multi_threaded);
}

@end


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

static BOOL                  __MulleObjCMultiThreaded;
static mulle_thread_tss_t    __MulleObjCThreadObjectKey;



/*
 */
- (id) initWithTarget:(id) aTarget
             selector:(SEL) selector
               object:(id) anArgument
{
   self->target   = [aTarget retain];
   self->argument = [anArgument retain];
   
   return( self);
}


- (void) dealloc
{
   [self->target release];
   [self->argument release];

   MulleObjCThreadDeallocRuntimeThread( self);
}


static void   bouncyBounceEnd( void *thread);


+ (void) load
{
   [NSThread _instantiateRuntimeThread];
}


+ (void) initialize
{
   if( ! __MulleObjCThreadObjectKey)
      mulle_thread_tss_create( &__MulleObjCThreadObjectKey, bouncyBounceEnd);
}


void   MulleObjCThreadBecomeRuntimeThread( NSThread *self)
{
   struct _mulle_objc_runtime   *runtime;
   
   assert( __MulleObjCThreadObjectKey);
   if( mulle_thread_tss_get( __MulleObjCThreadObjectKey))
      return;

   mulle_thread_tss_set( __MulleObjCThreadObjectKey, self);

   runtime = mulle_objc_inlined_get_runtime();
   assert( runtime);
   _mulle_objc_runtime_retain( runtime);
   _mulle_objc_runtime_register_current_thread_if_needed( runtime);
   
   if( _mulle_objc_runtime_lookup_class( runtime, MULLE_OBJC_CLASSID( 0x511c9ac972f81c49)))
      MulleObjCAutoreleasePoolConfigurationSetThread();
}


void  MulleObjCThreadDeallocRuntimeThread( NSThread *self)
{
   struct _mulle_objc_runtime   *runtime;
   
   if( mulle_thread_tss_get( __MulleObjCThreadObjectKey))
   {
      MulleObjCAutoreleasePoolConfigurationUnsetThread();
   
      mulle_thread_tss_set( __MulleObjCThreadObjectKey, NULL);
   
      runtime = mulle_objc_inlined_get_runtime();
      assert( runtime);
   
      _mulle_objc_runtime_unregister_current_thread( runtime);
      // can't call methods anymore after this
      _mulle_objc_runtime_release( runtime);
   }
   _MulleObjCDeallocateObject( self);
}


+ (NSThread *) _instantiateRuntimeThread
{
   NSThread   *thread;

   thread = [NSThread new];
   MulleObjCThreadBecomeRuntimeThread( thread);
   [thread becomeRootObject];
   [thread release]; // becomeRoot retains, undo it as thread is not autoreleased

   return( thread);
}


+ (NSThread *) currentThread
{
   NSThread   *p;
   
   p = mulle_thread_tss_get( __MulleObjCThreadObjectKey);
   assert( p);
   return( p);  // not a leak
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
   //[[NSNotificationCenter defaultCenter] postNotificationName:NSThreadWillExitNotification
   //                                                    object:[NSThread currentThread]];
}


static mulle_atomic_pointer_t    __NSNumberOfThreads;


static void   bouncyBounceEnd( void *_thread)
{
   struct _mulle_objc_runtime  *runtime;
   NSThread                    *thread;
   
   thread = _thread;
   [thread _threadWillExit];

   if( ! _mulle_atomic_pointer_decrement( &__NSNumberOfThreads))
   {
      [NSThread _goingSingleThreaded];
      __MulleObjCMultiThreaded = NO;
   }
   
   [thread release]; // ho hum
}


static void   *bouncyBounce( NSThread *thread)
{
   id                           rval;
   struct _mulle_objc_runtime   *runtime;
   struct _mulle_objc_class     *cls;
   
   __MulleObjCMultiThreaded = YES;

   MulleObjCThreadBecomeRuntimeThread( thread);

   return( mulle_objc_object_call( thread->target, thread->sel, thread->argument));
}


+ (void) detachNewThreadSelector:(SEL) sel
                        toTarget:(id) target
                      withObject:(id) argument
{
   NSThread                     *thread;
   struct _mulle_objc_runtime   *runtime;
   mulle_thread_t                m_thread;
   
   if( ! _mulle_atomic_pointer_increment( &__NSNumberOfThreads))
      [NSThread _isGoingMultiThreaded];
   
   thread = [[NSThread alloc] initWithTarget:target
                                    selector:sel
                                      object:argument];
   
   if( mulle_thread_create( (void *(*)( void *)) bouncyBounce, thread, &m_thread))
      __NSThrowErrnoException( "thread creation");
}


+ (void) exit
{
   mulle_thread_cancel();
}


+ (BOOL) isMultiThreaded
{
   return( __MulleObjCMultiThreaded);
}

@end


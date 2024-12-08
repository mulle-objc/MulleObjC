//
//  NSThread.h
//  MulleObjC
//
//  Copyright (c) 2015 Nat! - Mulle kybernetiK.
//  Copyright (c) 2015 Codeon GmbH.
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
#import "NSObject.h"

#import "MulleObjCProtocol.h"

@class NSAutoreleasePool;
@class NSThread;
@class NSInvocation;
struct MulleObjCAutoreleasePoolConfiguration;


typedef int   MulleThreadFunction_t( NSThread *, void *);
typedef int   MulleThreadObjectFunction_t( NSThread *, id);

//
// A NSThread is a 1:1 relationship to a mulle_thread, if the mulle_thread dies
// the  NSThread is gone. We don't switch threads inside a NSThread.
// If you pass non-threadsafe objects to the NSThread via the NSInvocation,
// these objects will be unusable in the caller thread once the thread is
// started. You must not access them anymore. This includes the target.
// The default strategy may even remove not-threadsafe objects from the active
// NSAutoreleasePool of the caller thread.
//
@interface NSThread : NSObject < MulleObjCThreadSafe>
{
   mulle_atomic_pointer_t   _osThread;
   mulle_atomic_pointer_t   _runLoop;
   mulle_atomic_pointer_t   _nameUTF8String;
   mulle_atomic_pointer_t   _cancelled;

   NSInvocation             *_invocation;
   id                       _userInfo;           // only valid in thread
   MulleThreadFunction_t    *_function;          // unmanaged
   void                     *_functionArgument;  // unmanaged (unless _isObjectFunctionArgument is 1)

   // autoreleasepool root config (intended for debugging only)
   void                     *_poolconfiguration;
   struct mulle_map         _map;  // not the -threadDictionary !
   int                      _rval;

   char                     _isObjectFunctionArgument;
   char                     _isDetached;
   char                     _threadDidGainAccess;     // NSThread did gain accesss
}

+ (NSThread *) mainThread;

// this oughta crash for a thread that is not a MulleObjC thread, because 
// Objective-C method sending in non MulleObjC thread is not allowed.
// To check if a thread is properly setup use C functions below
// use MulleThreadGetCurrentThread to check
+ (NSThread *) currentThread;

+ (BOOL) mulleIsMainThread;

// target and object will be retained
+ (void) detachNewThreadSelector:(SEL) sel
                        toTarget:(id) target
                      withObject:(id) argument;

// caller is responsible to call -retainArguments on invocation
+ (void) mulleDetachNewThreadWithInvocation:(NSInvocation *) invocation;

+ (void) mulleDetachNewThreadWithFunction:(MulleThreadFunction_t *) f
                                 argument:(void *) argument;

+ (void) exit;


// caller is responsible to call -retainArguments on invocation
+ (instancetype) mulleThreadWithInvocation:(NSInvocation *) invocation;

// target and object will be retained
+ (instancetype) mulleThreadWithTarget:(id) target
                              selector:(SEL) sel
                                object:(id) argument;


- (instancetype) mulleInitWithFunction:(MulleThreadFunction_t *) f
                              argument:(void *) argument;


- (instancetype) mulleInitWithObjectFunction:(MulleThreadObjectFunction_t) f
                                      object:(id) obj;

// caller is responsible to call -retainArguments on invocation
- (instancetype) mulleInitWithInvocation:(NSInvocation *) invocation;


//
// Apple says: This selector must take only one argument and must not have a
// return value. In MulleObjC, the return value is preferred to be "int"
// target and object will be retained
//
- (instancetype) initWithTarget:(id) target
                       selector:(SEL) sel
                         object:(id) argument;


- (void) main;


+ (BOOL) isMultiThreaded;   // __attribute__((availability(mulleobjc,introduced=0.2)));

//
// this actually indicates the current state, contrary to what
// Foundation does
//
+ (BOOL) mulleIsMultiThreaded;   // __attribute__((availability(mulleobjc,introduced=0.2)));
+ (BOOL) mulleMainThreadWaitsAtExit;
+ (void) mulleSetMainThreadWaitsAtExit:(BOOL) flag;

// the thread is started and starts running, but still should be joined or
// detached
- (void) mulleStart;
//
// don't call mulleJoin on a detached thread.
// Returns the thread invocation, and after that it's no longer available
// from the NSThread
//
- (NSInvocation *) mulleJoin;    // __attribute__((availability(mulleobjc,introduced=0.2)));

// This is legacy interface, which runs the thread in a detached state.
// Prefer mulleStart and then keep the NSThread object around for later.
// Then mulleJoin on it when it has been finished.
//
- (void) start;

// do this only once, the runloop will be retained by NSThread
// do not use the passed in runLoop, instead use the return value
- (id) mulleSetRunLoop:(id) runLoop;
- (id) mulleRunLoop;

- (BOOL) wasAutocreated;

// this is "cooperative", it doesn't send any signals
- (BOOL) isCancelled;
- (void) cancel;


- (int) mulleReturnStatus;


// this is not any longer a property, because we only want to clear it in
// -dealloc. At time of writing properties are zeroed in -finalize
//
// This "property" can only be set by the caller, before the thread is
// actually executed, if none is set this will be the address of NSThread
- (void) mulleSetNameUTF8String:(char *) s   MULLE_OBJC_THREADSAFE_METHOD;
- (char *) mulleNameUTF8String               MULLE_OBJC_THREADSAFE_METHOD;

#pragma mark - Internal

// don't call these functions yourself


MULLE_OBJC_GLOBAL
NSThread   *_MulleThreadGetCurrentThreadObjectInUniverse( struct _mulle_objc_universe *universe);

MULLE_OBJC_GLOBAL
NSThread   *_MulleThreadCreateThreadObjectInUniverse( struct _mulle_objc_universe *universe);

MULLE_OBJC_GLOBAL
NSThread   *_MulleThreadCreateMainThreadObjectInUniverse( struct _mulle_objc_universe *universe);

MULLE_OBJC_GLOBAL
NSThread   *_MulleThreadGetMainThreadObjectInUniverse( struct _mulle_objc_universe *universe);

MULLE_OBJC_GLOBAL
void   _MulleThreadRemoveThreadObjectFromUniverse( NSThread *threadObject,
                                                   struct _mulle_objc_universe *universe);
//
// this can only be called during crunch time!
// it will autorelase the runloop and the thread dictionary
//
MULLE_OBJC_GLOBAL
void   _MulleThreadFinalizeMainThreadObjectInUniverse( struct _mulle_objc_universe *universe);

MULLE_OBJC_GLOBAL
void   _MulleThreadResignAsMainThreadObjectInUniverse( struct _mulle_objc_universe *universe);

// used to setup threads and run atexit stuff on a per thread basis
MULLE_OBJC_GLOBAL
void   _mulle_objc_threadinfo_destructor( struct _mulle_objc_threadinfo *info,
                                          void *foundationspace);
MULLE_OBJC_GLOBAL
void   _mulle_objc_threadinfo_initializer( struct _mulle_objc_threadinfo *config);


@end


static inline NSThread   *MulleThreadGetCurrentThread( void)
{
   struct _mulle_objc_universe   *universe;
   NSThread                      *threadObject;

   universe     = mulle_objc_global_get_universe( __MULLE_OBJC_UNIVERSEID__);
   threadObject = _mulle_objc_thread_get_threadobject( universe);
   return( threadObject);
}

MULLE_OBJC_GLOBAL
NSThread   *MulleThreadGetOrCreateCurrentThread( void);

//
// This is the preferred way to retrieve the threadDictionary
// of the current thread for reading. But since the threadDictionary is
// installed lazily (as it is), this is NOT a good way to set values.
// -threadDictionary will be introduced by MulleObjCContainerFoundation, since
// we don't know dictionaries here in MulleObjC
//
static inline id   MulleThreadGetCurrentThreadUserInfo( void)
{
   NSThread   *threadObject;

   threadObject = MulleThreadGetCurrentThread();
   return( ((struct { @defs( NSThread); } *) threadObject)->_userInfo);
}


// the complementary to above function
MULLE_OBJC_GLOBAL
void   MulleThreadSetCurrentThreadUserInfo( id info);



//
// this is a convenience, if you feel that
// -[[[NSThread currentThread] threadDictionary] setObject:foo forKey:xx]
// is a little too much Objective-C for whats essentially stack local storage
// (https://www.gnu.org/software/libc/manual/html_node/ISO-C-Thread_002dlocal-Storage.html)
//
// This is slower then tss, but has no key quantity limitations like
// pthreads. Eventually migrate to thread_local, when this is universally
// supported I guess.
//
static inline void   MulleThreadSetObjectForKeyUTF8String( id value, char *key)
{
   NSThread   *threadObject;

   threadObject = MulleThreadGetCurrentThread();
   assert( ! value || [value mulleIsAccessibleByThread:threadObject]);
   mulle_map_set( &((struct { @defs( NSThread); } *) threadObject)->_map,
                  key,
                  value);
}


static inline id   MulleThreadObjectForKeyUTF8String( char *key)
{
   NSThread   *threadObject;

   threadObject = MulleThreadGetCurrentThread();
   return( mulle_map_get( &((struct { @defs( NSThread); } *) threadObject)->_map,
                          key));
}



static inline mulle_thread_t  MulleThreadObjectGetOSThread( NSThread *threadObject)
{
   return( (mulle_thread_t) _mulle_atomic_pointer_read( &((struct { @defs( NSThread); } *) threadObject)->_osThread));
}


static inline mulle_thread_t  MulleThreadGetCurrentOSThread( void)
{
   return( (mulle_thread_t) mulle_thread_self());
}



typedef void   MulleObjCTAOFailureHandler( void *obj,
                                           mulle_thread_t osThread,
                                           struct _mulle_objc_descriptor *des) MULLE_C_NO_RETURN;

// no coming back from this, just print nicely and abort
#pragma mark - TAO Wrong Thread Failure

static inline MulleObjCTAOFailureHandler   *MulleObjCGetTAOFailureHandler( void)
{
   struct _mulle_objc_universe   *universe;

   universe = mulle_objc_global_get_defaultuniverse();
   return( (MulleObjCTAOFailureHandler *) universe->failures.wrongthread);
}


static inline void   MulleObjCSetTAOFailureHandler( MulleObjCTAOFailureHandler *handler)
{
   struct _mulle_objc_universe      *universe;

   universe = mulle_objc_global_get_defaultuniverse();
   universe->failures.wrongthread = (void (*)()) handler;
}


MULLE_OBJC_GLOBAL
void  MulleObjCTAOLogAndFail( struct _mulle_objc_object *obj,
                              mulle_thread_t osThread,
                              struct _mulle_objc_descriptor *desc) MULLE_C_NO_RETURN;


//
// This is a function for test code to see if your class has problems with
// the TAO-dilemma.
// The setupMethod should configure the receiver as incoveniently as possible
// i.e. all properties (references) should be to non-threadsafe objects (where
// it makes sense)
//
// e.g.
// ``` objc
// @implementation Test (TAOTest)
// - (void) mulleTAOTestSetup:(id) arg
// {
//    Bar   *bar;
//
//    MULLE_C_UNUSED( arg);
//    bar = [Bar object];
//    [self setBar:bar];
// }
// @end

static inline void  MulleObjCTAOTest( Class cls, id arg)
{
   id         obj;
   NSThread   *thread;

   @autoreleasepool
   {
      obj    = [cls object];
      thread = [[[NSThread alloc] initWithTarget:obj
                                        selector:@selector( mulleTAOTestSetup:)
                                          object:arg] autorelease];
      [thread mulleStart];
      [thread mulleJoin];
   }
}


// An alternative way to have a threadsafe method or property is to declare
// that it will only be accessed by the main thread. This is just a declaration
// no one is going to verify it. For methods, you should code it like this:
//
// - (void) myMethod  MULLE_OBJC_MAINTHREAD_METHOD;
//
// - (void) myMethod  MULLE_OBJC_MAINTHREAD_METHOD
// {
//    assert( [NSThread mulleIsMainThread]);
// }
//
// You should do this for properties too, but its less convenient, since you
// now have to write two accessors manually. So this should be done by the
// compiler some of these days. We then need would likely use
// _MULLE_OBJC_METHOD_USER_ATTRIBUTE_3 instead.
//
#define MULLE_OBJC_MAINTHREAD_PROPERTY   MULLE_OBJC_THREADSAFE_PROPERTY
#define MULLE_OBJC_MAINTHREAD_METHOD     MULLE_OBJC_THREADSAFE_METHOD


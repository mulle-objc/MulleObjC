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
struct MulleObjCAutoreleasePoolConfiguration;

enum
{
   MulleThreadDontRetainTarget    = 0x1,
   MulleThreadDontRetainArgument  = 0x2,
   MulleThreadDontReleaseTarget   = 0x4,
   MulleThreadDontReleaseArgument = 0x8
};


typedef int   MulleThreadFunction_t( NSThread *, void *);


// TODO: not really threasafe, need to fix
// it's not really immutable but thread safe (except that its not )
//
@interface NSThread : NSObject < MulleObjCThreadSafe>
{
   mulle_atomic_pointer_t   _osThread;

   id                       _target;
   SEL                      _selector;
   id                       _argument;
   mulle_atomic_pointer_t   _runLoop;
   id                       _userInfo;

   MulleThreadFunction_t    *_function;
   void                     *_functionArgument;  // unmanaged

   mulle_atomic_pointer_t   _nameUTF8String;
   char                     _isDetached;
   char                     _releaseTarget;
   char                     _releaseArgument;
   mulle_atomic_pointer_t   _cancelled;
   struct mulle_map         _map;  // not the -threadDictionary !
   int                      _rval;
}

@property( dynamic, assign) char  *mulleNameUTF8String  MULLE_OBJC_THREADSAFE_PROPERTY;

+ (NSThread *) mainThread;
+ (NSThread *) currentThread;

+ (BOOL) mulleIsMainThread;

+ (void) detachNewThreadSelector:(SEL) sel
                        toTarget:(id) target
                      withObject:(id) argument;

+ (void) mulleDetachNewThreadWithFunction:(MulleThreadFunction_t *) f
                                 argument:(void *) argument;

+ (void) exit;

+ (instancetype) mulleThreadWithTarget:(id) target
                              selector:(SEL) sel
                                object:(id) argument;


- (instancetype) mulleInitWithFunction:(MulleThreadFunction_t *) f
                              argument:(void *) argument;


//
// you can tweak the way thread handles target and argument here, this
// can be useful if you are managing threads on your own. Specify bits like
// MulleThreadDontRetainTarget as options
//
- (instancetype) mulleInitWithTarget:(id) target
                            selector:(SEL) sel
                              object:(id) object
                             options:(NSUInteger) options;

//
// Apple says: This selector must take only one argument and must not have a
// return value. In MulleObjC, the return value is preferred to be "int"
//
- (instancetype) initWithTarget:(id) target
                       selector:(SEL) sel
                         object:(id) argument;


- (void) start;
- (void) main;


+ (BOOL) isMultiThreaded;   // __attribute__((availability(mulleobjc,introduced=0.2)));

//
// this actually indicates the current state, contrary to what
// Foundation does
//
+ (BOOL) mulleIsMultiThreaded;   // __attribute__((availability(mulleobjc,introduced=0.2)));
+ (BOOL) mulleMainThreadWaitsAtExit;
+ (void) mulleSetMainThreadWaitsAtExit:(BOOL) flag;

// mulle additons for tests

// don't call join on a detached thread
- (void) mulleJoin;              // __attribute__((availability(mulleobjc,introduced=0.2)));
- (void) mulleDetach;            // __attribute__((availability(mulleobjc,introduced=0.2)));

// the thread is started and starts running, but still should be joined or
// detached
- (void) mulleStartUndetached;   // __attribute__((availability(mulleobjc,introduced=0.2)));

// do this only once, the runloop will be retained by NSThread
// do not use the passed in runLoop, instead use the return value
- (id) mulleSetRunLoop:(id) runLoop;
- (id) mulleRunLoop;

- (BOOL) wasAutocreated;

// this is "cooperative", it doesn't send any signals
- (BOOL) isCancelled;
- (void) cancel;




- (int) mulleReturnStatus;

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



static inline mulle_thread_t  _NSThreadGetOSThread( NSThread *threadObject)
{
   return( (mulle_thread_t) _mulle_atomic_pointer_read( &((struct { @defs( NSThread); } *) threadObject)->_osThread));
}


static inline mulle_thread_t  _NSThreadGetCurrentOSThread( void)
{
   return( (mulle_thread_t) mulle_thread_self());
}



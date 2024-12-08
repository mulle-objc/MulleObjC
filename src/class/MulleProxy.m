//
//  MulleProxy.m
//  MulleObjC
//
//  Copyright (c) 2024 Nat! - Mulle kybernetiK.
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
#import "MulleProxy.h"

#import "import-private.h"

#import "MulleObjCExceptionHandler.h"
#import "NSLock.h"
#import "NSRecursiveLock.h"
#import "MulleObject.h"

#import "MulleObjCExceptionHandler-Private.h"
#import "NSLock-Private.h"
#import "NSRecursiveLock-Private.h"



@implementation MulleProxy


+ (instancetype) proxyWithObject:(id) target
{
   MulleProxy   *obj;

   obj = [self alloc];
   obj = [obj initWithObject:target];
   obj = [obj autorelease];
   return( obj);
}


+ (instancetype) locklessProxyWithObject:(id) target
{
   MulleProxy   *obj;

   obj = [self alloc];
   obj = [obj initNoLockWithObject:target];
   obj = [obj autorelease];
   return( obj);
}


static void   initWithTarget( MulleProxy *self, id target)
{
   self->__target         = [target retain];
   self->__taoStrategy    = [target mulleTAOStrategy];

   //
   // we don't do autoreleasepool manipulations
   //
   if( self->__taoStrategy < MulleObjCTAOReceiverPerformsFinalize)
      self->__taoStrategy = MulleObjCTAOReceiverPerformsFinalize;

   self->__gain_imp       = [target methodForSelector:@selector( mulleGainAccessWithTAOStrategy:)];
   self->__relinquish_imp = [target methodForSelector:@selector( mulleRelinquishAccessWithTAOStrategy:)];
}


- (instancetype) initNoLockWithObject:(id) target
{
   initWithTarget( self, target);
   return( self);
}


- (instancetype) initWithObject:(id) target
{
   initWithTarget( self, target);
   __lock = [NSRecursiveLock new];
   return( self);
}


- (void) dealloc
{
   [__target release];
   [__lock release];
   [super dealloc];
}


+ (instancetype) locklessObject
{
   abort();
   return( nil);
}


+ (instancetype) object
{
   abort();
   return( nil);
}


- (void *) forward:(void *) parameter
{
   NSRecursiveLock               *lock;
   void                          *rval;
   mulle_objc_methodid_t         methodid;

   methodid = (mulle_objc_methodid_t) _cmd;

   // it's vital, that we increment and decrement the identical lock
   // for performance reasons, we don't retain it (users responsibility
   // not to torch it)
   lock = self->__lock; // can be NULL
   if( lock)
   {
      _MulleObjCRecursiveLockLock( lock);
      mulle_objc_implementation_invoke( (mulle_objc_implementation_t) self->__gain_imp,
                                        self->__target,
                                        @selector( mulleGainAccessWithTAOStrategy:),
                                        (void *) self->__taoStrategy);
   }

#ifdef NDEBUG
   rval = mulle_objc_object_call_inline_full_variable( self->__target, methodid, parameter);
#else
   @try
   {
      rval = mulle_objc_object_call_inline_full_variable( self->__target, methodid, parameter);
   }
   @catch( id exception)
   {
      struct _mulle_objc_universe   *universe;

      universe = _mulle_objc_object_get_universe( self);
      __mulle_objc_universe_raise_internalinconsistency( universe,
                               "An exception %@ is passing thru a -[%@ %s] "
                               "method call, which will lead to a deadlock",
                               exception,
                               MulleObjCObjectGetClass( self),
                               mulle_objc_universe_lookup_methodname( universe, methodid));
   }
#endif

   if( lock)
   {
      mulle_objc_implementation_invoke( (mulle_objc_implementation_t) self->__relinquish_imp,
                                        self->__target,
                                        @selector( mulleRelinquishAccessWithTAOStrategy:),
                                        (void *) self->__taoStrategy);
      _MulleObjCRecursiveLockUnlock( lock);
   }

   return( rval);
}


#pragma mark - NSLocking


- (void) lock
{
   if( self->__lock)
      _MulleObjCRecursiveLockLock( self->__lock);
}


- (void) unlock
{
   if( self->__lock)
      _MulleObjCRecursiveLockUnlock( self->__lock);
}


- (BOOL) tryLock
{
   if( ! self->__lock)
      return( NO);
   return( _MulleObjCRecursiveLockTryLock( self->__lock));
}

#pragma mark - Lock sharing (could make this a protocolclass or ?)

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
   struct { @defs( MulleObject); } *_other = (void *) other;

   [self shareRecursiveLock:other ? _other->__lock : nil];
}


- (void) shareRecursiveLockWithProxy:(MulleProxy *) other
{
   [self shareRecursiveLock:other ? other->__lock : nil];
}


#pragma mark - TAO support

//
// check if an object can be safely accessed by a thread, use this for
// validatation and debugging only
- (BOOL) mulleIsThreadSafe          MULLE_OBJC_THREADSAFE_METHOD
{
   return( YES);
}


- (BOOL) mulleIsAccessible          MULLE_OBJC_THREADSAFE_METHOD
{
   return( YES);
}


- (BOOL) mulleIsAccessibleByThread:(NSThread *) threadObject   MULLE_OBJC_THREADSAFE_METHOD
{
   return( YES);
}


- (MulleObjCTAOStrategy) mulleTAOStrategy  MULLE_OBJC_THREADSAFE_METHOD
{
   return( MulleObjCTAOKnownThreadSafe);
}


- (void) mulleRelinquishAccess      MULLE_OBJC_THREADSAFE_METHOD
{
   [self retain];
}


- (void) mulleGainAccess      MULLE_OBJC_THREADSAFE_METHOD
{
   [self autorelease];
}


- (void) mulleGainAccessWithTAOStrategy:(MulleObjCTAOStrategy) strategy MULLE_OBJC_THREADSAFE_METHOD
{
   assert( strategy == MulleObjCTAOKnownThreadSafe);
   [self autorelease];
}


- (void) mulleRelinquishAccessWithTAOStrategy:(MulleObjCTAOStrategy) strategy MULLE_OBJC_THREADSAFE_METHOD
{
   assert( strategy == MulleObjCTAOKnownThreadSafe);
   [self retain];
}


#pragma mark - class introspection

- (Class) class                                MULLE_OBJC_THREADSAFE_METHOD
{
   return( [__target class]);
}


- (Class) superclass                           MULLE_OBJC_THREADSAFE_METHOD;
{
   return( [__target superclass]);
}


- (BOOL) isKindOfClass:(Class) otherClass      MULLE_OBJC_THREADSAFE_METHOD;
{
   return( [__target isKindOfClass:otherClass]);
}


- (BOOL) isMemberOfClass:(Class) otherClass    MULLE_OBJC_THREADSAFE_METHOD;
{
   return( [__target isMemberOfClass:otherClass]);
}


#pragma mark - protocol introspection

// mulleContainsProtocol checks only current class, not superclasses
- (BOOL) mulleContainsProtocol:(PROTOCOL) protocol  MULLE_OBJC_THREADSAFE_METHOD
{
   return( [__target mulleContainsProtocol:protocol]);
}


- (BOOL) conformsToProtocol:(PROTOCOL) protocol     MULLE_OBJC_THREADSAFE_METHOD;
{
   return( [__target conformsToProtocol:protocol]);
}


#pragma mark - method introspection and calls

- (IMP) methodForSelector:(SEL) sel                  MULLE_OBJC_THREADSAFE_METHOD
{
   return( [__target methodForSelector:sel]);
}

- (BOOL) respondsToSelector:(SEL) sel                MULLE_OBJC_THREADSAFE_METHOD
{
   return( [__target respondsToSelector:sel]);
}

- (NSMethodSignature *) methodSignatureForSelector:(SEL) sel    MULLE_OBJC_THREADSAFE_METHOD
{
   return( [__target methodSignatureForSelector:sel]);
}

@end

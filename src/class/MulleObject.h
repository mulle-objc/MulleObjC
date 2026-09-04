//
//  MulleObject.h
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
#ifdef __has_include
# if __has_include( "MulleDynamicObject.h")
#  import "MulleDynamicObject.h"
# endif
#endif

#import "import.h"

#import "NSLocking.h"
#import "NSRecursiveLock.h"


// Assume obj is of a subclass of MulleObject, which implements the
// method `-call:`
//
// When you execute [obj call:foo], the method will be found in the subclass
// and since its not a NSObject method, it will automagically lock the 
// instance with a NSRecursiveLock and unlock on exit. It is bad for -call to
// not catch exceptions, because then the unlock code is not executed. 
//
// [obj call:foo] 
//
// [obj]--isa-->[class]---->[array of methods]
//                 |
//                 v
//              [cache] --> callback
//
// [NSLock lock]
// <magie> (aufruf der Methode)  --> [cache] 
// [NSLock unlock]
//
// To make a subclass actually use the locking code, adorn it with
// MulleAutolockingObjectProtocols. This way you can use MulleObject
// as a base class for classes that do not aspire to be thread safe.
//
// All instance methods will be thread-safe, due to the whole class being
// marked MulleObjCThreadSafe. Special methods, that don't need (want) the
// automatic locking should be marked as MULLE_OBJC_THREADSAFE_METHOD. 
// Subclasses will also be marked as threadsafe during +initialize. If you 
// override +initialize in your subclass, you need to call +[super initialize].
//
// To search for methods in a subclass of MulleObject, you will need to
// specify the desired inheritance value manually. The cls->inheritance value
// of MulleObject will appear to be broken. This is basically the main
// trick MulleAutolockingObject uses and it can't be avoided.
//
@mixin MulleAutolockingObject

@optional
- (MulleObjCTAOStrategy) mulleTAOStrategy   MULLE_OBJC_THREADSAFE_METHOD;

@end


// this mulle-objc-runtime method user bit is taken by this class
// same as _mulle_objc_method_user_attribute_4
#define MULLE_OBJC_METHOD_USER_BIT_NOT_LOCKING   _mulle_objc_method_user_attribute_4

#define MULLE_OBJECT_SKIP_AUTOLOCKING_METHOD    MULLE_OBJC_THREADSAFE_METHOD

#define MulleAutolockingObjectProtocols   MulleObjCThreadSafe, MulleAutolockingObject


@interface MulleObject : MulleDynamicObject < NSLocking>
{
   NSRecursiveLock   *__lock;        // use __ to "hide" it
}


// for instances (like UIView) that share locks with other instances
// (via addSubview:), its clumsy to have a lock initially. These instances
// are non-threadsafe until they share a lock with another MulleObject
//
+ (instancetype) locklessObject;
- (instancetype) initNoLock;

// ??? what for: current philosophy is that we don't want the user to
//     lock manually...
- (BOOL) tryLock   MULLE_OBJECT_SKIP_AUTOLOCKING_METHOD;

//
// self will use "other" lock instead of own lock after this call. 
//
- (void) shareRecursiveLock:(NSRecursiveLock *) other;

// this will call shareRecursiveLock anyway, so need for double autolocking
- (void) shareRecursiveLockWithObject:(MulleObject *) other  MULLE_OBJECT_SKIP_AUTOLOCKING_METHOD;

// if you override -didShareRecursiveLock: you must call super
// this will not lock, as it should only be called from "inside" shareRecursiveLock:
// CAREFUL! `lock` is not guaranteed to be lockable at this point, you are in
// deadlock territory if you try to lock it
- (void) didShareRecursiveLock:(NSRecursiveLock *) lock     MULLE_OBJECT_SKIP_AUTOLOCKING_METHOD;


@end

// See MulleDynamicObject on how to forward:
#define MULLE_OBJECT_FORWARD_SUPERID   ((mulle_objc_superid_t) 0x53d27672)  // 'MulleObject;forward:'


//
// Declare your subclass like so:
//
// @interface Foo : MulleObject < MulleAutolockingObjectProtocols>
//
// In subclasses of Foo that are then **not threadsafe** put this in
//
// @interface Bar : Foo < MulleObjCThreadUnsafe>
//
// + (void) initialize
// {
//    MulleLockingObjectSetAutolockingEnabled( self, NO);
// }
//
// This is a bit clumsy, but we want to inherit from MulleObject,
// in MulleDynamicObject, but we don't want threadSafety always. We could use a
// protocolclass but in this special case, speed is really important as it
// hits most method calls. With the subclass we get the recursive lock
// location for free..
//
void   MulleLockingObjectSetAutolockingEnabled( Class self, BOOL flag);


void   MulleLockingObjectFillCache( MulleObject *self,
                                    SEL sel,
                                    IMP imp,
                                    BOOL isThreadAffine);



static inline void   _MulleObjectValueSetter( MulleObject *self,
                                              SEL _cmd,
                                              void *_param,
                                              char *objcType)
{
   _MulleDynamicObjectValueSetter( self, _cmd, _param, objcType);
}



static inline void   _MulleObjectNumberSetter( MulleObject *self,
                                               SEL _cmd,
                                               void *_param,
                                               char *objcType)
{
   _MulleDynamicObjectNumberSetter( self, _cmd, _param, objcType);
}


static inline void   _MulleObjectValueGetter( MulleObject *self,
                                              SEL _cmd,
                                              void *_param)
{
   _MulleDynamicObjectValueGetter( self, _cmd, _param);
}



// just an alias for _MulleDynamicObjectForward
MULLE_C_STATIC_ALWAYS_INLINE
void   *_MulleObjectForward( id self, SEL _cmd, void *args, int *fail)
{
   return( _MulleDynamicObjectForward( self, _cmd, args, fail));
}

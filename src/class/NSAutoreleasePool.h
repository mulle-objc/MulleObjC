//
//  NSAutoreleasePool.h
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
#import "NSObject.h"

#import "NSThread.h"

#import "MulleObjCAutoreleasePool.h"


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-root-class"


//
// if you feel the need to subclass this, change the
// NSAutoreleasePoolConfiguration, to use your functions
// Be careful when touching a running system
// This is not a subclass of NSObject, because it really is different
//
@interface NSAutoreleasePool
{
   NSAutoreleasePool   *_owner;
   void                *_storage;
}


+ (id) alloc;
+ (id) new;
- (id) init;
- (void) release;

+ (void) addObject:(id) object;
- (void) addObject:(id) object;

#pragma mark mulle additions:

+ (void) _addObjects:(id *) objects
               count:(NSUInteger) count;
- (void) _addObjects:(id *) objects
               count:(NSUInteger) count;

+ (NSAutoreleasePool *) _defaultAutoreleasePool;
+ (NSAutoreleasePool *) _parentAutoreleasePool;
- (NSAutoreleasePool *) _parentAutoreleasePool;

//
// these only check within the current thread, these routines are
// not fast as they search linearly. only useful for debugging
//
- (BOOL) _containsObject:(id) p;
- (NSUInteger) _countObject:(id) p;

+ (BOOL) _containsObject:(id) p;
+ (NSUInteger) _countObject:(id) p;

@end


#pragma clang diagnostic pop


//
// in MulleFoundation there is always a root NSAutoreleasePool, ergo this
// can't leak. Thread local autorelease pools don't have to be thread safe
//
static inline NSAutoreleasePool   *NSPushAutoreleasePool()
{
   struct _mulle_objc_poolconfiguration   *config;
   struct _mulle_objc_universe            *universe;

   universe = mulle_objc_global_inlineget_universe( MULLE_OBJC_DEFAULTUNIVERSEID);
   config   = mulle_objc_thread_get_poolconfiguration( universe);
   return( (*config->push)( config));
}


static inline void   NSPopAutoreleasePool( NSAutoreleasePool *pool)
{
   struct _mulle_objc_poolconfiguration   *config;
   struct _mulle_objc_universe            *universe;

   universe = mulle_objc_global_inlineget_universe( MULLE_OBJC_DEFAULTUNIVERSEID);
   config = mulle_objc_thread_get_poolconfiguration( universe);
   (*config->pop)( config, pool);
}


// the compiler will inline this directly
__attribute__((always_inline))
static inline id   NSAutoreleaseObject( id obj)
{
   if( obj)
      _MulleObjCAutoreleaseObject( obj);
   return( obj);
}


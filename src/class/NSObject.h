//
//  NSObject.h
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
#import "import.h"

#import "NSObjectProtocol.h"


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnullability-completeness"
#pragma clang diagnostic ignored "-Wcast-of-sel-type"
#pragma clang diagnostic ignored "-Wobjc-root-class"


//
// +load: mulle-objc-runtime guarantees, that the class and therefore the
//        superclass too is available. Messaging other classes in the same
//        shared library is wrong.
//
// +initialize: mulle-objc-runtime guarantees that +initialize is executed
//              only once per meta-class object.
//
@interface NSObject < NSObject>


// regular methods

//
// new does NOT call +alloc or +allocWithZone:
// override new too, if you override alloc
//
+ (instancetype) new;
+ (instancetype) alloc;
+ (instancetype) allocWithZone:(NSZone *) zone  __attribute__((deprecated("zones have no meaning and will eventually disappear")));   // deprecated

//
// if you subclass NSObject and override init, don't bother calling [super init]
//
- (instancetype) init;
- (void) dealloc;  /* ---> #2# */
- (void) finalize;

- (NSUInteger) hash;
- (BOOL) isEqual:(id) other;

- (Class) superclass;
- (Class) class;
- (instancetype) self;
- (BOOL) isKindOfClass:(Class) cls;
- (BOOL) isMemberOfClass:(Class) cls;

- (BOOL) conformsToProtocol:(PROTOCOL) protocol;
- (BOOL) respondsToSelector:(SEL) sel;
- (id) performSelector:(SEL) sel;
- (id) performSelector:(SEL) sel
            withObject:(id) obj;
- (id) performSelector:(SEL) sel
            withObject:(id) obj1
            withObject:(id) obj2;

- (BOOL) isProxy;

+ (Class) class;
+ (BOOL) isSubclassOfClass:(Class) cls;
+ (BOOL) instancesRespondToSelector:(SEL) sel;

- (IMP) methodForSelector:(SEL) sel;
+ (IMP) instanceMethodForSelector:(SEL) sel;


#pragma mark mulle additions

+ (void) removeClassValueForKey:(id) key;
+ (BOOL) insertClassValue:(id) value
                   forKey:(id) key;
+ (void) setClassValue:(id) value
                forKey:(id) key;

+ (id) classValueForKey:(id) key;

// AAO suport
+ (instancetype) instantiate;        // alloc + autorelease
- (instancetype) immutableInstance;  // copy + autorelease

+ (instancetype) instantiatedObject;      // alloc + autorelease + init -> new

- (char *) cStringDescription;  // returns autoreleased c string

- (void) _performFinalize;

// advanced Autorelease and ObjectGraph support

- (void) _becomeRootObject;        // retains  #1#
- (void) _resignAsRootObject;      // autoreleases
- (BOOL) _isRootObject;

- (void) _pushToParentAutoreleasePool;

// not part of NSObject protocol

/*
   Returns all objects, retained by this instance.
   This is not deep!

   Every class that stores objects in C-arrays, must
   implement this. Oherwise the default implementation
   is good enough.
 */
- (NSUInteger) _getOwnedObjects:(id *) objects
                         length:(NSUInteger) length;

@end



@class NSMethodSignature;
@class NSInvocation;

@interface NSObject ( Forwarding)

- (id) forwardingTargetForSelector:(SEL) sel;
- (void) doesNotRecognizeSelector:(SEL) sel;
- (NSMethodSignature *) methodSignatureForSelector:(SEL) sel;
+ (NSMethodSignature *) instanceMethodSignatureForSelector:(SEL) sel;

//
// subclasses should just override this, for best performance
//
- (void *) forward:(void *) _param;
- (void) forwardInvocation:(NSInvocation *) anInvocation;

@end

//
// These just memcpy. Objects embeddded into structs will not be retained (yet)
// I could do this in the future though.
//
int   _MulleObjCSetIvar( id self, mulle_objc_ivarid_t ivarid, void *buf, size_t size);
int   _MulleObjCGetIvar( id self, mulle_objc_ivarid_t ivarid, void *buf, size_t size);

//
// These functions do proper retain/assign/copy and autorelease previous
// contents.
//
id    MulleObjCGetObjectIvar( id self, mulle_objc_ivarid_t ivarid);
void  MulleObjCSetObjectIvar( id self, mulle_objc_ivarid_t ivarid, id value);


#pragma clang diagnostic pop

/*
 * #1# whenever you call [self retain] or don't return an object autoreleased,
 * chances are very high, this object is a root object (or could become one)
 */

/*
 * #2# dealloc will automatically write "nil/NULL" into your properties setter
 *     for pointers and objects. properties that are and properties
 *     w/o a setter won't be called
 */

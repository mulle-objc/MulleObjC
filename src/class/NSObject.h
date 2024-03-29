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
//
//
//              MulleObjC NSObject layout
//
//     -16   .---------------------.
//           | retainCount         |
//      -8   '---------------------'
//           | isa                 |
//      0    '---------------------'
//           |                     |
//           |                     |
//           |                     |
//           |                     |
//           |                     |
//           |                     |
//           '---------------------'
//
// other runtimes use a different layout and store the retainCount elsewhere
//
//                Apple NSObject layout
//      0    .---------------------.
//           | isa                 |
//      8    '---------------------'
//           |                     |
//           |                     |
//           |                     |
//           '---------------------'
//
//
// Instead of using the alloc/init/autorelease pattern, MulleObjC provides the
// +object method on NSObject subclasses to instantiate autoreleased objects
// without needing separate +alloc and -init calls. For example:
//
// Foo *s = [Foo object];
//
// Convenience constructor methods like -stringWithUTF8String: can also be used
// to construct autoreleased instances:
//
// NSString *s = [NSString stringWithUTF8String:"text"];
//
// The main advantage is skipping the verbose alloc/init step. In MulleObjC,
// all objects are autoreleased by default. When retained, they should not be
// -released but -autoreleased later (except in -dealloc which is special due to
// being always single threaded).
//
// References to objects are preferably kept in @properties, so retain/release
// is handled automatically by the compiler. Avoid manual retains and releases.
//
// MulleObjC code should use -object, convenience constructors and @properties
// to manage object lifetime. This results in clean, efficient code without
// explicit retain/release calls.

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

// will autorelease properties, except readonly ones!
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

// does not search superclasses
- (BOOL) mulleContainsProtocol:(PROTOCOL) protocol;

// Experimental
#if 0
+ (void) removeClassValueForKey:(id) key;
+ (BOOL) insertClassValue:(id) value
                   forKey:(id) key;
+ (void) setClassValue:(id) value
                forKey:(id) key;

+ (id) classValueForKey:(id) key;
#endif

// AAO suport
+ (instancetype) instantiate;             // alloc + autorelease
- (instancetype) immutableInstance;       // copy + autorelease

// TODO: call this just `object`
+ (instancetype) object;      // alloc + autorelease + init -> new

// old name
+ (instancetype) instantiatedObject;      // alloc + autorelease + init -> new

- (struct mulle_allocator *) mulleAllocator;
- (void) mullePerformFinalize;
- (BOOL) mulleIsFinalized;

// advanced Autorelease and ObjectGraph support

- (id) _becomeRootObject;          // retains  #1#, returns self
- (id) _resignAsRootObject;        // autoreleases, returns self
- (BOOL) _isRootObject;

- (id) _pushToParentAutoreleasePool;  // returns self

// not part of NSObject protocol

/*
   Return all instances retained by static variables managed by the class.
   This is not deep!
   This should also be part of a category that keeps static instances.
 */

+ (NSUInteger) _getOwnedObjects:(id *) objects
                       maxCount:(NSUInteger) maxCount;

/*
   Returns all objects, retained by this instance.
   This is not deep!

   Every class that stores objects in C-arrays, must
   implement this. Otherwise the default implementation
   is good enough.

   Returns needed length if objects and length is NULL.
 */
- (NSUInteger) _getOwnedObjects:(id *) objects
                       maxCount:(NSUInteger) maxCount;

- (BOOL) __isSingletonObject;
- (BOOL) __isClassClusterObject;

@end



@class NSMethodSignature;
@class NSInvocation;


@interface NSObject ( RuntimeInit)

//
// Preferably do not use ObjC or objc runtime calls in these
// (then everything is easy). If you do though, you MUST specify
// MULLE_OBJC_DEPENDS_ON_LIBRARY (preferably) or
// MULLE_OBJC_DEPENDS_ON_CLASS. MULLE_OBJC_DEPENDS_ON_LIBRARY is the safer
// choice, due to class cluster initialization. Be sure that what you call
// is where you expect it to be.
//
+ (void) initialize;
+ (void) load;

@end

// class methods available, because NSObject is root
@interface NSObject ( WrapAround)

+ (BOOL) mulleContainsProtocol:(PROTOCOL) protocol;

@end

@interface NSObject ( Forwarding)

- (id) forwardingTargetForSelector:(SEL) sel;
- (void) doesNotRecognizeSelector:(SEL) sel;
- (NSMethodSignature *) methodSignatureForSelector:(SEL) sel;
+ (NSMethodSignature *) instanceMethodSignatureForSelector:(SEL) sel;

//
// subclasses should override forward:, for best performance. But it can be
// tricky!
//
// IMPORTANT!! Do not call [super forward:] as the forwarded selector
// is contained in _cmd and would be clobbered by a regular method call
// instead use _mulle_objc_object_superlookup_implementation_inline_nofail and
// them send _cmd and args as received.
//
// Use the tool mulle-objc-uniqueid with '<yourclassname>;forward:' to create
// a superid. Use this to lookup the implementation of super. Call it.
// Don't forget to register the corresponding _mulle_objc_super in the universe.
// You can dos this with:
//
// + (void) dontevercallme
// {
//    [super forward:];  // compiler will create the _mulle_objc_super.
// }
// - (void *) forward:(void *) param
// {
// #define MYID  0x????????
//    IMP   imp;
//    imp = _mulle_objc_object_superlookup_implementation_inline_nofail( self, MYID);
//    return( (*imp)( self, _cmd, args));
// }


- (void *) forward:(void *) param;

- (void) forwardInvocation:(NSInvocation *) anInvocation;

@end


@interface NSObject( UTF8String)

//
// why is this not mulle_utf8_t ? In mulle-objc char * in Objective-C is
// defined to be UTF8.
//
- (char *) UTF8String;  // used to be cStringDescription

// you can use mulle_fprintf( "%#@") to trigger this colorization method
- (char *) colorizedUTF8String;  // used to be cStringDescription

// color code to be placed in front of UTF8String (NULL for no colorization)
// default NULL
//
// ## Color picker
//
// for code in {0..255}
// do
//    printf "%b\n" "\\033[38;5;${code}m"'\\033[38;5;'"${code}"m"\\033[0m"
// done
//
- (char *) colorizerPrefixUTF8String;

// color code to be placed in the back of UTF8String (can't be NULL)
// default "\033[0m" should reset the color back to normal
- (char *) colorizerSuffixUTF8String;

@end


//
// These just memcpy. Objects embeddded into structs will not be retained (yet)
// I could do this in the future though.
//
MULLE_OBJC_GLOBAL
int   _MulleObjCObjectSetIvar( id self, mulle_objc_ivarid_t ivarid, void *buf, size_t size);

MULLE_OBJC_GLOBAL
int   _MulleObjCObjectGetIvar( id self, mulle_objc_ivarid_t ivarid, void *buf, size_t size);

//
// These functions do proper retain/assign/copy and autorelease previous
// contents.
//
MULLE_OBJC_GLOBAL
id    MulleObjCObjectGetObjectIvar( id self, mulle_objc_ivarid_t ivarid);

MULLE_OBJC_GLOBAL
void  MulleObjCObjectSetObjectIvar( id self, mulle_objc_ivarid_t ivarid, id value);


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

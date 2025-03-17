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

#import "MulleObjCRootObject.h"



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
// For example:
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

@interface NSObject < MulleObjCRootObject, NSObject>

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
+ (instancetype) instantiate;             // alloc + delayed autorelease

//
// TODO: call this `instance` ?? We have class which is made up of
// a metaclass and an infraclass, it produces instance of a class,
// all of them are objects. But an instance is not a class. So the
// "wrapping" name for all is probably still object. So why is the
// method to produce instances called object ?
//
+ (instancetype) object;      // alloc + init + autorelease
//+ (instancetype) instance;  // synonym this once the compiler knows how to

- (BOOL) __isSingletonObject;       // here object is a valid name as it fits instance and class
- (BOOL) __isClassClusterObject;

+ (void) mulleInterposeBeforeClass:(Class) subClass;

@end



@class NSMethodSignature;
@class NSInvocation;
@class NSThread;


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

+ (NSMethodSignature *) instanceMethodSignatureForSelector:(SEL) sel;

- (id) forwardingTargetForSelector:(SEL) sel                     MULLE_OBJC_THREADSAFE_METHOD;
- (void) doesNotRecognizeSelector:(SEL) sel                      MULLE_OBJC_THREADSAFE_METHOD;
- (NSMethodSignature *) methodSignatureForSelector:(SEL) sel     MULLE_OBJC_THREADSAFE_METHOD;

//
// subclasses should override forward:, for best performance. But it can be
// tricky!
//
// IMPORTANT!! Do not call [super forward:] as the forwarded selector
// is contained in _cmd and would be clobbered by a regular method call
// instead use _mulle_objc_object_lookup_superimplementation_inline_nofail and
// them send _cmd and param as received.
// TODO: the compilers should so this transparently IMO.
//
// Use the tool mulle-objc-uniqueid with '<yourclassname>;forward:' to create
// a superid. Use this to lookup the implementation of super then call it.
// Don't forget to register the corresponding _mulle_objc_super in the universe.
// You can do this with a dummy method like `registerForwardSuper`:
//
// ```
// #define MYID   (mulle_objc_superid_t) 0x???????? // '<yourclassname>;forward:'
//
// + (void) registerForwardSuper  // do not call
// {
//    [super forward:NULL];  // compiler will create the _mulle_objc_super.
// }
//
// - (void *) forward:(void *) param
// {
//    IMP   imp;
//
//    imp = _mulle_objc_object_lookup_superimplementation_inline_nofail( self, MYID);
//    return( (*imp)( self, _cmd, param));
// }
// ```
//
// forward itself is thread-safe, but the method that is called may not be
// which is fine. That method is then supposed to fail and not forward:
//
- (void *) forward:(void *) param                           MULLE_OBJC_THREADSAFE_METHOD;
- (void) forwardInvocation:(NSInvocation *) anInvocation    MULLE_OBJC_THREADSAFE_METHOD;

@end

#define NS_OBJECT_FORWARD_SUPERID   ((mulle_objc_superid_t) 0x3ab7a97b)  // 'NSObject;forward:'


@interface NSObject( UTF8String)

//
// why is this not mulle_utf8_t ? In mulle-objc char * in Objective-C is
// defined to be UTF8. The returned string is either a static string or
// autoreleased (!)
//
- (char *) UTF8String;  // used to be cStringDescription

// you can use mulle_fprintf( "%#@") to trigger this colorization method
// as this is used in debugging, the methods must be threadSafe (in contrast
// to -UTF8String)

- (char *) threadSafeUTF8String        MULLE_OBJC_THREADSAFE_METHOD;  // used to be cStringDescription
- (char *) colorizedUTF8String         MULLE_OBJC_THREADSAFE_METHOD;

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
- (char *) colorizerPrefixUTF8String   MULLE_OBJC_THREADSAFE_METHOD;

// color code to be placed in the back of UTF8String (can't be NULL)
// default "\033[0m" should reset the color back to normal
- (char *) colorizerSuffixUTF8String   MULLE_OBJC_THREADSAFE_METHOD;

@end


@interface NSObject( NSCopying)

- (id) copiedInstance;
- (id) immutableInstance;

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

MULLE_OBJC_GLOBAL
void  MulleObjCClassInterposeBeforeClass( Class self, Class other);


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

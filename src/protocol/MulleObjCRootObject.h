// we want "import.h" always anyway
#import "import.h"

#import "MulleObjCRuntimeObject.h"


@class NSMethodSignature;

//
// TODO: for code reuse, give this NSObject as a protocolclass ?
//
// Useful for classes, that do not want the whole NSObject baggage
// especially added by categories. Chiefly used forwarding classes.
//
PROTOCOLCLASS_INTERFACE( MulleObjCRootObject, MulleObjCRuntimeObject)

@optional

#pragma mark - object storage and removal

+ (instancetype) alloc;
+ (instancetype) allocWithZone:(NSZone *) zone;
+ (instancetype) new;
- (NSZone *) zones                              MULLE_OBJC_THREADSAFE_METHOD;  // always NULL
- (struct mulle_allocator *) mulleAllocator     MULLE_OBJC_THREADSAFE_METHOD;
- (void) mullePerformFinalize                   MULLE_OBJC_THREADSAFE_METHOD;
- (BOOL) mulleIsFinalized                       MULLE_OBJC_THREADSAFE_METHOD;
- (void) finalize;
- (void) dealloc;


# pragma mark - regular methods

- (instancetype) init;


#pragma mark - lifetime management

// this is basically mulle-objc-runtime/mulle-objc-retain-release.h
- (instancetype) retain             MULLE_OBJC_THREADSAFE_METHOD;
- (void) release                    MULLE_OBJC_THREADSAFE_METHOD;
- (NSUInteger) retainCount          MULLE_OBJC_THREADSAFE_METHOD;
- (instancetype) autorelease        MULLE_OBJC_THREADSAFE_METHOD;

#pragma mark - thread safety introspection

- (BOOL) mulleIsThreadSafe          MULLE_OBJC_THREADSAFE_METHOD;
+ (BOOL) mulleIsThreadSafe;

#pragma mark - thread affinity

// check if an object can be safely accessed by a thread, use this for
// validatation and debugging only
- (BOOL) mulleIsThreadSafe          MULLE_OBJC_THREADSAFE_METHOD;
- (BOOL) mulleIsAccessible          MULLE_OBJC_THREADSAFE_METHOD;
- (BOOL) mulleIsAccessibleByThread:(NSThread *) threadObject   MULLE_OBJC_THREADSAFE_METHOD;

// if you pass an object from one thread to another the sender does
// a relinquish and the receiver does a gain. For objects that are threadsafe
// already, this does nothing
- (void) mulleGainAccess            MULLE_OBJC_THREADSAFE_METHOD;
- (void) mulleRelinquishAccess      MULLE_OBJC_THREADSAFE_METHOD;


#pragma mark - class introspection

- (Class) class                                MULLE_OBJC_THREADSAFE_METHOD;
+ (Class) class;
- (Class) superclass                           MULLE_OBJC_THREADSAFE_METHOD;
+ (BOOL) isSubclassOfClass:(Class) otherClass  MULLE_OBJC_THREADSAFE_METHOD;
- (BOOL) isKindOfClass:(Class) otherClass      MULLE_OBJC_THREADSAFE_METHOD;
- (BOOL) isMemberOfClass:(Class) otherClass    MULLE_OBJC_THREADSAFE_METHOD;

#pragma mark - protocol introspection

// mulleContainsProtocol checks only current class, not superclasses
- (BOOL) mulleContainsProtocol:(PROTOCOL) protocol  MULLE_OBJC_THREADSAFE_METHOD;
- (BOOL) conformsToProtocol:(PROTOCOL) protocol     MULLE_OBJC_THREADSAFE_METHOD; 


#pragma mark - method introspection and calls

- (id) performSelector:(SEL) sel                    MULLE_OBJC_THREADSAFE_METHOD;

- (id) performSelector:(SEL) sel
            withObject:(id) obj                     MULLE_OBJC_THREADSAFE_METHOD;

- (id) performSelector:(SEL) sel
            withObject:(id) obj1
            withObject:(id) obj2                    MULLE_OBJC_THREADSAFE_METHOD;

+ (IMP) instanceMethodForSelector:(SEL) sel;
+ (BOOL) instancesRespondToSelector:(SEL) sel;
+ (NSMethodSignature *) instanceMethodSignatureForSelector:(SEL) sel;

- (IMP) methodForSelector:(SEL) sel                  MULLE_OBJC_THREADSAFE_METHOD;
- (BOOL) respondsToSelector:(SEL) sel                MULLE_OBJC_THREADSAFE_METHOD;

- (NSMethodSignature *) methodSignatureForSelector:(SEL) sel    MULLE_OBJC_THREADSAFE_METHOD;


// this is not "official" API it might go away
#pragma mark - universe owned objects

+ (NSUInteger) _getRootObjects:(id *) buf
                      maxCount:(NSUInteger) maxCount  MULLE_OBJC_THREADSAFE_METHOD;
- (BOOL) _isRootObject                                MULLE_OBJC_THREADSAFE_METHOD;
- (id) _becomeRootObject                              MULLE_OBJC_THREADSAFE_METHOD;
- (id) _resignAsRootObject                            MULLE_OBJC_THREADSAFE_METHOD;
- (id) _pushToParentAutoreleasePool                   MULLE_OBJC_THREADSAFE_METHOD;


PROTOCOLCLASS_END();


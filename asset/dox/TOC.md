# MulleObjC Library Documentation for AI
<!-- Keywords: objc, runtime, root-classes, threading, autorelease, mixin -->
## 1. Introduction & Purpose

**MulleObjC** is the foundational Objective-C library for the mulle-objc ecosystem. It provides the complete set of root classes (`NSObject`, `NSProxy`), core protocols (`NSCoding`, `NSCopying`, `NSFastEnumeration`, `NSLocking`), threading support (`NSThread`), memory management (`NSAutoreleasePool`), method serialization (`NSInvocation`, `NSMethodSignature`), value boxed types (`NSValue`), and essential utilities for dynamic Objective-C programming on top of the mulle-objc runtime.

**Key Features:**
- Complete Objective-C root class hierarchy (NSObject, NSProxy, NSAutoreleasePool)
- Method serialization with MetaABI-optimized invocation (NSInvocation, NSMethodSignature)
- Thread support with platform abstraction (NSThread, NSLock, NSCondition, NSConditionLock, NSRecursiveLock)
- Autorelease pool management (NSAutoreleasePool)
- Exception handling macros (MulleObjCThrow*Exception)
- Dynamic type introspection utilities
- Thread Affinity & Ownership (TAO) system for safe cross-thread object transfer
- @mixin-based protocol classes replacing old PROTOCOLCLASS macros
- Value boxing (NSValue, _MulleObjCConcreteValue)
- Class dependency declaration via `@dependency` directive
- Static method signatures via `_NSConstantMethodSignature`
- Zero C standard library dependencies (portable)

## 2. Key Concepts & Design Philosophy

- **Two Root Classes**: `NSObject` (standard) and `NSProxy` (for dynamic forwarding/proxies). `NSAutoreleasePool` is also technically a root object (not a subclass of NSObject).
- **Automatic Allocation Optimization (AAO)**: Factory method `+instantiate` creates pre-autoreleased placeholders; `+alloc` combined with `-init` patterns are replaced by AAO-style factory instantiation.
- **Memory Model**: Retain/release counting with `NSAutoreleasePool` for batch deallocation.
- **@mixin Protocol Classes**: Formerly implemented via `PROTOCOLCLASS_INTERFACE` macros, protocol classes (e.g., `MulleObjCSingleton`, `MulleObjCClassCluster`, `MulleObjCThreadSafe`) are now declared with the `@mixin` keyword. These provide default implementations for protocol methods without requiring protocol conformance in subclasses.
- **Thread Affinity & Ownership (TAO)**: System for safely transferring objects between threads. `MulleObjCTAOStrategy` enum defines strategies for pool removal and thread handoff. Objects marked `MulleObjCThreadSafe` bypass TAO checks.
- **Thread Safety Protocols Hierarchy**: `MulleObjCThreadUnsafe` → `MulleObjCThreadSafe` → `MulleObjCImmutable` → `MulleObjCInvariant` → `MulleObjCValue`. Each level adds stronger guarantees.
- **C-Only Core**: MulleObjC depends on the mulle-objc-runtime C library and mulle-thread, not standard C libraries.
- **@dependency Directive**: Classes declare dependencies using the compiler directive `@dependency ClassName` or `@dependency LibDepsName(libname)` instead of the old `MULLE_OBJC_DEPENDS_ON_*` macros.
- **MetaABI Optimization**: NSMethodSignature and NSInvocation use MetaABI type information (`MulleObjCMetaABICallType`) for accelerated invocation frame computation.

## 3. Core API & Data Structures

### 3.1 Root Classes: NSObject & NSProxy

#### NSObject - The Standard Root Class
**Header**: `src/class/NSObject.h`
**Declaration**: `@interface NSObject < MulleObjCRootObject, NSObject>`
**Purpose**: Root class for all objects in typical Objective-C hierarchies. Provides lifecycle, reference counting, memory management, introspection, and message dispatching.

**Lifecycle Methods:**
- `+ (instancetype) alloc` — Creates uninitialized instance
- `+ (instancetype) new` — Shortcut: `[[self alloc] init]`
- `- (instancetype) init` — Designated initializer
- `- (void) dealloc` — Destructor, called when retain count reaches zero
- `- (void) finalize` — Pre-dealloc cleanup, called before dealloc
- `- (void) mullePerformFinalize MULLE_OBJC_THREADSAFE_METHOD` — Triggers finalize chain
- `- (BOOL) mulleIsFinalized MULLE_OBJC_THREADSAFE_METHOD` — Query finalize state
- `+ (instancetype) instantiate` — AAO factory, returns autoreleased placeholder

**Reference Counting:**
- `- (instancetype) retain MULLE_OBJC_THREADSAFE_METHOD` — Increment reference count
- `- (void) release MULLE_OBJC_THREADSAFE_METHOD` — Decrement reference count
- `- (instancetype) autorelease MULLE_OBJC_THREADSAFE_METHOD` — Add to current pool
- `- (NSUInteger) retainCount MULLE_OBJC_THREADSAFE_METHOD` — Current count

**Introspection & Method Dispatch:**
- `- (Class) class MULLE_OBJC_THREADSAFE_METHOD`
- `+ (Class) class MULLE_OBJC_THREADSAFE_METHOD`
- `- (Class) superclass MULLE_OBJC_THREADSAFE_METHOD`
- `- (BOOL) isKindOfClass:(Class) cls MULLE_OBJC_THREADSAFE_METHOD`
- `- (BOOL) isMemberOfClass:(Class) cls MULLE_OBJC_THREADSAFE_METHOD`
- `- (BOOL) respondsToSelector:(SEL) sel MULLE_OBJC_THREADSAFE_METHOD`
- `- (BOOL) conformsToProtocol:(PROTOCOL) protocol MULLE_OBJC_THREADSAFE_METHOD`
- `- (id) performSelector:(SEL) sel MULLE_OBJC_THREADSAFE_METHOD`
- `- (id) performSelector:(SEL) sel withObject:(id) obj MULLE_OBJC_THREADSAFE_METHOD`
- `- (id) performSelector:(SEL) sel withObject:(id) obj withObject:(id) other MULLE_OBJC_THREADSAFE_METHOD`
- `- (IMP) methodForSelector:(SEL) sel MULLE_OBJC_THREADSAFE_METHOD`
- `+ (IMP) instanceMethodForSelector:(SEL) sel`
- `+ (BOOL) instancesRespondToSelector:(SEL) sel`
- `- (NSMethodSignature *) methodSignatureForSelector:(SEL) sel MULLE_OBJC_THREADSAFE_METHOD`
- `+ (NSMethodSignature *) instanceMethodSignatureForSelector:(SEL) sel`

**Object Comparison & Hashing:**
- `- (BOOL) isEqual:(id) other` — Default: pointer equality
- `- (NSUInteger) hash` — Hash for use in collections
- `- (char *) UTF8String` — Malloced C-string description (mulle extension)

**Thread Safety Introspection (TAO):**
- `- (BOOL) mulleIsThreadSafe MULLE_OBJC_THREADSAFE_METHOD`
- `+ (BOOL) mulleIsThreadSafe MULLE_OBJC_THREADSAFE_METHOD`
- `- (void) mulleSetThreadSafe:(BOOL) flag`
- `- (BOOL) mulleIsAccessible MULLE_OBJC_THREADSAFE_METHOD`
- `- (BOOL) mulleIsAccessibleByThread:(NSThread *) threadObject MULLE_OBJC_THREADSAFE_METHOD`
- `- (BOOL) mulleIsAutoreleased`
- `- (void) mulleGainAccess MULLE_OBJC_THREADSAFE_METHOD`
- `- (void) mulleGainAccessWithTAOStrategy:(MulleObjCTAOStrategy) strategy MULLE_OBJC_THREADSAFE_METHOD`
- `- (void) mulleRelinquishAccess MULLE_OBJC_THREADSAFE_METHOD`
- `- (void) mulleRelinquishAccessWithTAOStrategy:(MulleObjCTAOStrategy) strategy MULLE_OBJC_THREADSAFE_METHOD`
- `- (MulleObjCTAOStrategy) mulleTAOStrategy MULLE_OBJC_THREADSAFE_METHOD`

**Forwarding:**
- `- (void) forwardInvocation:(NSInvocation *) anInvocation` — Message forwarding hook
- `- (NSMethodSignature *) methodSignatureForSelector:(SEL) sel MULLE_OBJC_THREADSAFE_METHOD`

**Copy & Archive Support via NSCoding:**
- `- (id) copy`
- `- (void) encodeWithCoder:(NSCoder *) coder`
- `- (instancetype) initWithCoder:(NSCoder *) coder`

#### NSProxy - Alternative Root for Dynamic Proxies
**Header**: `src/class/NSProxy.h`
**Declaration**: `@interface NSProxy < MulleObjCRootObject, NSObject>`
**Purpose**: An alternative root class for forwarding proxies. Does not extend NSObject; instead conforms to `<NSObject>` protocol.

**Key Methods (inherited from protocols):**
- `+ (instancetype) alloc`
- `- (void) dealloc`
- `- (void) forwardInvocation:(NSInvocation *) inv`
- `- (NSMethodSignature *) methodSignatureForSelector:(SEL) selector`

### 3.2 Method Serialization & Introspection

#### NSMethodSignature - Method Metadata (Redesigned)
**Header**: `src/class/NSMethodSignature.h`
**Declaration**: `@interface NSMethodSignature : NSObject < MulleObjCImmutableProtocols, NSCopying>`

**Key Ivar Layout:**
```c
uint32_t                            _bits;    // method descriptor bits; bits 22-23=rType, 24-25=pType
uint16_t                            _count;
uint16_t                            _extra;
char                                *_types;
uint32_t                            _invocationSize;
uint32_t                            _reserved;
MulleObjCMethodSignatureTypeInfo    _infos[3]; // inline for minimum (rval,self,_cmd); overflow in extra bytes
```

Note: `_infos` is now an inline array of 3 rather than a pointer. Additional arginfos are stored in the extra bytes area, and the types string follows for dynamic instances.

**MetaABI Types:**
```c
typedef enum {
   MulleObjCMetaABITypeVoidPointer    = 0,
   MulleObjCMetaABITypeVoid           = 1,
   MulleObjCMetaABITypeParameterBlock = 2
} MulleObjCMetaABIType;

typedef enum {
   MulleObjCMetaABICallVoidPtrVoidPtr = 0,   // -(id)foo:(id) — DEFAULT
   MulleObjCMetaABICallVoidPtrVoid    = 1,   // -(void)foo:(id)
   MulleObjCMetaABICallVoidPtrBlock   = 2,   // -(struct S)foo:(id)
   MulleObjCMetaABICallVoidVoidPtr    = 4,   // -(id)foo
   MulleObjCMetaABICallVoidVoid       = 5,   // -(void)foo
   MulleObjCMetaABICallVoidBlock      = 6,   // -(struct S)foo
   MulleObjCMetaABICallBlockVoidPtr   = 8,   // -(id)foo:(int)x ...
   MulleObjCMetaABICallBlockVoid      = 9,   // -(void)foo:(int)x ...
   MulleObjCMetaABICallBlockBlock     = 10,  // -(struct S)foo:(int)x ...
} MulleObjCMetaABICallType;
```

**Static Instance**: `_NSConstantMethodSignature` struct enables compile-time static method signature objects, placed into the universe via `_mulle_objc_universe_add_staticinstance()`. Slot index `MULLE_OBJC_STATICINSTANCE_METHODSIGNATURE_INDEX = 4`.
```c
struct _NSConstantMethodSignature {
   struct _mulle_objc_objectheader   _header;
   uint32_t                          _bits;
   uint16_t                          _count;
   uint16_t                          _extra;
   char                              *_types;
   uint32_t                          _invocationSize;
   uint32_t                          _reserved;
   MulleObjCMethodSignatureTypeInfo  _infos[3];
};
#define MULLE_OBJC_CONSTANTMETHODSIGNATURE_OBJECT( p)  ((struct _mulle_objc_object *) &(p)->_bits)
```

**Creation:**
- `+ (NSMethodSignature *) signatureWithObjCTypes:(char *) types` — Standard creation
- `+ (NSMethodSignature *) _signatureWithObjCTypes:(char *) types descriptorBits:(NSUInteger) bits` — With descriptor bits (used by forwarding)

**Accessors:**
- `- (BOOL) isOneway`
- `- (BOOL) isVariadic`
- `- (NSUInteger) _descriptorBits`
- `- (NSUInteger) frameLength`
- `- (NSUInteger) methodReturnLength`
- `- (char *) methodReturnType`
- `- (char *) getArgumentTypeAtIndex:(NSUInteger) index` — Uses argument index (0 = self)
- `- (NSUInteger) numberOfArguments`
- `- (NSUInteger) mulleInvocationSize` — Extra bytes to allocate for NSInvocation
- `- (MulleObjCMetaABIType) _methodMetaABIReturnType`
- `- (MulleObjCMetaABIType) _methodMetaABIParameterType`
- `- (NSUInteger) mulleMetaABIFrameLength` — Expected size of a call frame
- `- (MulleObjCMethodSignatureTypeInfo *) mulleSignatureTypeInfoAtIndex:(NSUInteger) i` — Uses internal index (0 = rval, 1 = self, etc.)

#### NSInvocation - Message Recording & Replay (Redesigned)
**Header**: `src/class/NSInvocation.h`
**Declaration**: `@interface NSInvocation : NSObject`

**Key Ivar Fields:**
```c
char   *_storage;
char   *_sentinel;
char   _argumentsRetained;
char   _returnValueRetained;
IMP    _implementation;   // optional: direct IMP call instead of objc_msgSend
```

NSInvocation is variable-sized: `_storage` expands/contracts with MetaABI parameters.

**Property:**
- `@property( retain, readonly) NSMethodSignature *methodSignature`

**Factory Methods:**
- `+ (NSInvocation *) invocationWithMethodSignature:(NSMethodSignature *) signature` — Create with signature
- `+ (NSInvocation *) mulleInvocationWithTarget:(id) target selector:(SEL) sel, ...` — Build from variadic args
- `+ (NSInvocation *) mulleInvocationWithTarget:(id) target selector:(SEL) sel methodSignature:(NSMethodSignature *) sig, ...`
- `+ (NSInvocation *) mulleInvocationWithTarget:(id) target selector:(SEL) sel object:(id) object` — Single object arg
- `+ (NSInvocation *) mulleInvocationWithTarget:(id) target selector:(SEL) sel metaABIFrame:(void *) frame` — From prebuilt MetaABI frame
- `+ (NSInvocation *) mulleInvocationWithTarget:(id) target selector:(SEL) sel implementation:(IMP) imp object:(id) object` — With custom IMP

**IMP Access:**
- `- (IMP) implementation`
- `- (void) setImplementation:(IMP) imp`

**Execution:**
- `- (void) invoke` — Dispatch to target using stored selector/IMP
- `- (void) invokeWithTarget:(id) target` — Override target for this invocation
- `- (int) mulleIntReturnValue` — Get int return value (used by NSThread)

**Inspection:**
- `- (BOOL) argumentsRetained`
- `- (BOOL) mulleReturnValueRetained`
- `- (void) _setMetaABIFrame:(void *) frame`

**MulleBasicAccessors Category (`NSInvocation(MulleBasicAccessors)`):**
- `- (void) getReturnValue:(void *) value_p`
- `- (void) setReturnValue:(void *) value_p`
- `- (void) getArgument:(void *) value_p atIndex:(NSUInteger) i`
- `- (void) setArgument:(void *) value_p atIndex:(NSUInteger) i`
- `- (SEL) selector`
- `- (void) setSelector:(SEL) selector`
- `- (id) target`
- `- (void) setTarget:(id) target`
- `- (void) retainArguments` — Retain all object arguments
- `- (void) mulleRetainReturnValue`

**C Function:**
- `NSInvocation *NSInvocationCreateWithMetaABIFrame(NSMethodSignature *sig, id target, SEL sel, void *frame, IMP imp)` — Compiler support: creates invocation from prebuilt MetaABI frame

### 3.3 Synchronization Primitives

#### NSLock - Basic Mutual Exclusion
**Header**: `src/class/NSLock.h`
**Declaration**: `@interface NSLock : NSObject < NSLocking, MulleObjCThreadSafe>`
**Ivar**: `mulle_thread_mutex_t _lock`

- `- (void) lock` — Acquire (blocking)
- `- (void) unlock` — Release
- `- (BOOL) tryLock` — Non-blocking acquire
- `- (BOOL) lockBeforeTimeInterval:(mulle_timeinterval_t) timeInterval` — Timed lock

#### NSRecursiveLock - Reentrant Lock
**Header**: `src/class/NSRecursiveLock.h`
**Declaration**: `@interface NSRecursiveLock : NSLock`
**Ivars**: `mulle_atomic_pointer_t _thread_id; mulle_atomic_pointer_t _depth`
**Implementation note**: delegates to `mulle_thread_recursive_mutex_t` via `NSRecursiveLock-Private.h`. Inherits `-lock`, `-unlock`, `-tryLock` from `NSLock`.

#### NSCondition - Wait/Signal with Lock
**Header**: `src/class/NSCondition.h`
- `- (void) lock` / `- (void) unlock`
- `- (void) wait` — Release lock, wait for signal, reacquire
- `- (BOOL) waitUntilDate:(NSDate *) limit` — Wait with timeout
- `- (void) signal` — Wake one waiting thread
- `- (void) broadcast` — Wake all

#### NSConditionLock - Condition + Integer State
**Header**: `src/class/NSConditionLock.h`
- `- (void) lockWhenCondition:(int) condition`
- `- (BOOL) tryLockWhenCondition:(int) condition`
- `- (void) unlockWithCondition:(int) condition`
- `- (int) condition`

### 3.4 Threading: NSThread
**Header**: `src/class/NSThread.h`
**Declaration**: `@interface NSThread : NSObject < MulleObjCThreadSafe>`

**Class Methods:**
- `+ (NSThread *) mainThread`
- `+ (NSThread *) currentThread` — Crashes if not a MulleObjC thread
- `+ (BOOL) mulleIsMainThread`
- `+ (BOOL) isMultiThreaded`
- `+ (BOOL) mulleIsMultiThreaded`
- `+ (BOOL) mulleMainThreadWaitsAtExit`
- `+ (void) mulleSetMainThreadWaitsAtExit:(BOOL) flag`
- `+ (void) detachNewThreadSelector:(SEL) sel toTarget:(id) target withObject:(id) argument`
- `+ (void) mulleDetachNewThreadWithInvocation:(NSInvocation *) invocation`
- `+ (void) mulleDetachNewThreadWithFunction:(MulleThreadFunction_t *) f argument:(void *) argument`
- `+ (void) exit`

**Instance Creation:**
- `- (instancetype) initWithTarget:(id) target selector:(SEL) sel object:(id) argument`
- `- (instancetype) mulleInitWithFunction:(MulleThreadFunction_t *) f argument:(void *) argument`
- `- (instancetype) mulleInitWithObjectFunction:(MulleThreadObjectFunction_t) f object:(id) obj`
- `- (instancetype) mulleInitWithInvocation:(NSInvocation *) invocation`

**Static Factory Methods:**
- `+ (instancetype) mulleThreadWithTarget:(id) target selector:(SEL) sel object:(id) argument`
- `+ (instancetype) mulleThreadWithFunction:(MulleThreadFunction_t *) f argument:(void *) argument`
- `+ (instancetype) mulleThreadWithObjectFunction:(MulleThreadObjectFunction_t) f object:(id) obj`
- `+ (instancetype) mulleThreadWithInvocation:(NSInvocation *) invocation`

**Runtime:**
- `- (void) mulleStart` — Start thread (preferred: keep NSThread, later mulleJoin)
- `- (void) start` — Legacy: runs detached
- `- (NSInvocation *) mulleJoin` — Wait for thread to finish, return invocation
- `- (id) mulleSetRunLoop:(id) runLoop`
- `- (id) mulleRunLoop`
- `- (void) main` — Thread entry point
- `- (int) mulleReturnStatus`
- `- (BOOL) isCancelled` / `- (void) cancel` — Cooperative cancellation
- `- (BOOL) wasAutocreated`
- `- (void) mulleAddFinalizer:(id) obj` / `- (void) mulleRemoveFinalizer:(id) obj`
- `- (void) mulleSetNameUTF8String:(char *) s MULLE_OBJC_THREADSAFE_METHOD`
- `- (char *) mulleNameUTF8String MULLE_OBJC_THREADSAFE_METHOD`

**C Utilities:**
- `NSThread *MulleThreadGetCurrentThread(void)` — Get NSThread for current OS thread
- `NSThread *MulleThreadGetOrCreateCurrentThread(void)`
- `void MulleThreadSetCurrentThreadUserInfo(id info)`
- `id MulleThreadGetCurrentThreadUserInfo(void)`
- `void MulleThreadSetObjectForKeyUTF8String(id value, char *key)`
- `id MulleThreadObjectForKeyUTF8String(char *key)`
- `mulle_thread_t MulleThreadGetCurrentOSThread(void)`
- `mulle_thread_id_t MulleThreadGetCurrentOSThreadId(void)`
- `mulle_thread_id_t MulleThreadObjectGetOSThreadId(NSThread *threadObject)`

### 3.5 Autorelease Pool: NSAutoreleasePool
**Header**: `src/class/NSAutoreleasePool.h`
**Declaration**: `@interface NSAutoreleasePool` (root class, NOT a subclass of NSObject)

- `+ (id) alloc` / `+ (id) new`
- `- (id) init`
- `+ (Class) class MULLE_OBJC_THREADSAFE_METHOD`
- `- (Class) class MULLE_OBJC_THREADSAFE_METHOD`
- `- (void) release MULLE_OBJC_THREADSAFE_METHOD`
- `- (void) addObject:(id) object` / `+ (void) addObject:(id) object`
- `- (void) mulleAddObjects:(id *) objects count:(NSUInteger) count`
- `+ (void) mulleAddObjects:(id *) objects count:(NSUInteger) count`
- `+ (NSAutoreleasePool *) mulleDefaultAutoreleasePool`
- `+/- (NSAutoreleasePool *) mulleParentAutoreleasePool`
- `+/- (BOOL) mulleContainsObject:(id) p`
- `+/- (NSUInteger) mulleCountObject:(id) p`
- `+/- (NSUInteger) mulleCount`
- `- (void) mulleReleaseAllPoolObjects`
- `+/- (void) mulleReleasePoolObjects:(id *) p count:(NSUInteger) count`
- `+/- (void) mulleReleasePoolObject:(id) p`
- `@property( dynamic, assign) char *mulleNameUTF8String MULLE_OBJC_THREADSAFE_PROPERTY`

**C Push/Pop Functions:**
- `NSAutoreleasePool *NSPushAutoreleasePool(unsigned int size)`
- `void NSPopAutoreleasePool(NSAutoreleasePool *pool)`
- `NSAutoreleasePool *MulleAutoreleasePoolPush(void)`
- `void MulleAutoreleasePoolPop(NSAutoreleasePool *pool)`
- `id NSAutoreleaseObject(id obj)` — Autorelease with inlining (MULLE_C_STATIC_ALWAYS_INLINE)

**Debug Dump:**
- `void MulleObjCDumpAutoreleasePoolsToFile(char *filename)`
- `void MulleObjCDumpAutoreleasePoolsToFileIndexed(char *filename)`
- `void MulleObjCDumpAutoreleasePoolsToFILEWithOptions(FILE *fp, int indexed)`
- `unsigned long MulleObjCDumpAutoreleasePoolsFrame(void)`

### 3.6 Core Protocols

#### NSCoding - Object Serialization
**Header**: `src/protocol/NSCoding.h`
```objc
@protocol NSCoding
- (void) encodeWithCoder:(NSCoder *) aCoder;
- (instancetype) initWithCoder:(NSCoder *) aDecoder;
@optional
- (Class) classForCoder;
- (void) decodeWithCoder:(NSCoder *) aDecoder;
@end
```

#### NSCopying & MulleObjCImmutableCopying
**Header**: `src/protocol/NSCopying.h`
```objc
@protocol NSCopying
- (id) copy;   // MEMO: returns `id` not `instancetype`
@end

@protocol MulleObjCImmutableCopying < NSCopying>
- (id) immutableCopy;  // returns `id` not `instancetype`
@end
```

#### NSFastEnumeration - for-in Loop Support
**Header**: `src/protocol/NSFastEnumeration.h`
```objc
typedef struct {
   NSUInteger   state;
   id           *itemsPtr;
   NSUInteger   *mutationsPtr;
   NSUInteger   extra[5];
} NSFastEnumerationState;

@protocol NSFastEnumeration
- (NSUInteger) count;
- (NSUInteger) countByEnumeratingWithState:(NSFastEnumerationState *) state
                                    objects:(id *) objects
                                      count:(NSUInteger) count;
@end
```

#### NSLocking - Lock Protocol
**Header**: `src/protocol/NSLocking.h`
```objc
@protocol NSLocking
- (void) lock;
- (void) unlock;
@end
```

#### NSObject Protocol
**Header**: `src/protocol/NSObjectProtocol.h`
```objc
@protocol NSObject < MulleObjCRuntimeObject>
- (instancetype) self;
- (Class) superclass MULLE_OBJC_THREADSAFE_METHOD;
- (Class) class MULLE_OBJC_THREADSAFE_METHOD;
+ (Class) class MULLE_OBJC_THREADSAFE_METHOD;
- (BOOL) isProxy MULLE_OBJC_THREADSAFE_METHOD;
- (BOOL) isKindOfClass:(Class) cls MULLE_OBJC_THREADSAFE_METHOD;
- (BOOL) isMemberOfClass:(Class) cls MULLE_OBJC_THREADSAFE_METHOD;
+ (instancetype) instantiate;
+ (instancetype) new;
+ (instancetype) alloc;
- (instancetype) init;
- (void) dealloc;
- (void) finalize;
- (instancetype) autorelease MULLE_OBJC_THREADSAFE_METHOD;
- (BOOL) conformsToProtocol:(PROTOCOL) protocol MULLE_OBJC_THREADSAFE_METHOD;
- (BOOL) respondsToSelector:(SEL) sel MULLE_OBJC_THREADSAFE_METHOD;
+ (IMP) instanceMethodForSelector:(SEL) sel;
- (IMP) methodForSelector:(SEL) sel MULLE_OBJC_THREADSAFE_METHOD;
- (instancetype) immutableInstance;
- (id) performSelector:(SEL) sel MULLE_OBJC_THREADSAFE_METHOD;
- (id) performSelector:(SEL) sel withObject:(id) obj MULLE_OBJC_THREADSAFE_METHOD;
- (id) performSelector:(SEL) sel withObject:(id) obj withObject:(id) other MULLE_OBJC_THREADSAFE_METHOD;
- (NSUInteger) hash;
- (BOOL) isEqual:(id) obj;
- (char *) UTF8String;
- (void) mullePerformFinalize MULLE_OBJC_THREADSAFE_METHOD;
- (BOOL) mulleIsFinalized MULLE_OBJC_THREADSAFE_METHOD;
@end

@protocol MullePropertyObserving
- (void) willChange;
@end
```

### 3.7 @mixin Protocol Classes

All protocol classes formerly declared via `PROTOCOLCLASS_INTERFACE` macros now use the `@mixin` keyword. The implementing class is generated via `@implementation ProtocolClassName`.

#### MulleObjCClassCluster
**Header**: `src/protocol/MulleObjCClassCluster.h`
```objc
@mixin MulleObjCClassCluster
+ (void) initialize;
+ (Class) __classClusterClass;
@end
```
When you call `+alloc` you get a retained placeholder. In your `-init` method, release it.

#### MulleObjCSingleton
**Header**: `src/protocol/MulleObjCSingleton.h`
```objc
@mixin MulleObjCSingleton
@optional
+ (void) initialize;
+ (instancetype) sharedInstance;
@end
```
C helpers: `id MulleObjCSingletonCreate(Class self)`, `BOOL MulleObjCInstanceIsSingleton(id obj)`, `void MulleObjCSingletonMarkClassAsSingleton(Class self)`, `void MulleObjCSingletonSetEphemeral(BOOL flag)`.

#### MulleObjCException
**Header**: `src/protocol/MulleObjCException.h`
```objc
@mixin MulleObjCException
- (void) raise;
- (char *) UTF8String;
@end
```
Exception throwing macros: `MulleObjCThrowInvalidArgumentException(...)`, `MulleObjCThrowInvalidIndexException(index)`, `MulleObjCThrowInternalInconsistencyException(...)`, `MulleObjCThrowErrnoException(...)`, `MulleObjCThrowInvalidRangeException(range)`. C-string variants: `MulleObjCThrowInvalidArgumentExceptionUTF8String(...)`, `MulleObjCThrowInternalInconsistencyExceptionUTF8String(...)`, `MulleObjCThrowErrnoExceptionUTF8String(...)`.

Class cast macros: `MULLE_OBJC_CLASS_CAST(className, x)`, `MULLE_OBJC_CLASS_CAST_OR_NIL(className, x)`, `MULLE_OBJC_CLASS_CAST_NON_NIL(className, x)`. Protocol cast: `MULLE_OBJC_PROTOCOL_CAST(protocolName, x)`.

Range validation: `NSRange MulleObjCValidateRangeAgainstLength(NSRange range, NSUInteger length)`, `NSRange MulleObjCAdjustRangeForLength(NSRange range, NSUInteger length)`.

#### MulleObjCTaggedPointer
**Header**: `src/protocol/MulleObjCTaggedPointer.h`
```objc
@mixin MulleObjCTaggedPointer < MulleObjCImmutable>
+ (BOOL) isTaggedPointerEnabled;
@optional
- (instancetype) retain MULLE_OBJC_THREADSAFE_METHOD;
- (instancetype) autorelease MULLE_OBJC_THREADSAFE_METHOD;
- (void) release MULLE_OBJC_THREADSAFE_METHOD;
- (NSUInteger) retainCount MULLE_OBJC_THREADSAFE_METHOD;
- (id) immutableCopy MULLE_OBJC_THREADSAFE_METHOD;
@end
```
C functions: `MulleObjCTaggedPointerRegisterClassAtIndex()`, `MulleObjCTaggedPointerClassGetIndex()`, `MulleObjCTaggedPointerIsIntegerValue()`, `MulleObjCTaggedPointerIsFloatValue()`, `MulleObjCTaggedPointerIsDoubleValue()`, creation and extraction functions for signed/unsigned/float/double tagged pointers.

#### Thread Safety Protocols
**Header**: `src/protocol/MulleObjCProtocol.h`
```objc
@mixin MulleObjCThreadSafe
@optional
- (BOOL) mulleIsThreadSafe MULLE_OBJC_THREADSAFE_METHOD;
- (id) mulleThreadSafeCopy; // returns self retained
@end

@mixin MulleObjCThreadUnsafe
@optional
- (BOOL) mulleIsThreadSafe MULLE_OBJC_THREADSAFE_METHOD;
- (id) mulleThreadSafeCopy; // will return nil
@end

@mixin MulleObjCImmutable < MulleObjCRuntimeObject>
@optional
- (id) copy;
- (id) immutableCopy;
@end
```

**Protocol convenience macros:**
- `MulleObjCValueProtocols` — `MulleObjCRuntimeObject, MulleObjCValue, MulleObjCInvariant, MulleObjCImmutable, MulleObjCThreadSafe, MulleObjCImmutableCopying`
- `MulleObjCMutableValueProtocols` — `MulleObjCRuntimeObject, MulleObjCValue, MulleObjCThreadUnsafe`
- `MulleObjCContainerProtocols` — `MulleObjCRuntimeObject, MulleObjCContainer, MulleObjCImmutable, MulleObjCThreadSafe, MulleObjCImmutableCopying`
- `MulleObjCMutableContainerProtocols` — `MulleObjCRuntimeObject, MulleObjCContainer, MulleObjCThreadUnsafe`
- `MulleObjCImmutableProtocols` — `MulleObjCRuntimeObject, MulleObjCImmutable, MulleObjCThreadSafe, MulleObjCImmutableCopying`
- `MulleObjCMutableProtocols` — `MulleObjCRuntimeObject, MulleObjCThreadUnsafe`

**Additional protocols**: `@protocol MulleObjCInvariant`, `@protocol MulleObjCValue`, `@protocol MulleObjCContainer`, `@protocol MulleObjCContainerProperty`.

#### MulleObjCPlaceboRetainCount
```objc
@mixin MulleObjCPlaceboRetainCount
@optional
- (instancetype) retain MULLE_OBJC_THREADSAFE_METHOD;
- (instancetype) autorelease MULLE_OBJC_THREADSAFE_METHOD;
- (void) release MULLE_OBJC_THREADSAFE_METHOD;
- (NSUInteger) retainCount MULLE_OBJC_THREADSAFE_METHOD;
- (void) finalize;
- (void) dealloc;
@end
```

#### MulleObjCForwarding & MulleObjCFuture
**Header**: `src/protocol/MulleObjCProtocol.h`
```objc
@protocol MulleObjCForwarding
@end

@protocol MulleObjCFuture
@end
```
`MulleObjCForwarding`: marker for categories whose methods are forwarded to another object via `-forward:`. `MulleObjCFuture`: marker for categories whose implementations will be provided elsewhere (not yet implemented).

### 3.8 MulleObjCRootObject Mixin
**Header**: `src/protocol/MulleObjCRootObject.h`
```objc
@mixin MulleObjCRootObject < MulleObjCRuntimeObject>
@optional
+ (instancetype) alloc;
+ (instancetype) new;
- (struct mulle_allocator *) mulleAllocator MULLE_OBJC_THREADSAFE_METHOD;
- (void) mullePerformFinalize MULLE_OBJC_THREADSAFE_METHOD;
- (BOOL) mulleIsFinalized MULLE_OBJC_THREADSAFE_METHOD;
- (void) finalize;
- (void) dealloc;
- (instancetype) init;
- (instancetype) retain MULLE_OBJC_THREADSAFE_METHOD;
- (void) release MULLE_OBJC_THREADSAFE_METHOD;
- (NSUInteger) retainCount MULLE_OBJC_THREADSAFE_METHOD;
- (instancetype) autorelease MULLE_OBJC_THREADSAFE_METHOD;
// ... plus introspection, THAOS, forwarding, and method dispatch methods
@end
```

**Key Macros:**
```c
#define MulleObjCClassInitializeOnceDo( self) \
   assert( __MULLE_OBJC_CATEGORYID__ == MULLE_OBJC_NO_CATEGORYID && "no +initialize in categories"); \
   if( MulleObjCClassGetClassID( self) == __MULLE_OBJC_CLASSID__)

#define MulleObjCClassDeinitializeOnceDo( self) ...  // same pattern for +deinitialize
#define MulleObjCClassFinalizeOnceDo( self) ...      // same pattern for +finalize
```

**C Functions:**
- `void MulleObjCRelinquishAccessToObjects(id *objects, NSUInteger count)`
- `void MulleObjCRelinquishAccessToObjectsWithUniquingSet(id *objects, NSUInteger count, struct mulle_pointerset *uniquing)`
- `void MulleObjCGainAccessToObjects(id *objects, NSUInteger count)`
- `void MulleObjCGainAccessToObjectsWithUniquingSet(id *objects, NSUInteger count, struct mulle_pointerset *uniquing)`
- `BOOL MulleObjCClassIsSubclassOfClass(Class self, Class otherClass)` — inline
- `BOOL NSObjectIsKindOfClass(id self, Class otherClass)` — inline
- `BOOL MulleObjCInstanceIsMemberOfClass(id self, Class otherClass)` — inline

### 3.9 MulleObjCRuntimeObject Protocol
**Header**: `src/protocol/MulleObjCRuntimeObject.h`

```objc
@protocol MulleObjCRuntimeObject
- (instancetype) retain MULLE_OBJC_THREADSAFE_METHOD;
- (void) release MULLE_OBJC_THREADSAFE_METHOD;
- (NSUInteger) retainCount MULLE_OBJC_THREADSAFE_METHOD;
- (void) dealloc;
- (void) finalize;
- (id) _becomeRootObject;
- (BOOL) mulleIsThreadSafe MULLE_OBJC_THREADSAFE_METHOD;
- (BOOL) mulleIsAccessible MULLE_OBJC_THREADSAFE_METHOD;
- (BOOL) mulleIsAccessibleByThread:(NSThread *) threadObject MULLE_OBJC_THREADSAFE_METHOD;
- (void) mulleGainAccess MULLE_OBJC_THREADSAFE_METHOD;
- (void) mulleGainAccessWithTAOStrategy:(MulleObjCTAOStrategy) strategy MULLE_OBJC_THREADSAFE_METHOD;
- (void) mulleRelinquishAccess MULLE_OBJC_THREADSAFE_METHOD;
- (void) mulleRelinquishAccessWithTAOStrategy:(MulleObjCTAOStrategy) strategy MULLE_OBJC_THREADSAFE_METHOD;
- (MulleObjCTAOStrategy) mulleTAOStrategy MULLE_OBJC_THREADSAFE_METHOD;
// Class-side locking for class properties:
+ (void) lock;
+ (void) unlock;
+ (BOOL) tryLock;
@end
```

**TAO Strategy Enum:**
```c
typedef NS_ENUM(NSUInteger, MulleObjCTAOStrategy) {
   MulleObjCTAOCallerRemovesFromCurrentPool,
   MulleObjCTAOCallerRemovesFromAllPools,
   MulleObjCTAOCallerRemovesFromCurrentPoolShallow,
   MulleObjCTAOCallerRemovesFromAllPoolsShallow,
   MulleObjCTAOReceiverPerformsFinalize,
   MulleObjCTAOTransferIvars,
   MulleObjCTAOKnownThreadSafeMethods,
   MulleObjCTAOKnownThreadSafe
};
```

**Dependency Macros** (using `@dependency` compiler directive):
```c
#define MULLE_OBJC_DEPENDS_ON_CLASS( classname)   @dependency classname
#define MULLE_OBJC_DEPENDS_ON_CATEGORY( classname, categoryname)  @dependency classname( categoryname)
#define MULLE_OBJC_DEPENDS_ON_LIBRARY( libname)   @dependency MulleObjCDeps( libname)
```

**Method User Attributes:**
- `_MULLE_OBJC_METHOD_USER_ATTRIBUTE_0` through `_4` — `__attribute__((annotate("objc_user_N")))`
- `MULLE_OBJC_THREADSAFE_METHOD` — `_MULLE_OBJC_METHOD_USER_ATTRIBUTE_4`
- `MULLE_OBJC_THREADSAFE_PROPERTY` — `_MULLE_OBJC_METHOD_USER_ATTRIBUTE_4`

### 3.10 MulleObject - Auto-Locking Object
**Header**: `src/class/MulleObject.h`
**Declaration**: `@interface MulleObject : MulleDynamicObject < NSLocking>`

Auto-locking object base class. Subclasses that adopt `MulleAutolockingObjectProtocols` (`MulleObjCThreadSafe, MulleAutolockingObject`) get automatic `NSRecursiveLock`-based locking around every method call. Methods not needing locking should be marked `MULLE_OBJECT_SKIP_AUTOLOCKING_METHOD` (same as `MULLE_OBJC_THREADSAFE_METHOD`).

```objc
@mixin MulleAutolockingObject
@optional
- (MulleObjCTAOStrategy) mulleTAOStrategy MULLE_OBJC_THREADSAFE_METHOD;
@end
```

**Key Methods:**
- `+ (instancetype) locklessObject` — Create without a lock (not thread-safe until sharing)
- `- (instancetype) initNoLock`
- `- (BOOL) tryLock MULLE_OBJECT_SKIP_AUTOLOCKING_METHOD`
- `- (void) shareRecursiveLock:(NSRecursiveLock *) other` — Use another's lock
- `- (void) shareRecursiveLockWithObject:(MulleObject *) other MULLE_OBJECT_SKIP_AUTOLOCKING_METHOD`
- `- (void) didShareRecursiveLock:(NSRecursiveLock *) lock MULLE_OBJECT_SKIP_AUTOLOCKING_METHOD`
- `void MulleLockingObjectSetAutolockingEnabled(Class self, BOOL flag)`
- `void MulleLockingObjectFillCache(MulleObject *self, SEL sel, IMP imp, BOOL isThreadAffine)`

### 3.11 NSValue - Boxed Value Type (NEW)
**Header**: `src/class/NSValue.h`
**Declaration**: `@interface NSValue : NSObject < MulleObjCClassCluster, MulleObjCImmutable, MulleObjCThreadSafe>`

**Factory Methods:**
- `+ (instancetype) value:(void *) bytes withObjCType:(char *) type`
- `+ (instancetype) valueWithBytes:(void *) bytes objCType:(char *) type`
- `+ (instancetype) valueWithPointer:(void *) pointer`
- `+ (instancetype) valueWithRange:(NSRange) range`
- `+ (instancetype) valueWithNonretainedObject:(id) obj`

**Accessors:**
- `- (BOOL) isEqual:(id) other`
- `- (BOOL) isEqualToValue:(id) other`
- `- (NSRange) rangeValue`
- `- (void *) pointerValue`
- `- (id) nonretainedObjectValue`
- `- (void) getValue:(void *) value size:(NSUInteger) size`

**SubclassesFuture Category:**
- `- (NSUInteger) hash`
- `- (char *) objCType`
- `- (instancetype) initWithBytes:(void *) bytes objCType:(char *) type`
- `- (void) getValue:(void *) bytes`

**Concrete Subclass**: `_MulleObjCConcreteValue : NSValue < MulleObjCImmutableProtocols>`
**Header**: `src/class/_MulleObjCConcreteValue.h`
- `+ (instancetype) mulleNewWithBytes:(void *) bytes objCType:(char *) type`
- Ivars: `NSUInteger _size` (data stored inline after ivar area)

### 3.12 Structures

#### NSRange
**Header**: `src/struct/NSRange.h`
```c
struct NSRange {
   NSUInteger location;
   NSUInteger length;
};
```

#### NSZone
**Header**: `src/struct/NSZone.h`
```c
typedef void NSZone;  // zones are effectively void; legacy compat
```

#### MulleObjCContainerObjectCallback
**Header**: `src/struct/MulleObjCContainerObjectCallback.h`
Callback struct for container operations (hash, isEqual, describes).

### 3.13 MulleObjCRuntimeObjectDeprecated
**Header**: `src/protocol/MulleObjCRuntimeObjectDeprecated.h`
If `MULLE_OBJC_RUNTIME_OBJECT_DEPRECATED` is defined, provides backward-compatible macros: `MULLE_OBJC_CLASS_DEPENDENCY`, `MULLE_OBJC_CATEGORY_DEPENDENCY`, `MULLE_OBJC_LIBRARY_DEPENDENCY`, `MULLE_OBJC_NO_DEPENDENCY`, and old `PROTOCOLCLASS_*` macros (if `MULLE_C_HAS_VA_OPT`).

### 3.14 Utility Functions & Macros

#### Class ID Functions
From `src/function/MulleObjCFunctions.h`:
- `static inline SEL MulleObjCClassGetClassID(Class cls)` — Returns `__MULLE_OBJC_CLASSID__` selector or `MULLE_OBJC_NO_CLASSID`
- `static inline SEL MulleObjCInstanceGetClassID(id obj)` — ClassID of object's class

#### Retain/Release Inlines
From `src/protocol/MulleObjCRuntimeObject.h`:
- `static inline id MulleObjCObjectRetain(id obj)` — `mulle_objc_object_call_retain(obj)`
- `static inline void MulleObjCObjectRelease(id obj)` — `mulle_objc_object_call_release(obj)`

#### TAO Test
From `src/class/NSThread.h`:
- `static inline void MulleObjCTAOTest(Class cls, id arg)` — Test a class under TAO conditions

#### TAO Failure:
- `typedef void MulleObjCTAOFailureHandler(void *obj, mulle_thread_t osThread, struct _mulle_objc_descriptor *des) MULLE_C_NO_RETURN`
- `static inline MulleObjCTAOFailureHandler *MulleObjCGetTAOFailureHandler(void)`
- `static inline void MulleObjCSetTAOFailureHandler(MulleObjCTAOFailureHandler *handler)`
- `void MulleObjCTAOLogAndFail(...)` MULLE_C_NO_RETURN

### 3.15 NSCopyingWithAllocator Mixin
**Header**: `src/protocol/NSCopyingWithAllocator.h`
```objc
@mixin NSCopyingWithAllocator
- (id) copyWithAllocator:(struct mulle_allocator *) allocator;
@end
```
Copies object and its ivars/properties to another allocator. C helper: `id _MulleObjCInstanceCopyWithAllocator(id object, NSUInteger extraBytes, struct mulle_allocator *allocator)`.

## 4. Performance Characteristics

- **Message Send**: O(1) average with inline cache; optimized by mulle-objc-runtime
- **Method Lookup**: O(1) cached; O(log n) first lookup with modern runtime
- **retain/release**: O(1) atomic increment/decrement
- **NSAutoreleasePool**: O(1) add; O(n) drain where n = pooled objects
- **NSInvocation**: O(n) where n = argument count (MetaABI-optimized)
- **NSMethodSignature**: O(1) static lookup via `_NSConstantMethodSignature` for compile-time signatures; O(n) for dynamic
- **Locking**: O(1) for mutex-based locks (platform-dependent, typically futex on Linux); `NSRecursiveLock` delegates to `mulle_thread_recursive_mutex_t`
- **Memory**: Object header ~2 pointers (isa + retain count or atomic id)
- **Thread-Safety**: `NSObject` retain/release thread-safe (atomic). `NSRecursiveLock` delegates to `mulle_thread_recursive_mutex_t`. `MulleObject` provides auto-locking for all methods.
- **TAO**: Object transfer cost proportional to autorelease pool search (linear in pool count)

## 5. AI Usage Recommendations & Patterns

### Best Practices

- **Memory Model**: Always pair `retain`/`release`; prefer `autorelease` for return values; do NOT use `-retain` or `-release` outside of `-init`/`-dealloc` (per style guide)
- **Object Creation**: Use `+instantiate` (AAO) or `+instance` instead of `[[[Foo alloc] init] autorelease]`
- **Lifecycle**: Use `-init`/`-dealloc` pattern; call `[super init]` and `[super dealloc]`; expect `-finalize` before `-dealloc`
- **@mixin vs @protocol**: Use `@mixin` for protocol classes (MulleObjCSingleton, MulleObjCClassCluster, etc.) — these provide default implementations coded via `@implementation MixinName`
- **Dependencies**: Use `@dependency ClassName` or `@dependency DepsClassName(libname)` instead of old `MULLE_OBJC_DEPENDS_ON_*` macros
- **Thread Safety**: Protect mutable state with `NSLock`/`NSRecursiveLock`; use `MulleObject` with `MulleAutolockingObjectProtocols` for auto-locking; mark non-locking methods `MULLE_OBJECT_SKIP_AUTOLOCKING_METHOD`
- **Initialization Guards**: Use `MulleObjCClassInitializeOnceDo(self)` to guard `+initialize` against multiple calls from category loading
- **TAO**: Use `MulleObjCTAOKnownThreadSafe` for thread-safe objects; call `-mulleGainAccess`/`-mulleRelinquishAccess` when transferring objects across threads
- **Pool Management**: Use `@autoreleasepool` for scope-based management; create explicit pools in tight loops or custom threads
- **Invocation**: For dynamic method dispatch, use `+mulleInvocationWithTarget:selector:...` variadic factories; set `-setImplementation:` for direct IMP dispatch

### Common Pitfalls

- **Retain Cycles**: Manual retain-release (MRC) requires careful balancing; chaque retain needs exactly one release
- **Double-Release**: Each retain must have exactly one release — no more, no less
- **Deallocated Objects**: Accessing released object causes crash; no automatic nil safety
- **forwardInvocation**: NSProxy requires both `-methodSignatureForSelector:` and `-forwardInvocation:` implementations
- **Lock Deadlock**: NSLock is NOT recursive — same thread can't lock twice; use NSRecursiveLock for reentrant scenarios
- **NSInvocation Overhead**: Slower than direct dispatch; use for dynamic methods or cross-thread marshalling only
- **Class Cluster Placeholders**: Classes adopting `MulleObjCClassCluster` must call `[super initialize]` when overriding `+initialize`
- **@mixin Hierarchy**: @mixin classes behave differently from protocols — they provide concrete default implementations; check with `[object respondsToSelector:]`

### Idiomatic Usage Patterns

**Pattern 1: Proper Object Lifecycle (mulle-objc style)**
```objc
@interface MyObject : NSObject
{
   id   _other;
}
- (instancetype) initWithOther:(id) other;
@end

@implementation MyObject
- (instancetype) initWithOther:(id) other
{
   self = [super init];
   if( self)
      _other = [other retain];
   return( self);
}

- (void) dealloc
{
   [_other release];
   [super dealloc];
}
@end
```

**Pattern 2: Class Cluster Guards**
```objc
+ (void) initialize
{
   MulleObjCClassInitializeOnceDo( self)
   {
      MulleObjCClassMarkAsClassCluster( self);
   }
}
```

**Pattern 3: Auto-Locking MulleObject**
```objc
@interface Foo : MulleObject < MulleAutolockingObjectProtocols>
@end

@implementation Foo
// All instance methods are auto-locked with NSRecursiveLock
- (void) doStuff
{
   // thread safe!
}

- (void) threadSafeGetter  MULLE_OBJECT_SKIP_AUTOLOCKING_METHOD
{
   // not locked — mark as skip
}
@end
```

**Pattern 4: Create and Invoke with MetaABI**
```objc
NSInvocation *inv;

inv = [NSInvocation mulleInvocationWithTarget:array
                                     selector:@selector(objectAtIndex:),
                                            (NSUInteger) i];
[inv invoke];
[inv getReturnValue:&obj];
```

**Pattern 5: Dependency Declaration**
```objc
@implementation MyClass

MULLE_OBJC_DEPENDS_ON_CLASS( NSString)     // @dependency NSString
MULLE_OBJC_DEPENDS_ON_LIBRARY( foo)        // @dependency MulleObjCDeps( foo)

@end
```

**Pattern 6: Thread Handoff with TAO**
```objc
// Producer thread:
[mutableObject mulleRelinquishAccess];

// Consumer thread:
[receivedObject mulleGainAccess];
```

## 6. Integration Examples

### Example 1: Basic NSObject Subclass
```objc
#import <MulleObjC/MulleObjC.h>

@interface Person : NSObject
{
   char   *_name;
   int    _age;
}
- (instancetype) initWithName:(char *) s
                          age:(int) a;
- (char *) UTF8String;
@end

@implementation Person
- (instancetype) initWithName:(char *) s
                          age:(int) a
{
   self = [super init];
   if( self)
   {
      _name = MulleObjC_strdup( s);
      _age  = a;
   }
   return( self);
}

- (char *) UTF8String
{
   return( mulle_dup_printf( "Person: %s (%d)", _name, _age));
}

- (void) dealloc
{
   mulle_free( _name);
   [super dealloc];
}
@end
```

### Example 2: Autorelease Pool
```objc
#import <MulleObjC/MulleObjC.h>

int main()
{
   @autoreleasepool
   {
      // objects created here are autoreleased
   }
   return( 0);
}
```

### Example 3: Dynamic Method Invocation with MetaABI
```objc
NSInvocation   *inv;
id             obj;

inv = [NSInvocation mulleInvocationWithTarget:array
                                     selector:@selector(objectAtIndex:),
                                            (NSUInteger) 12];
[inv invoke];
[inv getReturnValue:&obj];
```

### Example 4: NSProxy Forwarding
```objc
@interface Forwarder : NSProxy
{
   id   _target;
}
- (instancetype) initWithTarget:(id) t;
@end

@implementation Forwarder
- (instancetype) initWithTarget:(id) t
{
   _target = [t retain];
   return( self);
}

- (void) forwardInvocation:(NSInvocation *) inv
{
   [inv setTarget:_target];
   [inv invoke];
}

- (NSMethodSignature *) methodSignatureForSelector:(SEL) sel
{
   return( [_target methodSignatureForSelector:sel]);
}

- (void) dealloc
{
   [_target release];
   [super dealloc];
}
@end
```

### Example 5: Thread Creation
```objc
NSThread   *thread;

thread = [[[NSThread alloc] initWithTarget:worker
                                  selector:@selector(run)
                                    object:nil] autorelease];
[thread mulleStart];
// ... later:
[thread mulleJoin];
```

### Example 6: Condition Variable Usage
```objc
NSCondition   *condition;

condition = [[[NSCondition alloc] init] autorelease];

// Thread 1 (consumer):
[condition lock];
[condition wait];
[condition unlock];

// Thread 2 (producer):
[condition lock];
[condition signal];
[condition unlock];
```

### Example 7: NSValue Boxing
```objc
NSValue   *v;
NSValue   *rangeValue;
int       x;

x = 1848;
v = [NSValue value:&x withObjCType:@encode(int)];

rangeValue = [NSValue valueWithRange:NSRangeMake( 0, 10)];
```

## 7. Dependencies

- **mulle-objc-runtime** (C library) — Runtime engine; method dispatch, memory model, class infrastructure
- **mulle-objc-debug** (C library, optional) — Debug support; introspection tools
- **mulle-thread** (C library, via mulle-c) — Thread primitives (`mulle_thread_mutex_t`, `mulle_thread_recursive_mutex_t`)
- No C standard library; fully self-contained portable implementation

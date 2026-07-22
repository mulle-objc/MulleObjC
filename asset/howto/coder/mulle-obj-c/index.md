# mulle-obj-c coder howto

<!-- Keywords: root-class, threading, autorelease, pool, mixin, dynamic-object, auto-locking, invocation, tao, synchronization -->

Use this bundle when writing Objective-C code against the MulleObjC library.
This covers the local API families that a contributor will encounter:
NSObject/NSProxy subclassing, threading and synchronization, autorelease pool
management, @mixin protocol classes (singleton, class cluster, exception),
MulleDynamicObject / MulleObject (dynamic properties, auto-locking),
NSInvocation/NSMethodSignature (dynamic dispatch), and thread-safety/TAO.

## Understand first

```bash
mulle-sde howto show --keyword objc --keyword styleguide
mulle-sde api apropos NSObject
mulle-sde api cat NSObject
mulle-sde api cat NSThread
```

## Local references

| Source | Path |
|--------|------|
| Umbrella header | `src/MulleObjC.h` |
| NSObject | `src/class/NSObject.h` |
| NSProxy | `src/class/NSProxy.h` |
| NSAutoreleasePool | `src/class/NSAutoreleasePool.h` |
| NSThread + locks | `src/class/NSThread.h`, `src/class/NSLock.h` |
| NSInvocation | `src/class/NSInvocation.h` |
| NSMethodSignature | `src/class/NSMethodSignature.h` |
| MulleDynamicObject | `src/class/MulleDynamicObject.h` |
| MulleObject (auto-lock) | `src/class/MulleObject.h` |
| @mixin protocols | `src/protocol/MulleObjCSingleton.h`, `src/protocol/MulleObjCClassCluster.h`, `src/protocol/MulleObjCException.h` |
| Thread safety protocols | `src/protocol/MulleObjCProtocol.h` |
| TAO | `src/class/NSThread.h` (MulleObjCTAOTest, TAO helpers) |
| TOC | `asset/dox/TOC.md` |

## Scenario-to-API mapping

| What you need | API family | Key entry point |
|---------------|------------|-----------------|
| Subclass NSObject | NSObject lifecycle | `+instance`, `-init`, `-dealloc` |
| Create a proxy | NSProxy + forwarding | `-forwardInvocation:`, `-methodSignatureForSelector:` |
| Manage memory | NSAutoreleasePool | `@autoreleasepool { }`, `NSAutoreleaseObject()` |
| Create/detach threads | NSThread + NSInvocation | `+mulleThreadWithTarget:selector:object:` |
| Lock critical section | NSLock / NSRecursiveLock | `-lock` / `-unlock` |
| Wait/signal between threads | NSCondition / NSConditionLock | `-wait` / `-signal` |
| Serialize method call | NSInvocation | `+mulleInvocationWithTarget:selector:, ...` |
| Create singleton | MulleObjCSingleton @mixin | `@interface Foo < MulleObjCSingleton>` |
| Create class cluster | MulleObjCClassCluster @mixin | `@interface Foo < MulleObjCClassCluster>` |
| Raise exception | MulleObjCException @mixin + macros | `MulleObjCThrowInvalidArgumentException(...)` |
| Dynamic property in category | MulleDynamicObject | `@property(dynamic) int foo` + `@dynamic foo` |
| Auto-locked methods | MulleObject + MulleAutolockingObjectProtocols | `@interface Foo : MulleObject < MulleAutolockingObjectProtocols>` |
| Thread-safe object | MulleObjCThreadSafe protocol | `< MulleObjCThreadSafe>` |
| Cross-thread transfer | TAO | `-mulleGainAccess` / `-mulleRelinquishAccess` |
| Dynamic dispatch via IMP | NSInvocation + IMP | `-setImplementation:` / `+mulleInvocationWithTarget:selector:implementation:object:` |

## Local workflow

All code must be compiled with **mulle-clang** (or a compiler supporting the
mulle-objc metaABI). Include the umbrella header:

```objc
#import <MulleObjC/MulleObjC.h>
```

For dependency declarations inside `@implementation`, use the `@dependency`
compiler directive:

```objc
MULLE_OBJC_DEPENDS_ON_CLASS( NSString)
MULLE_OBJC_DEPENDS_ON_LIBRARY( foo)
```

Never use the old `PROTOCOLCLASS_INTERFACE` / `PROTOCOLCLASS_IMPLEMENTATION`
macros — use `@mixin` instead.

## Verify

```bash
mulle-sde run     # build and run tests
mulle-sde test    # run test suite
```

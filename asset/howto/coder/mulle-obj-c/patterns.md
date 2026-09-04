# Patterns

<!-- Keywords: objc, patterns, singleton, class-cluster, dynamic, invocation, thread, lock, autorelease, tao -->

## NSObject subclass — standard lifecycle

From `test/NSObject/object.m`:

```objc
@interface Foo : NSObject
@end

@implementation Foo
@end

int main()
{
   Foo *foo = [Foo instance];     // alloc + init + autorelease
   return( 0);
}
```

Use `+instance` (not `[[[Foo alloc] init] autorelease]`). Inside `-init` retain
ivars; inside `-dealloc` release them. See `test/NSObject/alloc_new.m`.

## Autorelease pool — scope-based

From `test/NSAutoreleasePool/@simple.m`:

```objc
int main()
{
   @autoreleasepool
   {
      [Foo instance];
   }
   return( 0);
}
```

Use `@autoreleasepool { }` for scope-based management. The compiler inserts
`_MulleAutoreleasePoolPush`/`MulleAutoreleasePoolPop`. C functions
`NSPushAutoreleasePool(size)` / `NSPopAutoreleasePool(pool)` are available
for manual control. Inline with `NSAutoreleaseObject(obj)`.

## Thread creation — joinable

From `test/NSThread/simple.m`:

```objc
@interface Foo : NSObject
@end

@implementation Foo
+ (void) function:(id) arg
{
   printf( "%s\n", __PRETTY_FUNCTION__);
}
@end

int main()
{
   NSThread *thread;

   thread = [NSThread mulleThreadWithTarget:[Foo class]
                                    selector:@selector( function:)
                                      object:nil];
   [thread mulleStart];
   [thread mulleJoin];
   return( 0);
}
```

Prefer `+mulleThreadWithTarget:selector:object:` or `+mulleThreadWithInvocation:`
and `-mulleStart` + `-mulleJoin` over detached `-start`.

## Lock — basic mutual exclusion

```objc
NSLock *lock = [NSLock instance];

NSLockingDo( lock)
{
   // critical section
}
```

For reentrant locking use `NSRecursiveLock`. For condition variables use
`NSCondition` (`-wait` / `-signal`). See `src/class/NSConditionLock.h` for
state-based locking.

## Singleton — @mixin

From `test/MulleObjCSingleton/singleton.m`:

```objc
@interface Foo : NSObject < MulleObjCSingleton>
@end

@implementation Foo
@end

Foo *instance = [Foo sharedInstance];   // alloc once, returns same object
```

The `@mixin MulleObjCSingleton` provides `+sharedInstance`. Do not call `+alloc`
directly on singleton classes — use `+sharedInstance`. The `MulleObjCSingletonCreate()`
C helper is available for subclasses that bypass `+sharedInstance`.

## Class cluster — @mixin

From `test/MulleObjCClassCluster/cluster.m`:

```objc
@interface Foo : NSObject < MulleObjCClassCluster>
@end

@implementation Foo
- (id) init
{
   [self release];
   return( [Bar new]);
}
@end

Foo *foo = [Foo new];   // returns a Bar instance
```

`+alloc` on a class-cluster class returns a retained placeholder. In `-init`,
release the placeholder and return a concrete subclass instance. Mark the
cluster with `MulleObjCClassMarkAsClassCluster(self)` in `+initialize` when
overriding it.

## Dynamic properties — MulleDynamicObject

From `test/MulleDynamicObject/assign.m`:

```objc
@interface Foo : MulleDynamicObject
@end

@interface Foo( MoarValues)
@property( dynamic, assign) id assignValue;
@end

@implementation Foo
@end

@implementation Foo( MoarValues)
@dynamic assignValue;
@end
```

MulleDynamicObject synthesizes accessors at runtime using a `__ivars` pointer
map. Declare `@property(dynamic, ...)` in the interface and `@dynamic` in the
implementation. Works for `id`, `char *`, `NSInteger`, `NSUInteger`, and
`void *`. For other types, `NSValue` and `NSNumber` must be available at
runtime.

## Auto-locking object — MulleObject

```objc
@interface MyWidget : MulleObject < MulleAutolockingObjectProtocols>
@end

@implementation MyWidget
// all instance methods are auto-locked with NSRecursiveLock
- (void) doStuff { /* thread-safe */ }
@end
```

Use `MULLE_OBJECT_SKIP_AUTOLOCKING_METHOD` to exempt a method from auto-locking.
Use `+locklessObject` / `-initNoLock` to create instances without a lock.
Use `-shareRecursiveLock:` to share a lock between objects (e.g. parent/child).

## Invocation — dynamic dispatch

From `test/NSInvocation/array-invoke.m`:

```objc
NSInvocation *inv = [NSInvocation mulleInvocationWithTarget:array
                                                   selector:@selector(objectAtIndex:),
                                                          (NSUInteger) 12];
[inv invoke];
id obj;
[inv getReturnValue:&obj];
```

Variadic `+mulleInvocationWithTarget:selector:, ...` is the preferred entry
point. Use `+mulleInvocationWithTarget:selector:implementation:object:` for
direct IMP dispatch. See `test/NSInvocation/` for MetaABI patterns.

## Forwarding — NSProxy

```objc
@interface Forwarder : NSProxy
{
   id _target;
}
@end

@implementation Forwarder
- (void) forwardInvocation:(NSInvocation *) inv
{
   [inv setTarget:_target];
   [inv invoke];
}
- (NSMethodSignature *) methodSignatureForSelector:(SEL) sel
{
   return( [_target methodSignatureForSelector:sel]);
}
@end
```

Both `-forwardInvocation:` and `-methodSignatureForSelector:` must be
implemented. For performance, prefer `-forward:` over `-forwardInvocation:`.

## Exception throwing macros

```objc
MulleObjCThrowInvalidArgumentException( @"expected non-nil value");
MulleObjCThrowInvalidIndexException( index);
MulleObjCThrowInternalInconsistencyException( @"state corrupted: %s", reason);
```

C-string variants (`MulleObjCThrowInvalidArgumentExceptionUTF8String(...)`)
are also available. Cast safely with `MULLE_OBJC_CLASS_CAST(ClassName, x)`.

## Thread safety protocols

```objc
@interface Foo : NSObject < MulleObjCThreadSafe>
// can be messaged from any thread
@end

@interface Bar : Foo < MulleObjCThreadUnsafe>
// overrides - only one thread at a time
@end
```

Test thread safety with `-mulleIsThreadSafe`, never with `-conformsToProtocol:`.
Use `MulleObjCImmutableProtocols` or `MulleObjCValueProtocols` convenience
macros for immutable/value classes.

## TAO — cross-thread handoff

```objc
// Producer thread:
[mutableObject mulleRelinquishAccess];

// Consumer thread:
[receivedObject mulleGainAccess];
```

Use `MulleObjCTAOTest(cls, arg)` from `src/class/NSThread.h` to validate
a class under TAO conditions. See `test/TAO/` for forward/backward/backandforth
strategies.

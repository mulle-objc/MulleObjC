# Quirks

<!-- Keywords: objc, pitfalls, tao, thread-safe, lock, autorelease, singleton, class-cluster, forward, dealloc, finalize -->

## NSObject lifecycle

- `+dealloc` automatically writes `nil`/`NULL` into properties that have
  setters (from `src/class/NSObject.h` comment). Properties without setters are
  NOT zeroed — release them manually in `-dealloc`.
- Do NOT call `-retain` or `-release` outside of `-init`/`-dealloc` per style
  guide. Use `@property` setters for external ownership.
- `-finalize` runs before `-dealloc`. Release heavy resources there.
  Properties are zeroed in `-finalize`, so `-dealloc` should only handle
  non-property ivars (from `asset/howto/coder/object-management.md`).

## NSAutoreleasePool

- `NSAutoreleasePool` is a **root class**, NOT a subclass of NSObject.
  It is not even a `MulleObjCRuntimeObject` — you can't do much with it
  besides pool operations (from `src/class/NSAutoreleasePool.h`).
- Instance methods like `-init` or `-mulleNameUTF8String` on a pool object
  "wrap around" because of root-class behavior. Be careful.
- Pool objects are allocated with `stdlib` allocator, not the default
  allocator (avoids trace clutter).

## NSThread

- `+currentThread` crashes if the calling thread is not a MulleObjC thread.
  Use `MulleThreadGetCurrentThread()` (C function) to check first
  (from `src/class/NSThread.h`).
- NSThread is a 1:1 relationship to a `mulle_thread`. When the underlying
  thread dies, the NSThread is gone.
- Passing non-threadsafe objects to a thread via `NSInvocation` makes them
  **unusable in the caller thread** once the thread starts. The default TAO
  strategy may even remove them from the caller's autorelease pool.
- `-mulleJoin` returns the invocation and renders it no longer available from
  the NSThread. Do not call `-mulleJoin` on a detached thread.
- `-start` runs detached (legacy). Prefer `-mulleStart` + `-mulleJoin`.

## NSLock / NSRecursiveLock

- `NSLock` is **NOT** recursive — the same thread must not lock twice.
  Use `NSRecursiveLock` for reentrant scenarios (from `src/class/NSRecursiveLock.h`).
- `NSRecursiveLock` delegates to `mulle_thread_recursive_mutex_t` internally.

## @mixin Singletons

- Singletons are expected to be created via `+sharedInstance`, not `+alloc`.
  Using `+alloc` gives you a different instance (from
  `src/protocol/MulleObjCSingleton.h`).
- You cannot run `-mullePerformFinalize` on a singleton.
- If your singleton subclass overrides `+initialize` and also conforms to
  `MulleObjCClassCluster`, you MUST call `[super initialize]` or
  `MulleObjCSingletonMarkClassAsSingleton(self)`.

## @mixin Class clusters

- When you call `+alloc` on a class cluster, you get back a **retained
  placeholder**. In your `-init`, you must `[self release]` and return a
  concrete subclass instance (from `src/protocol/MulleObjCClassCluster.h`).
- If you override `+initialize`, call `MulleObjCClassMarkAsClassCluster(self)`.

## MulleDynamicObject

- `-isFullyDynamic` is a **non-thread-safe global** for performance reasons
  (from `src/class/MulleDynamicObject.h`). Only override with a category,
  never in a subclass.
- Only types `id`, `char *`, `NSInteger`, `NSUInteger`, and `void *` work
  without `NSValue`/`NSNumber` at runtime.
- You MUST NOT call `[super forward:]` to inherit dynamic forwarding. Use
  `_MulleDynamicObjectForward()` instead, then handle failures yourself.

## MulleObject (auto-locking)

- All instance methods on a `MulleObject` subclass with
  `MulleAutolockingObjectProtocols` are **automatically locked** with
  `NSRecursiveLock`. Mark methods that should skip locking with
  `MULLE_OBJECT_SKIP_AUTOLOCKING_METHOD` (which is `MULLE_OBJC_THREADSAFE_METHOD`).
- If a method raises an exception, the unlock code is NOT executed. Catch
  exceptions inside auto-locked methods.
- The class's inheritance value appears "broken" — this is the trick
  `MulleAutolockingObject` uses and can't be avoided
  (from `src/class/MulleObject.h`).

## Thread safety protocols

- **Never** test thread safety with `-conformsToProtocol:` — a class may be
  marked both `MulleObjCThreadSafe` and `MulleObjCThreadUnsafe` in its
  inheritance chain. The **last marker wins**. Use `-mulleIsThreadSafe` instead
  (from `src/protocol/MulleObjCProtocol.h`).
- Once a class is `< MulleObjCImmutable>` or `< MulleObjCValue>`, subclasses
  cannot become mutable again (protocols can't be removed). Plan the hierarchy
  accordingly.
- You CAN toggle between `MulleObjCThreadUnsafe` and `MulleObjCThreadSafe`
  over the inheritance chain.

## TAO (Thread Affinity & Ownership)

- Class objects have `thread_id == 0` (no thread affinity). TAO checks exit
  immediately for class methods. They are callable from any thread.
- Instance objects accessed from a different thread than the creating thread
  need `< MulleObjCThreadSafe>` conformance, or explicit
  `-mulleGainAccess`/`-mulleRelinquishAccess` calls.
- NSLock is `MulleObjCThreadSafe` but its underlying mutex must be usable
  from any thread.

## Forwarding

- Do **not** call `[super forward:]` — the forwarded selector is in `_cmd`
  and would be clobbered by a regular method call. Use
  `_mulle_objc_object_lookup_superimplementation_inline_nofail` with a
  precomputed superid instead (from `src/class/NSObject.h`).
- Use `mulle-objc-uniqueid` with `'<yourclassname>;forward:'` to create the
  superid, and register the `_mulle_objc_super` in the universe via a dummy
  `registerForwardSuper` method.

## NSInvocation

- `NSInvocation` is variable-sized — `_storage` expands/contracts with MetaABI
  parameters (from `src/class/NSInvocation.h`).
- Subclasses that add properties must release them in `-dealloc` as
  `-finalize` does nothing for NSInvocation.
- Variadic invocations are not supported (can't copy a MetaABI frame for
  variadic calls). Use `forward:` for variadic forwarding.
- `-retainArguments` must be called explicitly when passing invocations to
  threads (from `src/class/NSThread.h`).

## @property (class, ...)

- The class-property lock is only initialized if the class (or a category)
  has at least one **non-dynamic** `@property (class, ...)`. If only dynamic
  category properties exist, adding a dummy non-dynamic class property
  `@property (class, assign) char _lockActivator;` activates the lock
  (from `asset/howto/coder/class-properties.md`).
- Do NOT call `[self lock]` on a class that has no non-dynamic class property
  — the mutex is dormant (depth = -1) and the call crashes.
- `atomic` is not supported in mulle-objc.

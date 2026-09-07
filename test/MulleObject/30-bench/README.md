# Results

   Timings are super flakey. I don't know why. I need to run all the tests
   once without printing and then once more with printing. I assume its got
   to be something with OS paging or some such that trips it up otherwise.

## dispatch-bench

   `dispatch-bench.m` contrasts the raw dispatch mechanisms. It is compiled
   at `-O3 -DNDEBUG` (see `dispatch-bench.Debug.CFLAGS` /
   `dispatch-bench.Release.CFLAGS`); `-O0` figures would be dominated by
   debug/assert code and are pointless.

   Debug library (`mulle-sde test run ...`, lib built `-O0 -fobjc-tao`):

      c function    ~800M calls/s     plain C function through a function pointer
      objc vtable   ~570M calls/s     FCS fastmethodtable slot lookup + call
      objc cache    ~500M calls/s     full inline class method cache lookup + call
      objc forward: ~320M calls/s     cache miss -> -forward: -> target method (~2 dispatch hops)
      NSInvocation  ~  5M calls/s     `-[NSInvocation invoke]` (library body built at -O0)

   Release library (`mulle-sde test run --release ...`, lib built `-O3 -fno-objc-tao`):

      c function    ~800M calls/s
      objc vtable   ~575M calls/s
      objc cache    ~570M calls/s
      objc forward: ~333M calls/s
      NSInvocation  ~ 48M calls/s     `-[NSInvocation invoke]` (library body now -O3)

   The `forward:` case is a real proxy: it dispatches a selector the proxy
   does not implement, so the runtime misses the proxy's cache, calls the
   proxy's `-forward:`, which then dispatches to a second object's method.
   That is two dispatch hops, hence roughly half the cache hits/s. The proxy
   overrides `-forward:` in this file so the whole path is compiled at `-O3`;
   relying on `NSObject`'s `-forward:` would drag in the library's build.

   The vtable case uses a compile-time constant slot index (as inlined FCS
   dispatch does for a constant selector) - a runtime global index would be
   reloaded every iteration and distort the result.

   Note: the `.CFLAGS` files clobber the platform defaults, so they must also
   mirror the thread-affinity flag of the library they link against (Debug
   `-fobjc-tao`, Release `-fno-objc-tao`). In Debug builds the TAO bit is
   additionally cleared in `main` so that non-threadsafe methods actually
   stay in the cache (otherwise the "cache" case measures the TAO "refail"
   path).

## A

Safe calls are just normal Objective-C method calls. Currently the compiler
uses "partial" for message dispatch, which means that the actual search code
is not inlined.

The actual numbers are "per call", where safeCall:4 is actually 5 stacked
calls.

```
0.000000001913s for [A safeCall:0]
0.000000002001s for [A safeCall:1]
0.000000002068s for [A safeCall:2]
0.000000002072s for [A safeCall:3]
0.000000002047s for [A safeCall:4]
```

The unsafe calls are going through locking of MulleLockingObject. In the
non-recursive case the cost is ca. 5 times that of the safe call, but with
more recursion the cost comes down!

```
0.000000013284s for [A unsafeCall:0]
0.000000010205s for [A unsafeCall:1]
0.000000009274s for [A unsafeCall:2]
0.000000009448s for [A unsafeCall:3]
0.000000008998s for [A unsafeCall:4]

```

## B

**B** is a reference implementation using a `NSLock` instead of an embedded
`NSRecursiveLock`. I don't know why its much faster than `[A safeCall:0]`
as the stepped through assembler code is identical:


```
0.000000001917s for [B safeCall:0]
```

```
0.000000045222s for [D unsafeCall:0]
```

## C

Just a playground for some test code

```
0.000000008811s for [C safeCall:0]
0.000000009638s for [C safeCall:1]
0.000000009316s for [C safeCall:2]
0.000000009068s for [C safeCall:3]
0.000000009016s for [C safeCall:4]

0.000000052699s for [C unsafeCall:0]
0.000000044526s for [C unsafeCall:1]
0.000000041867s for [C unsafeCall:2]
0.000000041879s for [C unsafeCall:3]
0.000000040579s for [C unsafeCall:4]
```

## D

**D** is like **B** but we are using a `mulle_thread_mutex_t` instead of a
`NSLock`, which makes it a bit faster. Ergo: Objective-C overhead.

```
0.000000002144s for [D safeCall:0]
```

```
0.000000050336s for [D unsafeCall:0]
```


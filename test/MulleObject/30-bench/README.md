# Results

   Timings are super flakey. I don't know why. I need to run all the tests
   once without printing and then once more with printing. I assume its got
   to be something with OS paging or some such that trips it up otherwise.

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


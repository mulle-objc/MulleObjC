# Debugging MulleObjC code

<!-- Keywords: debug, tao, breakpoint, dump, autorelease-pool, thread, gdb -->

## Debugging facilities

### Autorelease pool dump

From `src/class/NSAutoreleasePool.h`:

```c
MulleObjCDumpAutoreleasePoolsToFile( char *filename);
MulleObjCDumpAutoreleasePoolsToFileIndexed( char *filename);
MulleObjCDumpAutoreleasePoolsToFILEWithOptions( FILE *fp, int indexed);
unsigned long   MulleObjCDumpAutoreleasePoolsFrame( void);
```

Call from a breakpoint when all threads are stopped. Produces CSV suitable for
import into sqlite. The `pooldump_script.sql` in `test/NSAutoreleasePool/`
shows post-processing queries.

### TAO failure handler

From `src/class/NSThread.h`:

```c
MulleObjCTAOFailureHandler *handler = MulleObjCGetTAOFailureHandler();
MulleObjCSetTAOFailureHandler( myHandler);   // must not return
MulleObjCTAOLogAndFail( obj, osThreadId, desc);  // default logger
```

Override to capture wrong-thread access in tests instead of aborting.

### Singleton ephemeral mode

From `src/protocol/MulleObjCSingleton.h`:

```c
MulleObjCSingletonSetEphemeral( YES);
```

Or set environment variable `MULLE_OBJC_EPHEMERAL_SINGLETON`. In ephemeral
mode, `+sharedInstance` returns a new instance each time — useful for testing.

### Debug dump of universe

```c
mulle_objc_universe_dotdump_to_directory( universe, ".");
```

From `test/MulleObjCSingleton/singleton.m`. Generates DOT files of the class
hierarchy.

### NSDebug functions

From `src/function/NSDebug.h`:

```c
MulleObjCDotdumpInfraHierarchy( "Foo");
MulleObjCDotdumpMetaHierarchy( "Foo");
```

From `test/NSObject/object.m`.

## Thread diagnostics

- `MulleThreadGetCurrentOSThreadId()` — raw OS thread ID
- `MulleThreadObjectGetOSThreadId(thread)` — thread ID for an NSThread object
- `+mulleIsMainThread` / `+mulleIsMultiThreaded` — query state

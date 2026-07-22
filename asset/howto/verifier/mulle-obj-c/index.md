# Verifying code that uses MulleObjC

<!-- Keywords: verify, test, tao, no-leak, singleton, class-cluster, dynamic-object -->

No library-specific debugging facilities beyond what is documented in
the debugger bundle (`asset/howto/debugger/mulle-obj-c/index.md`). Use
the standard `mulle-sde test` workflow.

## Common diagnostics

| Issue | How to verify |
|-------|---------------|
| No leaks | `test/0_noleak/noleak.m` pattern — run under `mulle-sde test` |
| TAO compliance | `MulleObjCTAOTest(cls, arg)` — see `src/class/NSThread.h` |
| Singleton behavior | `MulleObjCInstanceIsSingleton(obj)` — see `src/protocol/MulleObjCSingleton.h` |
| Class cluster | `[foo __isClassClusterObject]` — see `src/class/NSObject.h` |
| Thread safety | `-mulleIsThreadSafe` (NOT `-conformsToProtocol:`) |
| Autorelease pool state | `MulleObjCDumpAutoreleasePoolsToFile()` from debugger |

Ephemeral singleton mode (`MULLE_OBJC_EPHEMERAL_SINGLETON=1`) creates
fresh instances from `+sharedInstance` for test isolation.

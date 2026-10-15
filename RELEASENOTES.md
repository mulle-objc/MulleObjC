### 0.30.2



* Verify `@signature` and `instanceMethodSignatureForSelector:` agree on argument count, invocation offsets, and natural sizes for the same method
* Guards against the 64 bit ``_cmd`` `natural_size` mismatch that could overflow the stack in NSInvocation



feature: add variadic NSInvocation support via caller-supplied parameter blocks

* new `NSInvocationCreateWithMetaABIFrameAndLength` C function builds an invocation for a variadic method from a caller-constructed MetaABI parameter block, since the method signature cannot size the variadic tail
* `+invocationWithMethodSignature:` deliberately still returns `nil` for variadic signatures, preserving `-forward:` fail-closed behavior instead of corrupting the call
* `MulleObjCPropertyClearMode` replaces the `BOOL clearReadOnly` argument of ``_MulleObjCInstanceClearProperties`;` **BREAKING** for direct callers of that function
* new `MulleObjCPropertyClearOnlyReadOnly` mode and ``_MulleObjCInstanceClearPropertyOnlyReadOnly`` clear only readonly properties
* `MulleObject` now implements `-finalize` to clear its readonly properties on teardown
* added variadic-frame test coverage across all promoted type classes and cardinalities



* constant objects will not be added to the autoreleasepool anymore

## 0.30.1

* fix for classclusters using +instance


## 0.30.0


feature: add standard named method implementations with `@method_implementation` support

* new MulleObjCStandardImplementation module providing canonical implementations for +alloc, +new, -init, -autorelease, -dealloc, -finalize, -release, -retain, -retainCount and -self
* new `@method_implementation` directive lets classes opt into standard implementations by name instead of writing inline bodies
* fast-path dispatch (e.g. +instance) now calls inline standard implementations via a class implementation mask for zero overhead
* standard implementations are single-sourced: the public named functions delegate to the same inline core, so custom overrides and the fast path stay in sync



* split `_mulle_objc_thread_resignas_universethread` so config/TSS, global ABA and universe-release steps peel in strict LIFO order, preventing a NULL-deref/SIGSEGV when universe teardown runs on the releasing thread


## 0.29.0




* ``NS_ENUM_PARSE_STRICT`` now covered for unknown values, NULL input, and NULL table keys
* forward property verify no double-forward callback during object deallocation



* **NSValue** is now part of MulleObjC instead of MulleFoundation
* the default allocator gets an aba callback (used to be only the runtime did aba)
* uses the new  for NSRecursiveLock (code was migrated to mulle-thread)

* **BREAKING** NSInvocation redesign

* **BREAKING** NSMethodSignature redesign, support for @signature()
* faster invocation through better code

* Now with @mixin instead of protocolclass
* NSInvocation now can have an IMP


* share lock code rewritten for MulleObject

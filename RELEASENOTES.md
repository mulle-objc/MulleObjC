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

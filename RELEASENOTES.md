## 0.28.0














feature: export dynamic property accessor helpers and add compatibility tests

* Export new helper APIs to create property accessor methods at runtime `(_mulle_objc_infraclass_create_methods_for_property,` `_mulle_objc_infraclass_create_accessor_methods),` enabling dynamic property accessor generation for consumers of the runtime.
* Add swap-compatibility tests and small runtime hardening: silence unused-parameter warnings and minor forward()/accessor tweaks to improve robustness.



* thread-affine objects now compare thread IDs for TAO access/ownership checks
* **BREAKING** replace `MulleObjCLoader` with `MulleObjCDeps` for declaring +load dependencies
* `MulleObjCDescribeMemory` and `MulleObjCDescribeIvars` are now exported for external callers
* DEBUG builds now abort with a clear error if `%@` is used without a loaded string class
* all tests pass on Windows (Wine)

* fix obscure crasher in NSAutoreleasePool

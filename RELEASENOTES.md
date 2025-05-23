## 0.26.0




* UTF8String is now defined as not threadsafe and nonLockingUTF8String must be though
* -colorizedUTF8String used -nonLockingUTF8String
* more clarification for the -copy method
* more clarification for TAO strategies
* new function MulleObjCClassImplementsSelector specifically for -copy methods to check that a subclass is implementing -copy properly but can be useful in other places as well

* added MulleObjCIMPArray functionality for collecting and calling method implementations
* improved MulleDynamicObject with better forward: handling and generic type support
* renamed generic type enums to MulleObjCGenericType for consistency
* exposed `_MulleDynamicObjectForward` helper function for subclasses
* added documentation for proper forward: implementation in MulleDynamicObject

* use new memset32 function to scribble zombies
* NSMutableCopying moved to Foundation, because mulle-objc does not support it anymore


## 0.25.0

* NSInvocation does not raise anymore during -init as noone should raise during init
* NSAutoreleasePool name can now be 48-1 bytes long

* added new types `NSUIntegerAtomic` and `NSIntegerAtomic` to facilitate @property code
* experimental and *untested* `MulleProxy` class added
* added NSAutoreleasePool debugging facility to dump contents into CSV format for postprocessing with sqlite or scripts
* method `-[NSThread mulleDetach]` no longer exists!
* new NSThread methods `-mulleInitWithObjectFunction:object:` for convenient ownership transfer even when using C functions
* improved the teardown code of NSThread and improved the detached case
* added various `Instance` functions, where previously `Object` was used exlusively to properly differentiate Class and Instance code
* improved and simplified tracing with ``MULLE_OBJC_TRACE_ZOMBIE`` and ``MULLE_OBJC_TRACE_LEAK`,` which eliminates the need to use he finer grained variables a lot of times
* added `MulleObjCObjectIsInstance` and a host of other introspection functions dealing with Class and Instance distinctions


## 0.24.0


feat: improve thread safety and object lifecycle management

* Enhance thread affinity (TAO) support
  - Add mulleTAOStrategy parameter to mulleGainAccess for safer thread transfers
  - Improve thread safety checks and validation
  - Add documentation for TAO principles and testing

* Refactor object lifecycle management
  - Rename NSCopyObjectWithAllocator to MulleObjCInstanceCopyWithAllocator
  - Change MulleObjCInstanceDeallocate to `_MulleObjCInstanceFree`
  - Remove NS prefix from linkable symbols for better Darwin compatibility
  - Add `mulle_atomic_id_t` for atomic ivar access

* Improve thread and locking infrastructure
  - Simplify MulleObject locking implementation
  - Move MulleObjCLockFoundation into MulleObjC
  - Rename MulleObject to MulleDynamicObject
  - Update NSThread API for clearer thread lifecycle management
  - Add MulleThreadGetOrCreateCurrentThread function

* Other improvements
  - Add support for C-array, struct and union handling in NSInvocation
  - Add class interposing capability
  - Improve byte swapping and endian handling
  - Add new container key/value callbacks
  - Fix NSRange accessor functions



* **BREAKING** NSCopyObjectWithAllocator is now MulleObjCInstanceCopyWithAllocator
* **BREAKING** MulleObjCInstanceDeallocate is now `_MulleObjCInstanceFree` for consistency

* MulleObjC no longer defines any linkable symbols with `_NS` or NS prefix. All NS... functions are now static inline. This makes it easier on darwin to coexist with Apple Objective-C

* adapt to changes in mulle-objc-runtime
* improved NSInvocation retain/release of arguments, now can also do C-array, structs and unions
* new feature "interposing" of a class between two other classes
* new function `MulleThreadGetOrCreateCurrentThread`
* NSThread mulleStartUndetached is now just mulleStart, but the old method still works
* new type `mulle_atomic_id_t` for convenient atomic access to id ivars
* new function `MulleObjC_strdup`
* byte swapping and endian functions have been moved to mulle-c11
* new global variable MulleObjCDebugElideAddressOutput for test output
* new macros `MULLE_OBJC_CLASS_CAST` and `MULLE_OBJC_PROTOCOL_CAST` and related macros
* new key/value callbacks `_MulleObjCContainerCopiedCStringIntegerValueCallback,` `_MulleObjCContainerIntegerKeyCopiedCStringValueCallback,` `_MulleObjCContainerCopiedCStringPointerValueCallback,` `_MulleObjCContainerPointerKeyCopiedCStringValueCallback`
* new functions NSRangeGetLocation, NSRangeGetLength, NSRangeGetMax, ...

* `mulleGainAccess` no longer returns self
* the Spam functions that used to do call chains, now use `mulle_objc_class_search` and perform more sensibly
* new method `mulleSetThredSafe:`, for private objects that are part of a locking object (e.g. NSMutableArray ivar)

* renamed ``_mulle_objc_autorelease_object`` to ``_mulle_objc_autorelease_object`` for consistency
* changed the locking code used by MulleObject to something simpler with the help of the new mulle-objc-runtime
* renamed methods that operate on already autoreleased objects in a `NSAutoreleasePool` to "PoolObjects"
* renamed some ``_NSThread`` functions to `MulleThread` for consistency

* moved MulleObjCLockFoundation into MulleObjC
* renamed MulleObject to MulleDynamicObject
* renamed MulleLockingObject to... MulleObject (!) (by default it doesn't lock, unless your subclass adds protocols)


* **BREAKING** renamed a lot of NSAutoreleasePool underscore methods to mulle, making them less private

* added support for new double and float TPS
* NSObject now gains a lot of functionality from protocolclass MulleObjCRuntimeObject
* new protocol MulleObjCContainerProperty to match @property( container) expectations
* NSThread is now NSInvocation based

* MulleObjC has now a notion about threadsafe instances (`@protocol MulleObjcThreadSafe`) and how to transfer access to a not-threadsafe instance between threads (`-mulleGainAccess`...)
* added a few more useful container callbacks
* adapted to changes in the mulle-objc-runtime
* made `NSThread` more threadsafe
* **BREAKING** `-copy` is basically supposed to be used only by properties and ivar accessors now. `NSCopyObject` and the default -copy implementation is now aligned with `NSMutableCopying` where it makes more sense. Though `mutableCopy` is deprecated.
* **BREAKING** remove `MulleObjCIMPTraceCall`


## 0.23.0

* moved NSInteger and BOOL to mulle-c11, this only breaks stuff if you included the header directly
* new convenience function `MulleObjCAdjustRangeForLength`
* **BREAKING CHANGE** MulleObjCRangeSubtract has now a very different call signature
* NSNull has moved to MulleObjC
* Container callbacks have been reorganized again **BREAKING CHANGE**, definitions that really belong to MulleObjCContainerFoundation like ...Map...Callbacks are no longer in MulleObjC
* NSByteOrder now tries to include the right system header and puts more effort into defining endianess `__LITTLE_ENDIAN__` and `__BIG_ENDIAN__`
* new debugging function MulleObjCDumpObject uses introspection MulleObjCDescribeIvars (also new) to print all ivars of an object
* added **MulleObjCClassGetID** function
* change callback names from f.i. ValueRetainCallback to RetainValueCallback, since ValueCallback is closer to the type name
* add convenience ``mulle_buffer_do_autoreleased_string`` which should be more favored in use to ``mulle_buffer_do_string`` with a following MulleObjCAllocationAutorelease
* new ``NS_OPTIONS_LOOKUP`` and ``NS_ENUM_LOOKUP`` functions, more streamlines printing
* you can now store thread local objects with MulleThreadObjectForKeyUTF8String, which should be reasonably fast (but not as fast as tss)
* NSCopyObject is now smart with respect to properties and can properly retain them, unless you turn this off with +mulleCopyRetainsProperties
* new function MulleObjCDescribeMemory
* **breaking** renamed NSRangeUTF8String to MulleObjCRangeUTF8String
* added MulleObjCRangeFor
* added id helper functions such as `mulle_flexarray_do_id` or `mulle_id_copy`


### 0.22.1

* adapt to changes in mulle-objc-runtime

## 0.22.0

* add NSRangeUTF8String function
* add MulleObjCObjectPerformSelectorReturningBOOL convenience
* received container callbacks from MulleObjCContainerFoundation
* support for `NS_ENUM` and `NS_OPTIONS`


## 0.21.0

* change GLOBALs for Windows
* colorized terminal output support with colorizedUTF8String (see: [src/function/blob/release/mulle-sprintf-object.m]())
* NSThread can now call a C-function instead of a target/selector pair
* you can give NSThreads a name, which is useful for debugging
* `_MulleObjCClassAllocateObject` has been renamed to `_MulleObjCClassAllocateInstance` for consistency with the object=class|instance model of thought
* new MulleObjCInstanceGetClassNameUTF8String function


## 0.20.0

* NSAutoreleasePool which is a root class gains a +class method
* **breaking change** -cStringDescription is now -UTF8String. Also all **CString** functions are now UT8String, like `MulleObjCObjectSetDuplicatedUTF8String`
* special debugger support from mulle-objc-runtime has been moved here
* fix `forward:` method signature
* **`sizeof( `ptrdiff_t)` == sizeof( `uintptr_t)`` is now the law!**, for the benefit of reusing %td for NSInteger printfs
* use ``MulleObjC_vasprintf`` and ``MulleObjC_asprintf`` to create autoreleased character strings. Very convenient.
* NSAutoreleasePool gains a class method
* -UTF8String is now defined on NSObject. It's like description but for C strings. It replaces cStringDescription
* `sizeof( ptrdiff_t)` is know known to be the same as `sizeof( NSInteger)`
* mulle-objc-list is no longer a dependency. If you are developing a library, you should add that dependency back in. But mulle-objc-list is shared library based and conflicts with static musl builds (for now)
* last minute change: use multififo instead of fifo for NSInvocation


## 0.19.0

* moved lock code to **MulleObjCLockFoundation**
* added `MulleObjCClassSearchProperty` and `MulleObjCInstanceSearchProperty`
* added `MulleObjCClassGetNameCString` and related name lookups
* **ditched** copyWithZone: compatibility attempts
* NSAutoreleasePool uses the stdlib allocator, to quiet the amount of allocation trace output
* added `+mulleIsMainThread` to `NSThread`
* removed unused and forgotten `MulleObjCCopyObjects` and `MulleObjCCopyObjectArray` functions
* Zombies are now shredded by default
* `MulleObjCObjectSetClass` in DEBUG mode checks that the instance is large enough
* `NSMutableCopying` is now also a protocolclass to supply `mutableCopyWithZone:` to legacy code
* `MulleObjCContainerCallbacks` are no longer part of MulleObjC but moved to **MulleObjCContainerFoundation**

## 0.18.0

* `object` replaces `instantiate` as a fast methodid
* the foundation allocator is now a pointer and no longer a struct, which makes replacement easier
* added ``MULLE_OBJC_DEPENDS_ON_CATEGORY`` macro


### 0.17.2

* remove duplicate objc-loader.inc

### 0.17.1

* new mulle-sde project structure

## 0.17.0

* change prefix from `MulleObjCObject` to `MulleObjCInstance`, where the object can only be an instance and not a class
* change prefix from `MulleObjCObject` to `MulleObjCClass`, where the object can only be a class and not an instance
* force serialization for **NSThread** notifications (via ``_isProbablyGoingSingleThreaded`` and ``_isGoingMultiThreaded`)`
* You can now use `MulleMakeFullRange` or { 0, -1 } to specify { 0, [self length] }
* `MulleObjCValidateRangeAgainstLength` now returns a range (it can change, if range.length was -1)
* fix some new bugs introduced by the NSThread rewrite
* NSPushAutoreleasePool takes a parameter (which is ignored) added `_MulleAutoreleasePoolPush` that accepts a proper universeid for future use by the compiler
* redid NSInvocation so that the MetaABI block is aligned to at least alignof( double long)
* redid NSThread so that it is now possible to "escalate" a C `mulle_thread_t` to an ObjC thread
* renamed MulleObjCGetClassExtra to MulleObjCClassGetExtraBytes ( but don't use it ;))
* renamed MulleObjCGetInstanceExtra to MulleObjCInstanceGetExtraBytes
* added `MulleSELMapKeyCallBacks` and `MulleSELMapValueCallBacks`
* moved `NSMutableCopying` into MulleObjC
* add some optional methods to NSCoding protocol
* C-based vectorizable exceptions are now part of MulleObjC (like ``_MulleObjCThrowInvalidArgumentException`)`
* `MulleObjCHash` has moved into MulleObjC
* renamed `MulleObjCCallIMP` to `MulleObjCIMPCall` for consistency
* renamed `MulleObjCPerformSelector` to `MulleObjCObjectPerformSelector` for consistency
* added `MulleObjCAutoreleasedCalloc` function
* added `MulleObjCObjectSetDuplicatedCString` function
* fixed/documented calling `[super forward:]`, which needs to be done in C!
* allow finer control of argument handling by **NSThread** to support threadpools and the like
* added `object` (not! `mulleObject`) method to **NSObject** as the default convenience constructor, replacing alloc/init/autorelease
* fixes for **NSMethodSignature** and **NSInvocation**
* prefix/rename some non-standard methods and functions with mulle
* The main NSThread can now effectively wait for other NSThreads at exit
* added a missing file MulleObjCProtocol
* add asserts that singletons aren't nil when alloced
* moved some NSRange tests to mulle-container


## 0.16.0

* experimentally added MulleObjCValue and MulleObjCImmutable protocols
* fix memory clobber in NSInvocation
* added MulleThreadSetCurrentThreadUserInfo and MulleThreadGetCurrentThreadUserInfo functions
* fastmethods reshuffle, added objectForKey: and :
* new NSObject method -mulleContainsProtocol (doesn't ask superclass)
* moved startup code into own library MulleObjC-startup
* NSRunLoop is now using an instance variable in NSThread instead of the userInfo
* new NSThread method +mulleIsMultiThreaded, it knows if you are single-threaded or not
* uncaught exceptions now use abort instead of exit
* singletons return nil during universe deinitialization


### 0.15.2

* readonly properties aren't cleared anymore for compatibility

### 0.15.1

* remove mistakenly added craftinfo

## 0.15.0

* rename MulleObjCGetClass to MulleObjCObjectGetClass and SetClass too
* remove PROTOCOLCLASS warnings with `_Pragma`
* added MulleObjCClassGetLoadAddress
* NSFastEnumeration gains -count as member
* Improved NSRange validation with tests


### 0.14.1

* modernized mulle-sde with .mulle folder

## 0.14.0

* adapt to changes in 0.14.0
* reworked the universe configuration to make it easier to understand
* moved some of the convenience debug code from mulle-objc-runtime to MulleObjC
* MulleObjC is now universe aware
* restructured project and implemented a lot of the new naming scheme


## 0.13.0

* moved compiler and runtime tests to mulle-objc-runtime
* migrated to mulle-sde


## 0.12.1

* Separate startup from standalone

## 0.11.1

* fixes for mingw
* some changes to compile with mingw
* adjust to new hashing algorithm in runtime
* improve dealloc speed in certain cases
* fix possible alignment problem in NSMethodSignature
* the idea with "supreme" calls was nipped in the bud
* adapt to changes in mulle-objc-runtime


### 0.9.1

* adapt to changes in mulle_objc_runtime
* make it a cmake "C" project
* `MULLE_OBJC_COVERAGE` can be set to dump coverage information

### 0.8.4

* modernize project


0.8.4

* community release

0.8.3

* adapted to changes in the `mulle_objc_runtime`
* renamed internal class states to _NS_

0.8.1

* removed KVC support, to be transferred into its own library
* adapted to changes in the `mulle_objc_runtime`

0.6.1

* added the **MulleObjCLoader** class
* removed all `nonnull` from methods. An oversight from the past...
* added **MulleObjCRuntimeObject** for easier structure

0.4.1

* Moved **NSCoder** to MulleObjCFoundation
* Adapt to changes in the mulle_objc_runtime
* The Foundation can configure the exception type if so desired
* there is now no default `+initialize` method in NSObject!
* Introduced `mulle_objc_break_exception` as a convenient place to
break for.



0.2.1
====

Adapt to changes in the mulle_objc_runtime

0.1.7
=====

Merge in community changes


0.1.6
=====

Fix dependency

0.1.4
=====

Community release of 0.1.3

0.1.3
=====

Merge community release, fix GCC_VERSION

0.1.2
=====

Community beginning

0.1.1
=====

A new beginning

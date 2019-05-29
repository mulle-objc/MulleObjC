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

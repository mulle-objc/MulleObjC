# MulleObjC

MulleObjC supplies the most basic runtime components to build a foundation
on top of it.

### Objects

* NSAutoreleasePool
* NSCoder
* NSObject
* NSLock (* candidate for migration to MulleObjCFoundation)
* NSRecursiveLock (* candidate for migration to MulleObjCFoundation)
* NSInvocation
* NSMethodSignature
* NSProxy
* NSThread

### Protocols

* NSCoding
* NSCopying
* NSFastEnumeration
* NSObject
* MulleObjCSingleton
* MulleObjCClassCluster


It does all the interfacing with the mulle-objc-runtime. Any
library code above MulleObjC should not be using the mulle-objc-runtime
directly.

MulleObjC must be compiled with the **mulle-clang** compiler, or a compiler
which supports the metaABI required for the mulle-objc-runtime.

> MulleObjC is protocol based


## How to use

### Linking

When using static libraries, `-ObjC` doesn't work, because the compiler doesn't 
produce ObjC segments. Use `-all_load`.


## Dependencies

MulleObjC depends on

* standard C libraries only (f.e. no <unistd.h>)
* mulle_objc_runtime (and it's dependencies)
* mulle_container (for now, will move to mulle_concurrent later)

MulleObjC should not depend on `<unistd.h>` or any POSIX headers.


## Why the NS prefix ?

In 2015 my assumption is, that almost all existing ObjC code is NSObject based
(NSString, NSArray etc.). Having a prefix for an ObjC Foundation to be anything
else than NS is highly impractical and impedes code reuse.


## Why the MulleObjC prefix ?

NS prefixed stuff should be compatible. Stuff that is prefixed with MulleObJC
is not known on Mac OS X.


## Why the `ns_` prefix ?

The prefix `ns_` is not used by Apple. Putting `mulle_objc_` there might be
confusing with respect to the runtime, so `ns_`it is for now. It fits with
the filenames...


## What's up with the naming here ?

All camelcased files like NSObject or NSProxy, are Objective-C classes that a
Foundation using MulleObjC MUST NOT define (#ifdef them out). Anything in
lowercase like ns_ contains C code, that a Foundation would use and augment
with objects of it's own. `ns_` files should be includeable with pure C.

Any C function prefixed with '_' is not checking it's arguments and is free to
crash. Everything else should check it's arguments and return an error or raise
and must not crash (within reason).


## What about the methods ?

Prefixing all methods with mulle would be tedious and produce ungainly code.
Instead methods, that are not defined in OS X are prefixed with a '_'.

And possibly adorned with

`__attribute__((availability(macosx,unavailable)))`

This could be useful with a future compiler flag (-objc-crossplatform-warn).


## Acknowledgements

Parts of this library:

```
Copyright (c) 2006-2007 Christopher J. W. Lloyd
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```

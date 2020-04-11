# MulleObjC

💎 A collection of Objective-C root classes for mulle-objc

MulleObjC supplies the most basic runtime components to build a foundation
on top of it. MulleObjC fundamentally depends on standard C libraries only
(f.e. no `<unistd.h>`)


 Build Status | Release Version
--------------|-----------------------------------
[![Build Status](https://travis-ci.org/mulle-objc/MulleObjC.svg)](https://travis-ci.org/mulle-objc/MulleObjC) | ![Community tag](https://img.shields.io/github/tag/mulle-objc/MulleObjC.svg) [![Build Status](https://travis-ci.org/mulle-objc/MulleObjC.svg?branch=release)](https://travis-ci.org/mulle-objc/MulleObjC)


### Objects

* NSAutoreleasePool - garbage collection
* NSCoder - object serialization
* NSObject - the root class of everything
* NSLock - locking for threading
* NSRecursiveLock - recursive locking for threading
* NSInvocation - method call serialization
* NSMethodSignature - method description
* NSProxy - the other root class of everything :=)
* NSThread - threads

### Protocols

* NSCoding - object serialization
* NSCopying - object copying
* NSFastEnumeration  - support for `for ... in` loops
* NSLocking  - support for `for ... in` loops
* NSObject - for objects that don't want to behave like NSObject but can't be them
* MulleObjCClassCluster - enables classes to act as class clusters
* MulleObjCException - enabled a class to act as an exception
* MulleObjCRuntimeObject - documents the minimum required id superset
* MulleObjCSingleton - enables classes to produce singletons
* MulleObjCTaggedPointer - enables classes to use tagged pointers

It does all the interfacing with the **mulle-objc** runtime. Any
library code above MulleObjC ideally, should not be using the mulle-objc runtime
directly. Creating a foundation on top of **mulle-objc**  without using
**MulleObjC** is a foolhardy endeavor IMO.

MulleObjC must be compiled with the **mulle-clang** compiler, or a compiler
which supports the metaABI required for the mulle-objc runtime.

## Required Libraries and Tools

![Libraries and Tools](https://raw.githubusercontent.com/mulle-objc/MulleObjC/release/dox/MulleObjC-dependencies.png)

  Name         | Build Status | Release Version
---------------|--------------|---------------------------------
[mulle-container](//github.com/mulle-c/mulle-container) | [![Build Status](https://travis-ci.org/mulle-c/mulle-container.svg?branch=release)](https://travis-ci.org/mulle-c/mulle-container) | ![Mulle kybernetiK tag](https://img.shields.io/github/tag/mulle-c/mulle-container.svg) [![Build Status](https://travis-ci.org/mulle-c/mulle-container.svg?branch=release)](https://travis-ci.org/mulle-c/mulle-container)
[mulle-objc-list](//github.com/mulle-objc/mulle-objc-list) | [![Build Status](https://travis-ci.org/mulle-objc/mulle-objc-list.svg?branch=release)](https://travis-ci.org/mulle-objc/mulle-objc-list) | ![Mulle kybernetiK tag](https://img.shields.io/github/tag/mulle-objc/mulle-objc-list.svg) [![Build Status](https://travis-ci.org/mulle-objc/mulle-objc-list.svg?branch=release)](https://travis-ci.org/mulle-objc/mulle-objc-list)
[mulle-objc-runtime](//github.com/mulle-objc/mulle-objc-runtime) | [![Build Status](https://travis-ci.org/mulle-objc/mulle-objc-runtime.svg?branch=release)](https://travis-ci.org/mulle-objc/mulle-objc-runtime) | ![Mulle kybernetiK tag](https://img.shields.io/github/tag/mulle-objc/mulle-objc-runtime.svg) [![Build Status](https://travis-ci.org/mulle-objc/mulle-objc-runtime.svg?branch=release)](https://travis-ci.org/mulle-objc/mulle-objc-runtime)


## Add

This is project is a [mulle-sde](https://mulle-sde.github.io/) project.
Add it with:

```
mulle-sde dependency add --objc --github mulle-objc MulleObjC
```

Executables will need to link with [MulleObjC-startup](//github.com/mulle-objc/MulleObjC-startup) as well.

## Install

See [mulle-objc-developer](//github.com/mulle-objc/mulle-objc-developer) for
installation instructions.

## Acknowledgements

Parts of this library:

```
Copyright (c) 2006-2007 Christopher J. W. Lloyd
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```

### Platforms and Compilers

All platforms and compilers supported by
[mulle-c11](//github.com/mulle-c/mulle-c11/) and
[mulle-thread](//github.com/mulle-concurrent/mulle-thread/).


## Author

[Nat!](//www.mulle-kybernetik.com/weblog) for
[Mulle kybernetiK](//www.mulle-kybernetik.com) and
[Codeon GmbH](//www.codeon.de)

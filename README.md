# MulleObjC

#### 💎 A collection of Objective-C root classes for mulle-objc

MulleObjC supplies the most basic runtime components like NSObject or NSThread
to build a foundation on top of it. MulleObjC depends on standard C libraries 
only and for instance not on `<unistd.h>`.



| Release Version                                       | Release Notes  | AI Documentation
|-------------------------------------------------------|----------------|---------------
| ![Mulle kybernetiK tag](https://img.shields.io/github/tag/mulle-objc/MulleObjC.svg) [![Build Status](https://github.com/mulle-objc/MulleObjC/workflows/CI/badge.svg)](//github.com/mulle-objc/MulleObjC/actions) | [RELEASENOTES](RELEASENOTES.md) | [DeepWiki for MulleObjC](https://deepwiki.com/mulle-objc/MulleObjC)


## API

### Classes

* NSAutoreleasePool - garbage collection
* NSObject - the root class of everything
* NSInvocation - method call serialization
* NSMethodSignature - method description
* NSProxy - the other root class of everything :=)
* NSThread - threads

### Protocol and Protocolclasses

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

### Functions

* `mulle_printf` and variants


It does all the interfacing with the **mulle-objc** runtime. Any
library code above MulleObjC ideally, should not be using the mulle-objc runtime
directly. Creating a foundation on top of **mulle-objc**  without using
**MulleObjC** is a foolhardy endeavor IMO.

MulleObjC must be compiled with the **mulle-clang** compiler, or a compiler
which supports the metaABI required for the mulle-objc runtime.





### You are here

![Overview](overview.dot.svg)



## Requirements

|   Requirement         | Release Version  | Description
|-----------------------|------------------|---------------
| [mulle-objc-runtime](https://github.com/mulle-objc/mulle-objc-runtime) | ![Mulle kybernetiK tag](https://img.shields.io/github/tag/mulle-objc/mulle-objc-runtime.svg) [![Build Status](https://github.com/mulle-objc/mulle-objc-runtime/workflows/CI/badge.svg?branch=release)](https://github.com/mulle-objc/mulle-objc-runtime/actions/workflows/mulle-sde-ci.yml) | ⏩ A fast, portable Objective-C runtime written 100% in C11
| [mulle-objc-debug](https://github.com/mulle-objc/mulle-objc-debug) | ![Mulle kybernetiK tag](https://img.shields.io/github/tag/mulle-objc/mulle-objc-debug.svg) [![Build Status](https://github.com/mulle-objc/mulle-objc-debug/workflows/CI/badge.svg?branch=release)](https://github.com/mulle-objc/mulle-objc-debug/actions/workflows/mulle-sde-ci.yml) | 🐞 Debug support for the mulle-objc-runtime
| [mulle-objc-cc](https://github.com/mulle-cc/mulle-objc-cc) | ![Mulle kybernetiK tag](https://img.shields.io/github/tag/mulle-cc/mulle-objc-cc.svg) [![Build Status](https://github.com/mulle-cc/mulle-objc-cc/workflows/CI/badge.svg?branch=release)](https://github.com/mulle-cc/mulle-objc-cc/actions/workflows/mulle-sde-ci.yml) | ⏩ make mulle-clang the default Objective-C compiler
| [mulle-objc-list](https://github.com/mulle-objc/mulle-objc-list) | ![Mulle kybernetiK tag](https://img.shields.io/github/tag/mulle-objc/mulle-objc-list.svg) [![Build Status](https://github.com/mulle-objc/mulle-objc-list/workflows/CI/badge.svg?branch=release)](https://github.com/mulle-objc/mulle-objc-list/actions/workflows/mulle-sde-ci.yml) | 📒 Lists mulle-objc runtime information contained in executables.


## Add

Use [mulle-sde](//github.com/mulle-sde) to add MulleObjC to your project.
As long as your sources are using `#import "import-private.h"` and your headers use `#import "import.h"`, there will nothing more to do:

``` sh
mulle-sde add github:mulle-objc/MulleObjC
```

To only add the sources of MulleObjC with all the sources of its
dependencies replace "github:" with [clib:](https://github.com/clibs/clib):

## Legacy adds

One common denominator is that you will likely have to add
`#import <MulleObjC/MulleObjC.h>` to your source files.


### Add sources to your project with clib

``` sh
clib install --out src/mulle-objc mulle-objc/MulleObjC
```

Add `-isystem src/mulle-objc` to your `CFLAGS` and compile all the
sources that were downloaded with your project. (In **cmake** add
`include_directories( BEFORE SYSTEM src/mulle-objc)` to your `CMakeLists.txt`
file).







### Add as subproject with cmake and git

``` bash
git submodule add -f --name "mulle-objc-runtime" \
                            "https://github.com/mulle-objc/mulle-objc-runtime.git" \
                            "stash/mulle-objc-runtime"
git submodule add -f --name "mulle-objc-debug" \
                            "https://github.com/mulle-objc/mulle-objc-debug.git" \
                            "stash/mulle-objc-debug"
git submodule add -f --name "MulleObjC" \
                            "https://github.com/mulle-objc/MulleObjC" \
                            "stash/MulleObjC"
git submodule update --init --recursive
```

``` cmake
add_subdirectory( stash/MulleObjC)
add_subdirectory( stash/mulle-objc-debug)
add_subdirectory( stash/mulle-objc-runtime)

target_link_libraries( ${PROJECT_NAME} PUBLIC MulleObjC)
target_link_libraries( ${PROJECT_NAME} PUBLIC mulle-objc-debug)
target_link_libraries( ${PROJECT_NAME} PUBLIC mulle-objc-runtime)
```


## Install

Use [mulle-sde](//github.com/mulle-sde) to build and install MulleObjC and all dependencies:

``` sh
mulle-sde install --prefix /usr/local \
   https://github.com/mulle-objc/MulleObjC/archive/latest.tar.gz
```

### Legacy Installation


#### Requirements

Install all requirements

| Requirements                                 | Description
|----------------------------------------------|-----------------------
| [mulle-objc-runtime](https://github.com/mulle-objc/mulle-objc-runtime)             | ⏩ A fast, portable Objective-C runtime written 100% in C11
| [mulle-objc-debug](https://github.com/mulle-objc/mulle-objc-debug)             | 🐞 Debug support for the mulle-objc-runtime
| [mulle-objc-cc](https://github.com/mulle-cc/mulle-objc-cc)             | ⏩ make mulle-clang the default Objective-C compiler
| [mulle-objc-list](https://github.com/mulle-objc/mulle-objc-list)             | 📒 Lists mulle-objc runtime information contained in executables.

#### Download & Install


Download the latest [tar](https://github.com/mulle-objc/MulleObjC/archive/refs/tags/latest.tar.gz) or [zip](https://github.com/mulle-objc/MulleObjC/archive/refs/tags/latest.zip) archive and unpack it.

Install **MulleObjC** into `/usr/local` with [cmake](https://cmake.org):

``` sh
PREFIX_DIR="/usr/local"
cmake -B build                               \
      -DMULLE_SDK_PATH="${PREFIX_DIR}"       \
      -DCMAKE_INSTALL_PREFIX="${PREFIX_DIR}" \
      -DCMAKE_PREFIX_PATH="${PREFIX_DIR}"    \
      -DCMAKE_BUILD_TYPE=Release &&
cmake --build build --config Release &&
cmake --install build --config Release
```


## Author

[Nat!](https://mulle-kybernetik.com/weblog) for Mulle kybernetiK  




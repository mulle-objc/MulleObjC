# MulleObjC

#### 💎 A collection of Objective-C root classes for mulle-objc

MulleObjC supplies the most basic runtime components like NSObject or NSThread
to build a foundation on top of it. MulleObjC depends on standard C libraries 
only and for instance not on `<unistd.h>`.



| Release Version                                       | Release Notes
|-------------------------------------------------------|--------------
| ![Mulle kybernetiK tag](https://img.shields.io/github/tag/mulle-objc/MulleObjC.svg?branch=release) [![Build Status](https://github.com/mulle-objc/MulleObjC/workflows/CI/badge.svg?branch=release)](//github.com/mulle-objc/MulleObjC/actions) | [RELEASENOTES](RELEASENOTES.md) |


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




# Objective-C for the C programmer

We go from extremely low level to high level here.

Objective-C deals mainly with classes in addition to the C datatypes like
int and struct you already know. 

Lets contrast a C struct with an Objective-C class.

In a C struct you define a data type:

``` c
struct person 
{
  char *name;
  int age;
};
```

In C to allocate a `struct person`, you could say `malloc( sizeof( struct person))`.
To operate on such a `struct person`, you define C functions that take a 
`struct person` pointer:

``` c
void   person_print( struct person *p) 
{
  printf("%s %d\n", p->name, p->age);
}
```

In Objective-C you would declare a class like this:

``` objc
@interface Person  
{
@public
  char *name;
  int age; 
}

- (void) print;

@end
```

and implement it like this:

``` objc
@implementation Person 

- (void) print 
{
  printf("%s %d\n", self->name, self->age);
}
```
@end
```

To actually allocate such a `Person`, you
## Memory layout


The memory layout of such a Objective-C Person, would 

A `struct mulle_objc_objectheader` containing a reference count, and the
`isa` pointer (and possibly other information). This header is then followed
by the instance variables (ivars) of the class


``` 

The memory layout of the allocation used by an instance would be:

``` objc
struct 
{
  struct mulle_objc_objectheader header;
  char *name;
  int age;
}
```

So mulle-objc methods map to C functions that take the object pointer as the first parameter.

The key differences are that mulle-objc provides object-oriented features like dot syntax, automatic memory management, inheritance, etc, whereas C structs are just custom data types without those features.

===

To allocate an object, call the class method +alloc on the class:

MyClass* obj = [MyClass alloc];
This allocates memory for the object and retains it once.

To initialize the object, call -init:

obj = [obj init];
The -init method initializes the object's state and returns the initialized object.

To increase the retain count, call -retain:

[obj retain];
This increments the object's reference count.

To decrease the retain count, call -release:

[obj release];
This decrements the object's reference count. When the count reaches zero, -finalize and then -dealloc are called automatically.

-finalize is called when the object's reference count goes to zero, before -dealloc. It allows the object to clean up resources besides its own memory before being destroyed.

-dealloc should free the object's memory.

-mullePerformFinalize can be used to manually call -finalize early if needed.

A full example:

MyClass* obj = [MyClass alloc]; // retained once
obj = [obj init]; 

[obj retain]; // increment ref count to 2

// use object

[obj release]; // decrement ref count to 1
               // not yet destroyed
               
[obj release]; // decrement ref count to 0
               // -finalize and -dealloc called automatically
The key differences from Apple Objective-C are:

mulle-objc uses reference counting only, no garbage collection
mulle-objc has -finalize in addition to -dealloc
mulle-objc is focused on being embeddable and portable C
Let me know if any part needs more explanation!


=====

The fundamental unit in mulle-objc is the classpair, which consists of an infraclass and a metaclass.

The infraclass holds:

The instance methods that operate on instances of the class
The instance variables (ivars) that make up the instance data
Other per-instance data like the retain count
The metaclass holds:

The class methods like +alloc that operate on the class itself
Class properties like the superclass and name
Other per-class data
Both the infraclass and metaclass are represented by a mulle_objc_class struct containing:

The class methods, instance methods, ivars, and other data in table form
Metadata like the superclass pointer and protocol list
So in memory there is a single mulle_objc_class for the infraclass and another for the metaclass.

When you create an object, memory is allocated for:

A mulle_objc_objectheader struct holding retain count, etc
The instance variables of the infraclass
So the object data follows the infraclass layout. The infraclass methods can then operate on the object data.

When you call a class method, the metaclass methods operate on the metaclass data




### You are here

![Overview](overview.dot.svg)



## Requirements

|   Requirement         | Release Version  | Description
|-----------------------|------------------|---------------
| [mulle-container](https://github.com/mulle-c/mulle-container) | ![Mulle kybernetiK tag](https://img.shields.io/github/tag//.svg) [![Build Status](https://github.com///workflows/CI/badge.svg?branch=release)](https://github.com///actions/workflows/mulle-sde-ci.yml) | 🛄 Arrays, hashtables and a queue
| [mulle-fprintf](https://github.com/mulle-core/mulle-fprintf) | ![Mulle kybernetiK tag](https://img.shields.io/github/tag//.svg) [![Build Status](https://github.com///workflows/CI/badge.svg?branch=release)](https://github.com///actions/workflows/mulle-sde-ci.yml) | 🔢 mulle-fprintf marries mulle-sprintf to stdio.h
| [mulle-multififo](https://github.com/mulle-concurrent/mulle-multififo) | ![Mulle kybernetiK tag](https://img.shields.io/github/tag//.svg) [![Build Status](https://github.com///workflows/CI/badge.svg?branch=release)](https://github.com///actions/workflows/mulle-sde-ci.yml) | 🐛 mulle-multififo multi-producer/multi-consumer FIFO holding `void *`
| [mulle-objc-runtime](https://github.com/mulle-objc/mulle-objc-runtime) | ![Mulle kybernetiK tag](https://img.shields.io/github/tag//.svg) [![Build Status](https://github.com///workflows/CI/badge.svg?branch=release)](https://github.com///actions/workflows/mulle-sde-ci.yml) | ⏩ A fast, portable Objective-C runtime written 100% in C11
| [mulle-objc-debug](https://github.com/mulle-objc/mulle-objc-debug) | ![Mulle kybernetiK tag](https://img.shields.io/github/tag//.svg) [![Build Status](https://github.com///workflows/CI/badge.svg?branch=release)](https://github.com///actions/workflows/mulle-sde-ci.yml) | 🐞 Debug support for the mulle-objc-runtime
| [mulle-objc-list](https://github.com/mulle-objc/mulle-objc-list) | ![Mulle kybernetiK tag](https://img.shields.io/github/tag//.svg) [![Build Status](https://github.com///workflows/CI/badge.svg?branch=release)](https://github.com///actions/workflows/mulle-sde-ci.yml) | 📒 Lists mulle-objc runtime information contained in executables.
| [mulle-objc-cc](https://github.com/mulle-cc/mulle-objc-cc) | ![Mulle kybernetiK tag](https://img.shields.io/github/tag//.svg) [![Build Status](https://github.com///workflows/CI/badge.svg?branch=release)](https://github.com///actions/workflows/mulle-sde-ci.yml) | ⏩ make mulle-clang the default Objective-C compiler


## Add

**This project is a component of the [mulle-core](//github.com/mulle-core/mulle-core) library. As such you usually will *not* add or install it
individually, unless you specifically do not want to link against
`mulle-core`.**


### Add as an individual component

Use [mulle-sde](//github.com/mulle-sde) to add MulleObjC to your project:

``` sh
mulle-sde add github:mulle-objc/MulleObjC
```

To only add the sources of MulleObjC with dependency
sources use [clib](https://github.com/clibs/clib):


``` sh
clib install --out src/mulle-objc mulle-objc/MulleObjC
```

Add `-isystem src/mulle-objc` to your `CFLAGS` and compile all the sources that were downloaded with your project.


## Install

### Install with mulle-sde

Use [mulle-sde](//github.com/mulle-sde) to build and install MulleObjC and all dependencies:

``` sh
mulle-sde install --prefix /usr/local \
   https://github.com///archive/latest.tar.gz
```

### Manual Installation

Install the [Requirements](#Requirements) and then
install **MulleObjC** with [cmake](https://cmake.org):

``` sh
cmake -B build \
      -DCMAKE_INSTALL_PREFIX=/usr/local \
      -DCMAKE_PREFIX_PATH=/usr/local \
      -DCMAKE_BUILD_TYPE=Release &&
cmake --build build --config Release &&
cmake --install build --config Release
```


## Author

[Nat!](https://mulle-kybernetik.com/weblog) for Mulle kybernetiK  




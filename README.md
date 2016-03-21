# MulleObjC

MulleObjC supplies the most basic runtime components to build a foundation
on top of it. It does all the interfacing with the mulle-objc-runtime. Any
library code above MulleObjC should not be using the mulle-objc-runtime
directly.

MulleObjC must be compiled with the mulle-clang compiler, or a compiler which
supports the metaABI required for the mulle-objc-runtime.

> MulleObjC is protocol based


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

Anything prefixed with '_' is not checking it's arguments and is free to crash.
Everything else should check it's arguments and return an error or raise and
must not crash (within reason).


## What about the methods ?

Prefixing all methods with mulle would be tedious and produce ungainly code.
Instead methods, that are not defined in OS X are adorned with

`__attribute__((availability(macosx,unavailable)))`

This could be useful with a future compiler flag (-objc-crossplatform-warn).


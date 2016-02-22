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

## What's up with the naming here ?

All camelcased files like NSObject or NSProxy, are Objective-C classes that a
Foundation MUST NOT defined (#ifdef them out). Anything in lowercase like
ns_ contains C code, that a Foundation would use and augment with objects of
it's own. `ns_` files should be includeable with pure C.

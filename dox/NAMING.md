# Method and Class naming

## Why the NS prefix ?

In 2015 my assumption is, that almost all existing ObjC code is NSObject based
(NSString, NSArray etc.). Having a prefix for an ObjC Foundation to be anything
else than NS is highly impractical and impedes code reuse.


## Why the mulle / MulleObjC prefix ?

NS prefixed stuff should be compatible. Stuff that is prefixed with MulleObjC
is not known on Mac OS X. Non-standard classes are free to introduce
their own selectors (e.g.) But new selectors on standard classed have the
mulle prefix.


## Why the `ns_` prefix ?

The prefix `ns_` is not used by Apple. Putting `mulle_objc_` there might be
confusing with respect to the runtime, so `ns_` it is for now for functions defined
in MulleObjC.  (this is phased out. Move non-object functions to a separate
C library, name object functions MulleObjC)


## What's up with the mixed file naming schemes here, CamelCase or what ?

All camelcased files like **NSObject** or **NSProxy**, are Objective-C classes that a
Foundation using MulleObjC MUST NOT define themselves(#ifdef them out).
Anything in lowercase like `ns_` contains C code. They should be include-able with
pure C.

Any C function prefixed with '`_`' is not checking it's arguments and is free to
crash. Everything else should check it's arguments and return an error or raise
and must not crash (within reason).


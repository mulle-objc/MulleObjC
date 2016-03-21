
## Linking
======================

-ObjC doesn't work, because the compiler doesn't produce ObjC segments.
Use -all_load.

## Global Variables
======================

* ns_root_setup a function pointer


## Exceptions
======================

All C Exceptions are vectored to abort()


## Linking
======================

-ObjC doesn't work, because the compiler doesn't produce ObjC segments.
Use -all_load.

## Global Variables
======================

struct _mulle_objc_runtime  *(*ns_root_setup)( void);



## Memory management
======================

Classes are constructed by the runtime using the allocators defined in
`struct _mulle_objc_runtime_alloc` those are not touched.

Instances are created by `_mulle_objc_class_alloc_object` which goes through
`(*class->alloc)()`. That value is usually supplied by 
`struct _mulle_objc_runtime_class_vectors`, but can be overridden on a per class
basis.

This doesn't affect previously created instances.


## Exceptions
======================

All C Exceptions are vectored to abort()

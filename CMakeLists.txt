cmake_minimum_required (VERSION 3.0)

project ( MulleObjC)

include_directories(
src/roots
src/roots/protocols
)

include_directories( BEFORE SYSTEM
dependencies/include
)


set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -O3 -g -DNDEBUG")

set(HEADERS
src/roots/NSObjC.h
src/roots/ns_type.h
src/roots/ns_objc.h
src/roots/ns_objc_include.h
src/roots/ns_rootconfiguration.h
src/roots/protocols/NSCopying.h
src/roots/protocols/NSMutableCopying.h
src/roots/protocols/NSObjectProtocol.h
src/roots/ns_allocation.h
src/roots/NSAllocation.h
src/roots/NSAutoreleasePool.h
src/roots/NSAutoreleasePool+Private.h
src/roots/ns_debug.h
src/roots/NSDebug.h
src/roots/NSObject.h
src/roots/NSProxy.h
src/roots/_ns_exception.h
src/roots/ns_exception.h
src/roots/_ns_autoreleasepointerarray.h
src/roots/ns_range.h
src/roots/NSThread.h
src/roots/ns_zone.h
)


add_library( MulleObjC SHARED
src/roots/ns_rootconfiguration.c
src/roots/ns_allocation.c
src/roots/ns_debug.c
src/roots/ns_range.c
src/roots/NSAutoreleasePool.m
src/roots/NSDebug.m
src/roots/NSObject.m
src/roots/NSProxy.m
src/roots/NSThread.m
)


INSTALL(TARGETS MulleObjC DESTINATION "lib")
INSTALL(FILES ${HEADERS} DESTINATION "include/MulleObjC")

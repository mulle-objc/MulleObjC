cmake_minimum_required (VERSION 3.0)

project (MulleObjC)

include_directories(
src
src/protocols
)

include_directories( BEFORE SYSTEM
dependencies/include
)


set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -O3 -g -DNDEBUG")

set(HEADERS
src/MulleObjC.h
src/MulleObjCAllocation.h
src/MulleObjCFunctions.h
src/MulleStandaloneObjC.h
src/NSAutoreleasePool.h
src/NSDebug.h
src/NSInvocation.h
src/NSLock.h
src/NSMethodSignature+Private.h
src/NSMethodSignature.h
src/NSObject.h
src/NSProxy.h
src/NSRecursiveLock.h
src/NSThread.h
src/ns_allocation.h
src/ns_debug.h
src/ns_exception.h
src/ns_fastclassids.h
src/ns_fastmethodids.h
src/ns_objc.h
src/ns_objc_include.h
src/ns_range.h
src/ns_rootconfiguration.h
src/ns_test_allocation.h
src/ns_threadconfiguration.h
src/ns_type.h
src/ns_zone.h
src/protocols/MulleObjCClassCluster.h
src/protocols/MulleObjCException.h
src/protocols/MulleObjCSingleton.h
src/protocols/NSCopying.h
src/protocols/NSFastEnumeration.h
src/protocols/NSLocking.h
src/protocols/NSObjectProtocol.h)


add_library(MulleObjC
src/MulleObjCAllocation.m
src/MulleObjCFunctions.m
src/NSAutoreleasePool.m
src/NSDebug.m
src/NSInvocation.m
src/NSLock.m
src/NSMethodSignature.m
src/NSObject.m
src/NSProxy.m
src/NSRecursiveLock.m
src/NSThread.m
src/ns_allocation.c
src/ns_debug.c
src/ns_range.c
src/ns_rootconfiguration.c
src/ns_test_allocation.c
src/protocols/MulleObjCClassCluster.m
src/protocols/MulleObjCException.m
src/protocols/MulleObjCSingleton.m
src/protocols/NSCopying.m)


INSTALL(TARGETS MulleObjC DESTINATION "lib")
INSTALL(FILES ${HEADERS} DESTINATION "include/MulleObjC")

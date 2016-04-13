cmake_minimum_required (VERSION 3.0)

project (MulleObjC)


set( CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_SOURCE_DIR}/mulle-configuration)
message(STATUS "CMAKE_MODULE_PATH is ${CMAKE_MODULE_PATH}")
message(STATUS "CMAKE_BUILD_TYPE is ${CMAKE_BUILD_TYPE}")
if( "${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
  include( Debug)
else()
  include( Release)
endif()


include_directories(
src
src/protocols
)


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
src/_ns_exception.h
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


add_library(MulleObjC STATIC
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


add_library( MulleStandaloneObjC SHARED
src/MulleStandaloneObjC.m
src/ns_test_allocation.c
)

add_dependencies( MulleStandaloneObjC MulleObjC)

TARGET_LINK_LIBRARIES( MulleStandaloneObjC
MulleObjC
mulle_objc_runtime
mulle_container
mulle_concurrent
mulle_aba
mulle_allocator
mulle_test_allocator )


INSTALL( TARGETS MulleObjC MulleStandaloneObjC DESTINATION "lib")
INSTALL( FILES ${HEADERS} DESTINATION "include/MulleObjC")
INSTALL( FILES src/MulleStandaloneObjC.h src/ns_test_allocation.h DESTINATION "include/MulleStandaloneObjC")

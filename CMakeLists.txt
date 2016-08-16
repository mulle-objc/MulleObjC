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
src/NSAutoreleasePool.h
src/NSCoder.h
src/NSDebug.h
src/NSInvocation.h
src/NSLock.h
src/NSMethodSignature.h
src/NSObject+NSCoding.h
src/NSObject+KVCSupport.h
src/NSObject.h
src/NSProxy.h
src/NSRecursiveLock.h
src/NSThread.h
src/_ns_exception.h
src/ns_debug.h
src/ns_exception.h
src/ns_fastclassids.h
src/ns_fastmethodids.h
src/ns_objc.h
src/ns_objc_compatibility.h
src/ns_objc_include.h
src/ns_objc_setup.h
src/ns_range.h
src/ns_rootconfiguration.h
src/ns_test_allocation.h
src/ns_threadconfiguration.h
src/ns_type.h
src/ns_zone.h
src/protocols/MulleObjCClassCluster.h
src/protocols/MulleObjCException.h
src/protocols/MulleObjCSingleton.h
src/protocols/MulleObjCTaggedPointer.h
src/protocols/NSCoding.h
src/protocols/NSCopying.h
src/protocols/NSFastEnumeration.h
src/protocols/NSLocking.h
src/protocols/NSObjectProtocol.h
)


add_library(MulleObjC STATIC
src/MulleObjCAllocation.m
src/MulleObjCFunctions.m
src/NSAutoreleasePool.m
src/NSCoder.m
src/NSDebug.m
src/NSInvocation.m
src/NSLock.m
src/NSMethodSignature.m
src/NSObject.m
src/NSObject+NSCoding.m
src/NSObject+KVCSupport.m
src/NSProxy.m
src/NSRecursiveLock.m
src/NSThread.m
src/ns_debug.c
src/ns_exception.c
src/ns_objc_setup.c
src/ns_range.c
src/ns_rootconfiguration.c
src/ns_test_allocation.c
src/protocols/MulleObjCClassCluster.m
src/protocols/MulleObjCException.m
src/protocols/MulleObjCSingleton.m
src/protocols/MulleObjCTaggedPointer.m
src/protocols/NSCoding.m
src/protocols/NSCopying.m)


add_library( MulleObjCStandalone SHARED
src/MulleObjCStandalone.m
)

add_dependencies( MulleObjCStandalone MulleObjC)

TARGET_LINK_LIBRARIES( MulleObjCStandalone
${BEGIN_ALL_LOAD}
MulleObjC
mulle_objc
mulle_container
mulle_concurrent
mulle_aba
mulle_allocator
mulle_test_allocator
${END_ALL_LOAD}
)


INSTALL( TARGETS MulleObjC MulleObjCStandalone DESTINATION "lib")
INSTALL( FILES ${HEADERS} DESTINATION "include/MulleObjC")

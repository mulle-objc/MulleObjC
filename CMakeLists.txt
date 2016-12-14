cmake_minimum_required (VERSION 3.0)

# https://stackoverflow.com/questions/13054451/cmake-problems-specifying-the-compiler-2
# don't do that:
#    set( CMAKE_C_COMPILER
# instead
#    cmake -DCMAKE_C_COMPILER=mulle-clang -DCMAKE_CXX_COMPILER=mulle-clang
#
project (MulleObjC)

set( CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_SOURCE_DIR}/mulle-configuration)
message(STATUS "CMAKE_MODULE_PATH is ${CMAKE_MODULE_PATH}")
message(STATUS "CMAKE_BUILD_TYPE is ${CMAKE_BUILD_TYPE}")

set( MULLE_LANGUAGE "ObjC")

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

if( MSVC)
   set( DEF_FILE MulleObjCStandalone.def)
   set_source_files_properties( ${DEF_FILE} PROPERTIES HEADER_FILE_ONLY TRUE)
   set( CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS OFF)
   set( CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} /DEF:${DEF_FILE}")
   # /NODEFAULTLIB:MSVCRT")
endif()

add_library( MulleObjCStandalone SHARED
src/MulleObjCStandalone.m
${HEADERS}
${DEF_FILE}
)


find_library( MULLE_ABA_LIBRARY            NAMES mulle_aba)
find_library( MULLE_ALLOCATOR_LIBRARY      NAMES mulle_allocator)
find_library( MULLE_CONCURRENT_LIBRARY     NAMES mulle_concurrent)
find_library( MULLE_CONTAINER_LIBRARY      NAMES mulle_container)
find_library( MULLE_OBJC_RUNTIME_LIBRARY   NAMES mulle_objc)
find_library( MULLE_TEST_ALLOCATOR_LIBRARY NAMES mulle_test_allocator)
find_library( MULLE_THREAD_LIBRARY         NAMES mulle_thread)

message(STATUS "MULLE_ABA_LIBRARY is ${MULLE_ABA_LIBRARY}")
message(STATUS "MULLE_ALLOCATOR_LIBRARY is ${MULLE_ALLOCATOR_LIBRARY}")
message(STATUS "MULLE_CONCURRENT_LIBRARY is ${MULLE_CONCURRENT_LIBRARY}")
message(STATUS "MULLE_CONTAINER_LIBRARY is ${MULLE_CONTAINER_LIBRARY}")
message(STATUS "MULLE_OBJC_RUNTIME_LIBRARY is ${MULLE_OBJC_RUNTIME_LIBRARY}")
message(STATUS "MULLE_TEST_ALLOCATOR_LIBRARY is ${MULLE_TEST_ALLOCATOR_LIBRARY}")
message(STATUS "MULLE_THREAD_LIBRARY is ${MULLE_THREAD_LIBRARY}")


set( DEPENDENCY_LIBRARIES
${MULLE_ABA_LIBRARY}
${MULLE_ALLOCATOR_LIBRARY}
${MULLE_CONCURRENT_LIBRARY}
${MULLE_CONTAINER_LIBRARY}
${MULLE_OBJC_RUNTIME_LIBRARY}
${MULLE_TEST_ALLOCATOR_LIBRARY}
${MULLE_THREAD_LIBRARY}
)


add_dependencies( MulleObjCStandalone MulleObjC)

if( MSVC)
   add_custom_command( OUTPUT ${DEF_FILE}
                       COMMAND mulle-mingw-dumpdef.bat -o "${DEF_FILE}" --directory "${BUILD_RELATIVE_DEPENDENCIES_DIR}/lib" --prefix "mulle" --prefix Mulle --prefix ns --prefix NS ${DEPENDENCY_LIBRARIES} $<TARGET_FILE:MulleObjC>
                       DEPENDS "${SOURCES}" "${HEADERS}"
                       VERBATIM)
endif()


TARGET_LINK_LIBRARIES( MulleObjCStandalone
${BEGIN_ALL_LOAD}
MulleObjC
${DEPENDENCY_LIBRARIES}
${END_ALL_LOAD}
)


INSTALL( TARGETS MulleObjC MulleObjCStandalone DESTINATION "lib")
INSTALL( FILES ${HEADERS} DESTINATION "include/MulleObjC")

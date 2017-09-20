cmake_minimum_required (VERSION 3.0)


project( MulleObjC C )  # OBJC in the future! :)

# https://stackoverflow.com/questions/13054451/cmake-problems-specifying-the-compiler-2
# don't do that:
#    set( CMAKE_C_COMPILER
# instead
#    cmake -DCMAKE_C_COMPILER=mulle-clang
#
#

#
# https://github.com/Kitware/CMake/blob/master/Modules/CMakeAddNewLanguage.txt
#
# It would be tempting to specify OBJC as the language but:
# 1) cmake doesn't know about it
# 2) one would need to write and maintain a lot of cmake files, that are
#    version specific
# 3) The only immediate payoff is, that one doesn't need to specify
#    -DCMAKE_C_COMPILER or .CC when using mulle-build
#

set( CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_SOURCE_DIR}/mulle-configuration/cmake)
message( STATUS "CMAKE_MODULE_PATH is ${CMAKE_MODULE_PATH}")
message( STATUS "CMAKE_BUILD_TYPE is ${CMAKE_BUILD_TYPE}")

set( MULLE_LANGUAGE "ObjC")

if( "${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
  include( Debug)
else()
  include( Release)
endif()


set( MULLE_OBJC_LIBRARY ON)

include( CMakeDependencies.txt)
include( CMakeSourcesAndHeaders.txt)


set( PUBLIC_HEADERS
${PUBLIC_HEADERS}
"CMakeDependencies.txt"
"src/dependencies.inc"
)

add_library( MulleObjC STATIC
${SOURCES}
${PUBLIC_HEADERS}
${PRIVATE_HEADERS}
CMakeSourcesAndHeaders.txt
)

# doesn't work yet
if( NOT MSVC)
	set( OBJC_LIBRARY_NAME "MulleObjC")

	include( DependenciesIncObjC)
endif()

#
# produce a standalone dll/dylib/so for testing mainly
# though testing could go static at some point in time
# (shared is more frugal though)
#
set( STANDALONE_BASE_NAME "MulleObjC")
set( STANDALONE_NAME "MulleObjCStandalone")

set( STANDALONE_ALL_LOAD_LIBRARIES
    $<TARGET_FILE:${STANDALONE_BASE_NAME}>
    ${OBJC_DEPENDENCY_LIBRARIES}
    ${C_DEPENDENCY_LIBRARIES}
)

include( Standalone)


install( TARGETS MulleObjC MulleObjCStandalone DESTINATION "lib")
install( FILES ${PUBLIC_HEADERS} DESTINATION "include/MulleObjC")
install( FILES ${PRIVATE_HEADERS} DESTINATION "include/MulleObjC/private")

include( MulleTest)

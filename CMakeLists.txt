cmake_minimum_required (VERSION 3.0)

# https://stackoverflow.com/questions/13054451/cmake-problems-specifying-the-compiler-2
# don't do that:
#    set( CMAKE_C_COMPILER
# instead
#    cmake -DCMAKE_C_COMPILER=mulle-clang -DCMAKE_CXX_COMPILER=mulle-clang
#
project( MulleObjC)

set( CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_SOURCE_DIR}/mulle-configuration/cmake)
message( STATUS "CMAKE_MODULE_PATH is ${CMAKE_MODULE_PATH}")
message( STATUS "CMAKE_BUILD_TYPE is ${CMAKE_BUILD_TYPE}")

set( MULLE_LANGUAGE "ObjC")

if( "${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
  include( Debug)
else()
  include( Release)
endif()


include( CMakeSourcesAndHeaders.txt)
include( CMakeDependencies.txt)


add_library( MulleObjC STATIC
${SOURCES}
${PUBLIC_HEADERS}
${PRIVATE_HEADERS}
CMakeDependencies.txt
CMakeSourcesAndHeaders.txt)

target_link_libraries( MulleObjC
#${DEPENDENCY_LIBRARIES}
)


#
# Standalone
#
add_library( MulleObjCStandalone SHARED
src/MulleObjCStandalone.m
${STANDALONE_SOURCES}
${DEF_FILE}
)

add_dependencies( MulleObjCStandalone MulleObjC)

if( MSVC)
   set( DEF_FILE MulleObjCStandalone.def)
   set_source_files_properties( ${DEF_FILE} PROPERTIES HEADER_FILE_ONLY TRUE)
   set( CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS OFF)
   set( CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} /DEF:${DEF_FILE}")
   # /NODEFAULTLIB:MSVCRT")
endif()

if( MSVC)
   add_custom_command( OUTPUT ${DEF_FILE}
                       COMMAND mulle-mingw-dumpdef.bat -o "${DEF_FILE}" --directory "${BUILD_RELATIVE_DEPENDENCIES_DIR}/lib" --prefix "mulle" --prefix Mulle --prefix ns --prefix NS ${DEPENDENCY_LIBRARIES} $<TARGET_FILE:MulleObjC>
                       DEPENDS "${SOURCES}" "${HEADERS}"
                       VERBATIM)
endif()


#
# If you add DEPENDENCY_LIBRARIES to the static, adding them again to
# Standalone confuses cmake it seems. But DEPENDENCY_LIBRARIES are
# implicitly added. UNFORTUNATELY, they are added at the end. So
# BEGIN_ALL_LOAD / END_ALL_LOAD doesn't work.
#
target_link_libraries( MulleObjCStandalone
${BEGIN_ALL_LOAD}
MulleObjC
${C_DEPENDENCY_LIBRARIES}
${END_ALL_LOAD}
${OS_SPECIFIC_LIBRARIES}
)

# runs in build dir
add_custom_command( TARGET MulleObjCStandalone
   POST_BUILD
   COMMAND ${DEPENDENCIES_DIR}/bin/mulle-objc-create-dependencies-inc -v -o ${CMAKE_SOURCE_DIR}/src/dependencies.inc MulleObjC ${OBJC_DEPENDENCY_NAMES}
)

set( PUBLIC_HEADERS
${PUBLIC_HEADERS}
"CMakeDependencies.txt"
"src/dependencies.inc"
)

install( TARGETS MulleObjC MulleObjCStandalone DESTINATION "lib")
install( FILES ${PUBLIC_HEADERS} DESTINATION "include/MulleObjC")
install( FILES ${PRIVATE_HEADERS} DESTINATION "include/MulleObjC/private")

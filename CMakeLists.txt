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
                       COMMAND mulle-mingw-dumpdef.bat -o "${DEF_FILE}"
                               --directory "${BUILD_RELATIVE_DEPENDENCIES_DIR}/lib"
                               --prefix "mulle" --prefix Mulle --prefix ns
                               --prefix NS ${DEPENDENCY_LIBRARIES}
                               $<TARGET_FILE:MulleObjC>
                       DEPENDS "${SOURCES}" "${HEADERS}"
                       VERBATIM)
endif()


#
# If you add DEPENDENCY_LIBRARIES to the static, adding them again to
# Standalone confuses cmake it seems. But DEPENDENCY_LIBRARIES are
# implicitly added. UNFORTUNATELY, they are added at the end. So
# BEGIN_ALL_LOAD / END_ALL_LOAD doesn't work.
#

# prepend force-all for OS X, other use BEGIN_ALL_LOAD

set( TARGET_ALL_LOAD_LIBRARIES
$<TARGET_FILE:MulleObjC>
${C_DEPENDENCY_LIBRARIES}
)

if( FORCE_LOAD)
   set( TMP)
   foreach( library ${TARGET_ALL_LOAD_LIBRARIES})
      list( APPEND TMP "${FORCE_LOAD} ${library}")
   endforeach( library)
   set( TARGET_ALL_LOAD_LIBRARIES ${TMP})
endif()


target_link_libraries( MulleObjCStandalone
${BEGIN_ALL_LOAD}
${TARGET_ALL_LOAD_LIBRARIES}
${END_ALL_LOAD}
${OS_SPECIFIC_LIBRARIES}
$<TARGET_FILE:MulleObjC> # stupid workaround for cmake being confused by ${FORCE_LOAD}
)


# runs in build dir
add_custom_command( TARGET MulleObjCStandalone
   POST_BUILD
   COMMAND ${DEPENDENCIES_DIR}/bin/mulle-objc-create-dependencies-inc -v
           -o ${CMAKE_SOURCE_DIR}/src/dependencies.inc MulleObjC
           ${OBJC_DEPENDENCY_NAMES}
)

set( PUBLIC_HEADERS
${PUBLIC_HEADERS}
"CMakeDependencies.txt"
"src/dependencies.inc"
)

install( TARGETS MulleObjC MulleObjCStandalone DESTINATION "lib")
install( FILES ${PUBLIC_HEADERS} DESTINATION "include/MulleObjC")
install( FILES ${PRIVATE_HEADERS} DESTINATION "include/MulleObjC/private")

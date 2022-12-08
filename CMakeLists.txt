cmake_minimum_required( VERSION 3.18) # 3.15 fails on windows

project( MulleObjC C)


option( MULLE_OBJC_DEBUG_SUPPORT "Provide trace and dump support for release builds" OFF)

### mulle-sde environment

# add cmake module paths to search path
list( INSERT CMAKE_MODULE_PATH 0 "${PROJECT_SOURCE_DIR}/cmake/share")
list( INSERT CMAKE_MODULE_PATH 0 "${PROJECT_SOURCE_DIR}/cmake/reflect")
list( INSERT CMAKE_MODULE_PATH 0 "${PROJECT_SOURCE_DIR}/cmake")

include( Environment)

include( Files)

if( MULLE_OBJC_DEBUG_SUPPORT OR NOT ("${CMAKE_BUILD_TYPE}" STREQUAL "Release"))
   add_definitions( -DMULLE_OBJC_DEBUG_SUPPORT)
endif()

### Library

if( HEADERS_PHASE)
   install( FILES ${INSTALL_PUBLIC_HEADERS}  DESTINATION "include/${PROJECT_NAME}")
   install( FILES ${INSTALL_PRIVATE_HEADERS} DESTINATION "include/${PROJECT_NAME}/private")
   install( FILES ${CMAKE_INCLUDES}          DESTINATION "include/${PROJECT_NAME}/cmake")

   # short cut out
   if( NOT COMPILE_PHASE AND NOT LINK_PHASE)
      return()
   endif()
endif()


if( LINK_PHASE)
   include( Dependencies OPTIONAL)
   if( NOT MULLE_OBJC_DEBUG_SUPPORT AND ("${CMAKE_BUILD_TYPE}" STREQUAL "Release"))
      list( REMOVE_ITEM DEPENDENCY_LIBRARIES "${MULLE_OBJC_DEBUG_LIBRARY}")
   endif()
endif()


unset( STARTUP_LIBRARY_NAME)


include( Library)

# use LIBRARY_COMPILE_TARGET for compiler options
target_compile_definitions( "${LIBRARY_COMPILE_TARGET}" PUBLIC)
target_compile_options( "${LIBRARY_COMPILE_TARGET}" PUBLIC -Wall)
# use LIBRARY_LINK_TARGET for linker options
if( LINK_PHASE)
   target_link_options( "${LIBRARY_LINK_TARGET}" PUBLIC)
endif()

include( InstallLibrary)
include( FinalOutput OPTIONAL)

cmake_minimum_required( VERSION 3.18) # 3.15 fails on windows

project( MulleObjC VERSION 0.24.0 LANGUAGES C)


if( "${CMAKE_BUILD_TYPE}" STREQUAL "Release")
   option( MULLE_OBJC_DEBUG_SUPPORT "Provide trace and dump support for release builds" OFF)
else()
   option( MULLE_OBJC_DEBUG_SUPPORT "Provide trace and dump support for release builds" ON)
endif()

### mulle-sde environment

# add cmake module paths to search path
list( INSERT CMAKE_MODULE_PATH 0 "${CMAKE_CURRENT_SOURCE_DIR}/cmake/share")
list( INSERT CMAKE_MODULE_PATH 0 "${CMAKE_CURRENT_SOURCE_DIR}/cmake/reflect")
list( INSERT CMAKE_MODULE_PATH 0 "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

include( Environment)

include( Files)

if( MULLE_OBJC_DEBUG_SUPPORT)
   add_definitions( -DMULLE_OBJC_DEBUG_SUPPORT)
endif()

### Library

if( HEADERS_PHASE)
   install( FILES ${INSTALL_PUBLIC_HEADERS}  DESTINATION "include/${PROJECT_NAME}")
   install( FILES ${INSTALL_PRIVATE_HEADERS} DESTINATION "include/${PROJECT_NAME}")
   install( FILES ${INSTALL_CMAKE_INCLUDES}          DESTINATION "include/${PROJECT_NAME}/cmake")

   # short cut out
   if( NOT COMPILE_PHASE AND NOT LINK_PHASE)
      return()
   endif()
endif()


if( LINK_PHASE)
   include( Dependencies OPTIONAL)
   if( NOT MULLE_OBJC_DEBUG_SUPPORT)
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

if( LINK_PHASE)
   include( InstallCMakeInclude)
   include( InstallCMakePackage)
endif() 

include( FinalOutput OPTIONAL)

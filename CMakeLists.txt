cmake_minimum_required( VERSION 3.0)

project( MulleObjC C)


### mulle-sde environment

# add cmake module paths to search path
list( INSERT CMAKE_MODULE_PATH 0 "${PROJECT_SOURCE_DIR}/cmake/share")
list( INSERT CMAKE_MODULE_PATH 0 "${PROJECT_SOURCE_DIR}/cmake")

include( Environment)


### Files

include( PreFiles OPTIONAL)

set( MULLEOBJC_LIBRARY ON)

#
# Include all non underscored .cmake files in ./cmake
#
file( GLOB LOCAL_CMAKE_INCLUDES
   "cmake/[A-Za-z0-9]*.cmake"
)

foreach( FILE ${LOCAL_CMAKE_INCLUDES} )
   include( "${FILE}")
endforeach()


include_directories( ${INCLUDE_DIRS})

include( PostFiles OPTIONAL)

### Library

include( PreLibrary OPTIONAL)

add_library( "MulleObjC"
# definitions from cmake/HeadersAndSources.cmake
${SOURCES}
${PUBLIC_HEADERS}
${PRIVATE_HEADERS}
# definitions from cmake/share/Environment.cmake
${CMAKE_EDITABLE_FILES}
)

if( BUILD_SHARED_LIBS)
   target_link_libraries( MulleObjC
# definitions from cmake/share/DependenciesAndLibraries.cmake
${DEPENDENCY_LIBRARIES}
${OS_SPECIFIC_LIBRARIES}
)
endif()

include( PostLibrary OPTIONAL)

option( STANDALONE "Create standalone library for debugging" OFF)

set( INSTALL_LIBRARY_TARGETS
"MulleObjC"
)

if( STANDALONE)
   set( STANDALONE_BASE_NAME "MulleObjC")
   set( STANDALONE_NAME "MulleObjC-standalone")
   set( STANDALONE_DEFINITIONS ${MULLEOBJC_DEFINITIONS})
   set( STANDALONE_DEPENDENCIES
   MulleObjC
   )

   set( STANDALONE_ALL_LOAD_LIBRARIES
   $<TARGET_FILE:MulleObjC>
   ${DEPENDENCY_LIBRARIES}
   ${OPTIONAL_DEPENDENCY_LIBRARIES}
   ${ALL_LOAD_DEPENDENCY_LIBRARIES}
   ${OS_SPECIFIC_LIBRARIES}
   )

   message( STATUS "STANDALONE_ALL_LOAD_LIBRARIES=\"${STANDALONE_ALL_LOAD_LIBRARIES}\"")

   include( Standalone)

   set( INSTALL_LIBRARY_TARGETS
   ${INSTALL_LIBRARY_TARGETS}
   "MulleObjC-standalone"
   )
endif()

### Install

include( PreInstall OPTIONAL)

install( TARGETS ${INSTALL_LIBRARY_TARGETS} DESTINATION "lib")
install( FILES ${PUBLIC_HEADERS}  DESTINATION "include/MulleObjC")
install( FILES ${PRIVATE_HEADERS} DESTINATION "include/MulleObjC/private")

# definitions from cmake/share/Environment.cmake
install( FILES ${CMAKE_INCLUDES}  DESTINATION "include/MulleObjC/cmake")

# definitions from cmake/share/LinkManifest.cmake
install( FILES ${LINK_MANIFEST_FILES}  DESTINATION "include/MulleObjC/link")

include( PostInstall OPTIONAL)

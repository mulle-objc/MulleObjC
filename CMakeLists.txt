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
set( MULLEOBJC_STARTUP_LIBRARY ON)

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

set( PROJECT_FILES
   ${SOURCES}
   ${DEBUG_SOURCES}
   ${PUBLIC_HEADERS}
   ${PRIVATE_HEADERS}
   ${CMAKE_EDITABLE_FILES}
)

include( PostFiles OPTIONAL)

### Library

include( PreLibrary OPTIONAL)

add_library( "MulleObjC"
   ${PROJECT_FILES}
)


set( INSTALL_LIBRARY_TARGETS
   "MulleObjC"
)

##
## Startup is used for executables
##
add_library( MulleObjCStartup STATIC
   ${STARTUP_SOURCES}
)

set( STARTUP_LIBRARY MulleObjCStartup)

set( INSTALL_LIBRARY_TARGETS
   ${INSTALL_LIBRARY_TARGETS}
   MulleObjCStartup
)

include( PostLibrary OPTIONAL)

if( BUILD_SHARED_LIBS)

   include( AllLoad)

   CreateForceAllLoadList( ALL_LOAD_DEPENDENCY_LIBRARIES FORCE_ALL_LOAD_DEPENDENCY_LIBRARIES)

   target_link_libraries( MulleObjC
      ${FORCE_ALL_LOAD_DEPENDENCY_LIBRARIES}
      ${DEPENDENCY_LIBRARIES}
      ${OPTIONAL_DEPENDENCY_LIBRARIES}
      ${OS_SPECIFIC_LIBRARIES}
   )
endif()


### Install

include( PreInstall OPTIONAL)

install( TARGETS ${INSTALL_LIBRARY_TARGETS} DESTINATION "lib")
install( FILES ${PUBLIC_HEADERS}  DESTINATION "include/MulleObjC")
install( FILES ${PRIVATE_HEADERS} DESTINATION "include/MulleObjC/private")

install( FILES ${CMAKE_INCLUDES}  DESTINATION "include/MulleObjC/cmake")

include( PostInstall OPTIONAL)

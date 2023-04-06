### If you want to edit this, copy it from cmake/share to cmake. It will be
### picked up in preference over the one in cmake/share. And it will not get
### clobbered with the next upgrade.

# this needs to run again for each executable so no include check

if( MULLE_TRACE_INCLUDE)
   message( STATUS "# Include \"${CMAKE_CURRENT_LIST_FILE}\"" )
endif()

# up here for orthogonality with C
include( ExecutableAuxObjC OPTIONAL)

include( ExecutableObjC)
include( OptimizedLinkObjC)

### If you want to edit this, copy it from cmake/share to cmake. It will be
### picked up in preference over the one in cmake/share. And it will not get
### clobbered with the next upgrade.

if( MULLE_TRACE_INCLUDE)
   message( STATUS "# Include \"${CMAKE_CURRENT_LIST_FILE}\"" )
endif()

include( CompilerFlagsObjC)

# load in flags defined by other plugins, presumably Objective-C
include( CompilerFlagsAuxObjC OPTIONAL)


# extension : mulle-objc/objc-cmake
# directory : project/all
# template  : .../CompilerFlagsAuxC.cmake
# Suppress this comment with `export MULLE_SDE_GENERATE_FILE_COMMENTS=NO`

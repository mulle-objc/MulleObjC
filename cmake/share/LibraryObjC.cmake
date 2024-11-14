### If you want to edit this, copy it from cmake/share to cmake. It will be
### picked up in preference over the one in cmake/share. And it will not get
### clobbered with the next upgrade.

# can be included multiple times


if( MULLE_TRACE_INCLUDE)
   message( STATUS "# Include \"${CMAKE_CURRENT_LIST_FILE}\"" )
endif()

#
# the idea here is that this propagates up to the main project, if
# this project is added to another with add_subdirectory
#
# In your library's main CMakeLists.txt
if( CMAKE_VERSION VERSION_GREATER_EQUAL "3.24")
   target_link_options( ${LIBRARY_NAME} INTERFACE "$<LINK_LIBRARY:WHOLE_ARCHIVE,${LIBRARY_NAME}>")
endif()

include( LibraryAuxObjC OPTIONAL)

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
if( APPLE)
   target_link_options( ${LIBRARY_NAME} INTERFACE "-force_load")
elseif(WIN32)
   target_link_options( ${LIBRARY_NAME} INTERFACE "-WHOLEARCHIVE:")
else()
   target_link_options( ${LIBRARY_NAME} INTERFACE
        "-Wl,--whole-archive"
        "-Wl,--no-as-needed"
        "$<LINK_ONLY:${CMAKE_CURRENT_BINARY_DIR}/lib${LIBRARY_NAME}.a>"
        "-Wl,--as-needed"
        "-Wl,--no-whole-archive"
   )
endif()

include( LibraryAuxObjC OPTIONAL)

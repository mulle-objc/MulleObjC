if( MULLE_TRACE_INCLUDE)
   message( STATUS "# Include \"${CMAKE_CURRENT_LIST_FILE}\"" )
endif()

#
# only for mulle-clang
#
if( APPLE AND MULLE_OBJC)
   target_link_options( "${STANDALONE_LIBRARY_NAME}"
      PUBLIC
         "SHELL:LINKER:-undefined,dynamic_lookup"
   )
endif()

include( PostLibraryAuxObjC OPTIONAL)

### If you want to edit this, copy it from cmake/share to cmake. It will be
### picked up in preference over the one in cmake/share. And it will not get
### clobbered with the next upgrade.

if( MULLE_TRACE_INCLUDE)
   message( STATUS "# Include \"${CMAKE_CURRENT_LIST_FILE}\"" )
endif()

#
# only for mulle-clang
#
if( APPLE AND MULLE_OBJC)
   if( LINK_PHASE)
      target_link_options( "${STANDALONE_LIBRARY_NAME}"
         PUBLIC
            "SHELL:LINKER:-undefined,dynamic_lookup"
      )
   endif()
endif()

include( PostStandaloneAuxObjC OPTIONAL)

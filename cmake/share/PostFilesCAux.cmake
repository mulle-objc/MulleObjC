if( NOT __POST_FILES_C_AUX_CMAKE__)
   set( __POST_FILES_C_AUX_CMAKE__ ON)

   if( MULLE_TRACE_INCLUDE)
      message( STATUS "# Include \"${CMAKE_CURRENT_LIST_FILE}\"" )
   endif()

   include( AAMSupportObjC)

   include( PostFilesObjCAux OPTIONAL)

endif()

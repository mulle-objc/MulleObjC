if( NOT __PRE_LIBRARY_C_AUX_CMAKE__)
   set( __PRE_LIBRARY_C_AUX_CMAKE__ ON)

   if( MULLE_TRACE_INCLUDE)
      message( STATUS "# Include \"${CMAKE_CURRENT_LIST_FILE}\"" )
   endif()

   include( DefineLoaderIncObjC)

   include( PreLibraryObjCAux.cmake OPTIONAL)

endif()

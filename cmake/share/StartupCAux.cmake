if( NOT __STARTUP_C_AUX_CMAKE__)
   set( __STARTUP_C_AUX_CMAKE__ ON)

   if( MULLE_TRACE_INCLUDE)
      message( STATUS "# Include \"${CMAKE_CURRENT_LIST_FILE}\"" )
   endif()

   include( StartupObjC)

   include( StartupObjCAux OPTIONAL)
endif()

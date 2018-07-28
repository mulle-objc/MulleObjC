if( NOT __EXECUTABLE_C_AUX_CMAKE__)
   set( __EXECUTABLE_C_AUX_CMAKE__ ON)

   if( MULLE_TRACE_INCLUDE)
      message( STATUS "# Include \"${CMAKE_CURRENT_LIST_FILE}\"" )
   endif()

   include( ExecutableObjC)
   include( OptimizedLinkObjC)

   include( ExecutableObjCAux OPTIONAL)

endif()

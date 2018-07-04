if( NOT __POST_EXECUTABLE_C_AUX_CMAKE__)
   set( __POST_EXECUTABLE_C_AUX_CMAKE__ ON)

   if( MULLE_TRACE_INCLUDE)
      message( STATUS "# Include \"${CMAKE_CURRENT_LIST_FILE}\"" )
   endif()

   include( ExecutableObjC)
   include( OptimizedLinkObjC)

   include( PostExecutableObjCAux OPTIONAL)

endif()

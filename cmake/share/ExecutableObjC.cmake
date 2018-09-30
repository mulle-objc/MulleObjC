if( NOT __EXECUTABLE_OBJC_CMAKE__)
   set( __EXECUTABLE_OBJC_CMAKE__ ON)

   if( MULLE_TRACE_INCLUDE)
      message( STATUS "# Include \"${CMAKE_CURRENT_LIST_FILE}\"" )
   endif()

   if( NOT EXECUTABLE_NAME)
      set( EXECUTABLE_NAME "${PROJECT_NAME}")
   endif()

   #
   # need this for .aam projects
   #
   set_target_properties( "${EXECUTABLE_NAME}"
      PROPERTIES LINKER_LANGUAGE C
   )

   include( ExecutableAuxObjC OPTIONAL)

endif()

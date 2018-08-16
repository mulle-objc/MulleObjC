if( NOT __EXECUTABLE_OBJC_CMAKE__)
   set( __EXECUTABLE_OBJC_CMAKE__ ON)

   if( MULLE_TRACE_INCLUDE)
      message( STATUS "# Include \"${CMAKE_CURRENT_LIST_FILE}\"" )
   endif()

   if( NOT EXECUTABLE_NAME)
      set( EXECUTABLE_NAME "MulleObjC")
   endif()

   option( OPTION_LINK_STARTUP_LIBRARY "Add a startup library to ObjC executable" ON)

   #
   # This library contains ___get_or_create_mulle_objc_universe and
   # the startup code to create the universe
   #
   if( OPTION_LINK_STARTUP_LIBRARY)
      if( NOT STARTUP_LIBRARY)
         if( NOT STARTUP_LIBRARY_NAME)
            message( FATAL "STARTUP_LIBRARY_NAME is undefined (use Foundation if unsure)")
         endif()

         find_library( STARTUP_LIBRARY NAMES ${CMAKE_STATIC_LIBRARY_PREFIX}${STARTUP_LIBRARY_NAME}${CMAKE_STATIC_LIBRARY_SUFFIX}
                                             ${STARTUP_LIBRARY_NAME}
         )
      endif()

      message( STATUS "STARTUP_LIBRARY is ${STARTUP_LIBRARY}")

      set( DEPENDENCY_LIBRARIES
        ${DEPENDENCY_LIBRARIES}
        ${STARTUP_LIBRARY}
      )
   endif()

   #
   # need this for .aam projects
   #
   set_target_properties( "${EXECUTABLE_NAME}"
      PROPERTIES LINKER_LANGUAGE C
   )

   include( ExecutableObjCAux OPTIONAL)

endif()

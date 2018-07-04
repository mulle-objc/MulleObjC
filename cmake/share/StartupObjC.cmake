if( NOT __STARTUP_OBJC_CMAKE__)
   set( __STARTUP_OBJC_CMAKE__ ON)

   if( MULLE_TRACE_INCLUDE)
      message( STATUS "# Include \"${CMAKE_CURRENT_LIST_FILE}\"" )
   endif()

   if( NOT STARTUP_SOURCES)
      if( NOT STARTUP_LIBRARY)
         if( NOT MULLE_OBJC_STARTUP_LIBRARY)
            find_library( MULLE_OBJC_STARTUP_LIBRARY NAMES ${CMAKE_STATIC_LIBRARY_PREFIX}MulleObjC-startup${CMAKE_STATIC_LIBRARY_SUFFIX} MulleObjC-startup)
            message( STATUS "MULLE_OBJC_STARTUP_LIBRARY is ${MULLE_OBJC_STARTUP_LIBRARY}")
         endif()

      # for Standalone
         set( STARTUP_LIBRARY ${MULLE_OBJC_STARTUP_LIBRARY})
         message( STATUS "STARTUP_LIBRARY is ${STARTUP_LIBRARY}")
      endif()
   endif()

   include( StartupObjCAux OPTIONAL)
endif()

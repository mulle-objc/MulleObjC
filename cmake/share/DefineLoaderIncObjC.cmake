if( NOT __DEFINE_LOADER_INC_OBJC_CMAKE__)
   set( __DEFINE_LOADER_INC_OBJC_CMAKE__ ON)

   if( MULLE_TRACE_INCLUDE)
      message( STATUS "# Include \"${CMAKE_CURRENT_LIST_FILE}\"" )
   endif()

   #
   # Create src/objc-loader.inc for Objective-C projects. This contains a
   # list of all the classes and categories, contained in a library.
   #

   option( CREATE_OBJC_LOADER_INC "Create objc-loader.inc for Objective-C libraries" ON)

   if( CREATE_OBJC_LOADER_INC)
      if( NOT OBJC_LOADER_INC)
         set( OBJC_LOADER_INC "${CMAKE_SOURCE_DIR}/src/objc-loader.inc")
      endif()

      set_source_files_properties( "${OBJC_LOADER_INC}"
         PROPERTIES GENERATED TRUE
      )

      # runs in build dir
      if( NOT MULLE_OBJC_LOADER_TOOL)
        if( MSVC)
           find_program( MULLE_OBJC_LOADER_TOOL mulle-objc-loader-tool.bat "${DEPENDENCY_DIR}/bin")
         else()
           find_program( MULLE_OBJC_LOADER_TOOL mulle-objc-loader-tool "${DEPENDENCY_DIR}/bin")
         endif()
      endif()
      if( NOT MULLE_OBJC_LOADER_TOOL)
         message( FATAL_ERROR "Executable \"mulle-objc-loader-tool\" not found")
      endif()

      set( STAGE2_HEADERS
        ${STAGE2_HEADERS}
        ${OBJC_LOADER_INC}
      )
      message( STATUS "OBJC_LOADER_INC is ${OBJC_LOADER_INC}")
   endif()

   include( DefineLoaderIncObjCAux OPTIONAL)

endif()

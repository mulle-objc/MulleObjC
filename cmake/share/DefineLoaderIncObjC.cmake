if( NOT __DEFINE_LOADER_INC_OBJC_CMAKE__)
   set( __DEFINE_LOADER_INC_OBJC_CMAKE__ ON)
   # can be included multiple times

   if( MULLE_TRACE_INCLUDE)
      message( STATUS "# Include \"${CMAKE_CURRENT_LIST_FILE}\"" )
   endif()

   # check if available first

   if( NOT MULLE_OBJC_LOADER_TOOL)
      if( MSVC)
         find_program( MULLE_OBJC_LOADER_TOOL mulle-objc-loader-tool.bat
                           PATHS "${DEPENDENCY_DIR}/${CMAKE_BUILD_TYPE}/bin"
                                 "${DEPENDENCY_DIR}/bin"
                                 "${DEPENDENCY_DIR}/${FALLBACK_BUILD_TYPE}/bin"
         )
      else()
         find_program( MULLE_OBJC_LOADER_TOOL mulle-objc-loader-tool
                           PATHS "${DEPENDENCY_DIR}/${CMAKE_BUILD_TYPE}/bin"
                                 "${DEPENDENCY_DIR}/bin"
                                 "${DEPENDENCY_DIR}/${FALLBACK_BUILD_TYPE}/bin"
         )
      endif()
      message( STATUS "MULLE_OBJC_LOADER_TOOL is ${MULLE_OBJC_LOADER_TOOL}")
   endif()

   if( NOT DEFINED CREATE_OBJC_LOADER_INC)
      if( MULLE_OBJC_LOADER_TOOL)
         option( CREATE_OBJC_LOADER_INC "Create objc-loader.inc for Objective-C libraries" ON)
      else()
         option( CREATE_OBJC_LOADER_INC "Create objc-loader.inc for Objective-C libraries" OFF)
      endif()
   endif()

   include( DefineLoaderIncAuxObjC OPTIONAL)

endif()

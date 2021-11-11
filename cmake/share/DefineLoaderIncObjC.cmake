### If you want to edit this, copy it from cmake/share to cmake. It will be
### picked up in preference over the one in cmake/share. And it will not get
### clobbered with the next upgrade.

if( NOT __DEFINE_LOADER_INC_OBJC_CMAKE__)
   set( __DEFINE_LOADER_INC_OBJC_CMAKE__ ON)
   # can be included multiple times

   if( MULLE_TRACE_INCLUDE)
      message( STATUS "# Include \"${CMAKE_CURRENT_LIST_FILE}\"" )
   endif()

   # Check if mulle-objc-loader-tool is available first. It might not be,
   # especially if we are in a static only landscape.
   #
   # If it's not there, it's not really a problem. People may prefer
   # to "handcode" it.
   #
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

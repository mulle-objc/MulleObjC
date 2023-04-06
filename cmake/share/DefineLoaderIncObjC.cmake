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
         if( MINGW)
            find_program( MULLE_OBJC_LOADER_TOOL mulle-objc-loader-tool-mingw.bat
                          PATHS ${ADDITIONAL_BIN_PATH})
         else()
            find_program( MULLE_OBJC_LOADER_TOOL mulle-objc-loader-tool.bat
                          PATHS ${ADDITIONAL_BIN_PATH})
         endif()
      else()
         find_program( MULLE_OBJC_LOADER_TOOL mulle-objc-loader-tool
                       PATHS ${ADDITIONAL_BIN_PATH})
      endif()
      message( STATUS "MULLE_OBJC_LOADER_TOOL is ${MULLE_OBJC_LOADER_TOOL}")
   endif()

   # currently MSVC/WSL is considered busted by default
   # but MINGW could (?) work
   # MUSL_STATIC_ONLY and COSMOPOLITAN don't do shared library stuff
   #
   if( NOT DEFINED CREATE_OBJC_LOADER_INC)
      if( MULLE_OBJC_LOADER_TOOL AND (NOT (MSVC OR MUSL_STATIC_ONLY OR COSMOPOLITAN)))
         option( CREATE_OBJC_LOADER_INC "Create objc-loader.inc for Objective-C libraries" ON)
      else()
         option( CREATE_OBJC_LOADER_INC "Create objc-loader.inc for Objective-C libraries" OFF)
      endif()
   endif()

   include( DefineLoaderIncAuxObjC OPTIONAL)

endif()

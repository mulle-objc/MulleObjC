### If you want to edit this, copy it from cmake/share to cmake. It will be
### picked up in preference over the one in cmake/share. And it will not get
### clobbered with the next upgrade.

if( NOT __COMPILER_FLAGS_OBJC_CMAKE__)
   set( __COMPILER_FLAGS_OBJC_CMAKE__ ON)

   if( MULLE_TRACE_INCLUDE)
      message( STATUS "# Include \"${CMAKE_CURRENT_LIST_FILE}\"" )
   endif()

   #
   # only useful in mulle-objc
   #
   option( OBJC_TAO_DEBUG_DISABLED "Disable Objective-C TAO for debug builds" OFF)

   set( CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${OTHER_OBJC_FLAGS} ${UNWANTED_OBJC_WARNINGS}")
   set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OTHER_OBJC_FLAGS} ${UNWANTED_OBJC_WARNINGS}")

   string( TOUPPER "${CMAKE_BUILD_TYPE}" TMP_CONFIGURATION_NAME)
   if( TMP_CONFIGURATION_NAME STREQUAL "DEBUG")
      if( MULLE_OBJC AND NOT OBJC_TAO_DEBUG_DISABLED)
         message( STATUS "Objective-C TAO enabled")
         add_definitions( "-fobjc-tao")
      endif()
   else()
      add_definitions( "-DNS_BLOCK_ASSERTIONS" )
   endif()
endif()

if( NOT __EXECUTABLE_OBJC_CMAKE__)
   set( __EXECUTABLE_OBJC_CMAKE__ ON)

   if( MULLE_TRACE_INCLUDE)
      message( STATUS "# Include \"${CMAKE_CURRENT_LIST_FILE}\"" )
   endif()

   set( EXECUTABLE_OBJC_VERSION 4)

   #
   # This library contains ___get_or_create_mulle_objc_universe and
   # the startup code to create the universe
   #
   if( NOT MULLE_OBJC_STARTUP_LIBRARY)
      find_library( MULLE_OBJC_STARTUP_LIBRARY NAMES MulleObjC-startup)
   endif()

   message( STATUS "MULLE_OBJC_STARTUP_LIBRARY is ${MULLE_OBJC_STARTUP_LIBRARY}")

   set( EXECUTABLE_LIBRARY_LIST
      ${EXECUTABLE_LIBRARY_LIST}
      ${MULLE_OBJC_STARTUP_LIBRARY}
   )

   #
   # need this for .aam projects
   #
   set_target_properties( MulleObjC
      PROPERTIES LINKER_LANGUAGE C
   )

   #
   # For noobs add a line so they find the output
   #
   add_custom_command(
     TARGET MulleObjC
     POST_BUILD
     COMMAND echo "Your executable \"$<TARGET_FILE:MulleObjC>\" is now ready to run"
     VERBATIM
   )

   include( ExecutableObjCAux OPTIONAL)

endif()

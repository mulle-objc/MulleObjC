if( NOT __DEPENDENCIES_INC_OBJC_CMAKE__)
   set( __DEPENDENCIES_INC_OBJC_CMAKE__ ON)

   if( MULLE_TRACE_INCLUDE)
      message( STATUS "# Include \"${CMAKE_CURRENT_LIST_FILE}\"" )
   endif()

   option( OBJC_DEPENDENCY_INC "Create coveraage-optimized ObjC libraries" ON)

   if( OBJC_DEPENDENCY_INC)
      #
      # Input:
      #
      # MULLE_LANGUAGE
      # OBJC_LIBRARY_NAME
      # OBJC_DEPENDENCY_NAMES
      # OBJC_DEPENDENCY_LIBRARIES
      #
      #
      # Create src/dependencies.inc for Objective-C projects. This contains a
      # list of all the classes and categories, contained in a project.
      #
      if( NOT DEPENDENCIES_INC)
         set( DEPENDENCIES_INC "${CMAKE_SOURCE_DIR}/src/dependencies.inc")
      endif()

      message( STATUS "DEPENDENCIES_INC is ${DEPENDENCIES_INC}")
      message( STATUS "OBJC_LIBRARY_NAME is ${OBJC_LIBRARY_NAME}")
      message( STATUS "OBJC_DEPENDENCY_NAMES is ${OBJC_DEPENDENCY_NAMES}")

      # runs in build dir
      if( NOT CREATE_INC)
        if( MSVC)
           find_program( CREATE_INC mulle-objc-create-dependencies-inc.bat "${DEPENDENCY_DIR}/bin")
         else()
           find_program( CREATE_INC mulle-objc-create-dependencies-inc "${DEPENDENCY_DIR}/bin")
         endif()
      endif()

      if( NOT CREATE_INC)
         message( ERROR "Executable \"mulle-objc-create-dependencies-inc\" not found")
      endif()

      add_custom_command( TARGET MulleObjC
        POST_BUILD
        COMMAND ${CREATE_INC}
                   -v
                   -c "${CMAKE_BUILD_TYPE}"
                   -o "${DEPENDENCIES_INC}"
                   MulleObjC
                   ${OBJC_DEPENDENCY_NAMES}
        DEPENDS "$<TARGET_FILE:MulleObjC>"
                "${ALL_LOAD_DEPENDENCY_LIBRARIES}"
                "${DEPENDENCY_LIBRARIES}"
                "${OPTIONAL_DEPENDENCY_LIBRARIES}"
        VERBATIM
      )
   endif()
endif()

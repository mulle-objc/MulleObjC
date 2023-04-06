### If you want to edit this, copy it from cmake/share to cmake. It will be
### picked up in preference over the one in cmake/share. And it will not get
### clobbered with the next upgrade.

if( NOT __OPTIMIZED_LINK_OBJC_CMAKE__)
   set( __OPTIMIZED_LINK_OBJC_CMAKE__ ON)

   if( MULLE_TRACE_INCLUDE)
      message( STATUS "# Include \"${CMAKE_CURRENT_LIST_FILE}\"" )
   endif()

   #
   # can only be used in one-library/project cmake project
   #
   if( NOT DEFINED OBJC_COVERAGE_OPTIMIZED_LIBS)
      option( OBJC_COVERAGE_OPTIMIZED_LIBS "Create coverage-optimized ObjC libraries" OFF)
   endif()

   if( OBJC_COVERAGE_OPTIMIZED_LIBS)

      if( NOT LIBRARY_NAME)
         set( LIBRARY_NAME "${PROJECT_NAME}")
      endif()

      #
      # Optimize static linking of mulle-objc executables with coverage
      # information.
      #
      # Input:
      #    EXECUTABLE_NAME
      #    OBJC_DEPENDENCY_LIBRARIES
      #
      # Output:
      #    ALL_LOAD_LIBRARY     # force link this
      #    NORMAL_LOAD_LIBRARY  # regular link this
      #
      if( NOT COVERAGE_DIR)
        set( COVERAGE_DIR "${PROJECT_SOURCE_DIR}/coverage")
      endif()
      if( NOT OPTIMIZE_DIR)
        set( OPTIMIZE_DIR "${PROJECT_BINARY_DIR}/mulle-objc-optimize/optimize.d")
      endif()
      if( NOT OPTIMIZE_INFO_DIR)
        set( OPTIMIZE_INFO_DIR "${PROJECT_SOURCE_DIR}/optimize")
      endif()
      if( NOT UNARCHIVE_DIR)
         set( UNARCHIVE_DIR "${PROJECT_BINARY_DIR}/mulle-objc-optimize/unarchive.d")
      endif()

      if( NOT EXISTS "${COVERAGE_DIR}/method-coverage.csv")
         message( FATAL_ERROR "Coverage file \"${COVERAGE_DIR}/method-coverage.csv\" is missing")
      endif()
      if( NOT EXISTS "${COVERAGE_DIR}/class-coverage.csv")
         message( FATAL_ERROR "Coverage file \"${COVERAGE_DIR}/class-coverage.csv\" is missing")
      endif()


      set( ALL_LOAD_NAME "${CMAKE_STATIC_LIBRARY_PREFIX}_${LIBRARY_NAME}_ObjC${CMAKE_STATIC_LIBRARY_SUFFIX}")
      set( OPTIMIZABLE_LOAD_NAME  "${CMAKE_STATIC_LIBRARY_PREFIX}_${LIBRARY_NAME}_c${CMAKE_STATIC_LIBRARY_SUFFIX}")

      message( STATUS "OPTIMIZABLE_LOAD_NAME is ${OPTIMIZABLE_LOAD_NAME}")
      message( STATUS "ALL_LOAD_NAME is ${ALL_LOAD_NAME}")
      message( STATUS "COVERAGE_DIR is ${COVERAGE_DIR}")
      message( STATUS "OPTIMIZE_DIR is ${OPTIMIZE_DIR}")
      message( STATUS "OPTIMIZE_INFO_DIR is ${OPTIMIZE_INFO_DIR}")
      message( STATUS "UNARCHIVE_DIR is ${UNARCHIVE_DIR}")
      message( STATUS "DEPENDENCY_DIR is ${MULLE_SDK_DEPENDENCY_DIR}")
      message( STATUS "PROJECT_BINARY_DIR is ${PROJECT_BINARY_DIR}")

      set( CUSTOM_OUTPUT
         "${PROJECT_BINARY_DIR}/${OPTIMIZABLE_LOAD_NAME}"
         "${PROJECT_BINARY_DIR}/${ALL_LOAD_NAME}"
      )

      if( MSVC)
         find_program( UNARCHIVE mulle-objc-unarchive.bat
                           PATHS ${ADDITIONAL_BIN_PATH})
         find_program( OPTIMIZE mulle-objc-optimize.bat
                           PATHS ${ADDITIONAL_BIN_PATH})
      else()
         find_program( UNARCHIVE mulle-objc-unarchive
                           PATHS ${ADDITIONAL_BIN_PATH})
         find_program( OPTIMIZE mulle-objc-optimize
                           PATHS ${ADDITIONAL_BIN_PATH})
      endif()


      add_custom_command( OUTPUT ${CUSTOM_OUTPUT}
       COMMAND ${UNARCHIVE} ${MULLE_TECHNICAL_FLAGS}
                            --unarchive-dir "${UNARCHIVE_DIR}"
                            --unarchive-info-dir "${OPTIMIZE_INFO_DIR}"
                            --just-unpack
                            ${ALL_LOAD_DEPENDENCY_LIBRARIES}
       COMMAND ${OPTIMIZE} ${MULLE_TECHNICAL_FLAGS}
                           --c-name "${OPTIMIZABLE_LOAD_NAME}"
                           --objc-name "${ALL_LOAD_NAME}"
                           --coverage-dir "${COVERAGE_DIR}"
                           --dependency-dir "${MULLE_SDK_DEPENDENCY_DIR}"
                           --optimize-info-dir "${OPTIMIZE_INFO_DIR}"
                           --optimize-dir "${OPTIMIZE_DIR}"
                           --prefix "${PROJECT_BINARY_DIR}"
                           --unarchive-dir "${UNARCHIVE_DIR}"
                           ${ALL_LOAD_DEPENDENCY_LIBRARIES}
          DEPENDS ${ALL_LOAD_DEPENDENCY_LIBRARIES}
          COMMENT "Create optimizable Objective-C libraries"
      )


      add_custom_target( "_${LIBRARY_NAME}_optimized_libraries"
         DEPENDS ${CUSTOM_OUTPUT}
      )

      # replace ALL_LOAD_DEPENDENCY_LIBRARIES with the non-optimzable stuff
      set( ALL_LOAD_DEPENDENCY_LIBRARIES
         "${PROJECT_BINARY_DIR}/${ALL_LOAD_NAME}"
      )

      #
      # move the rest which are optimized into regular DEPENDENCY_LIBRARIES
      # to pick up regular C symbols
      #
      set( DEPENDENCY_LIBRARIES
         "${PROJECT_BINARY_DIR}/${OPTIMIZABLE_LOAD_NAME}"
         ${DEPENDENCY_LIBRARIES}
         "${PROJECT_BINARY_DIR}/${OPTIMIZABLE_LOAD_NAME}"
      )

      add_dependencies( ${LIBRARY_NAME} "_${LIBRARY_NAME}_optimized_libraries")
   endif()

   include( OptimizedLinkAuxObjC OPTIONAL)

endif()

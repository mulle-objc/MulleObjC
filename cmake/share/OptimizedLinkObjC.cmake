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
        set( OPTIMIZE_DIR "${PROJECT_BINARY_DIR}")
      endif()

      if( NOT EXISTS "${COVERAGE_DIR}/method-coverage.csv")
         message( FATAL_ERROR "Coverage file ${COVERAGE_DIR}/method-coverage.csv is missing")
      endif()
      if( NOT EXISTS "${COVERAGE_DIR}/class-coverage.csv")
         message( FATAL_ERROR "Coverage file ${COVERAGE_DIR}/class-coverage.csv is missing")
      endif()


      set( ALL_LOAD_NAME "${CMAKE_STATIC_LIBRARY_PREFIX}_${LIBRARY_NAME}_ObjC${CMAKE_STATIC_LIBRARY_SUFFIX}")
      set( OPTIMIZABLE_LOAD_NAME  "${CMAKE_STATIC_LIBRARY_PREFIX}_${LIBRARY_NAME}_c${CMAKE_STATIC_LIBRARY_SUFFIX}")

      message( STATUS "OPTIMIZABLE_LOAD_NAME is ${OPTIMIZABLE_LOAD_NAME}")
      message( STATUS "ALL_LOAD_NAME is ${ALL_LOAD_NAME}")
      message( STATUS "COVERAGE_DIR is ${COVERAGE_DIR}")
      message( STATUS "OPTIMIZE_DIR is ${OPTIMIZE_DIR}")

      set( CUSTOM_OUTPUT
         ${OPTIMIZABLE_LOAD_NAME}
         ${ALL_LOAD_NAME}
      )

      if( MSVC)
         find_program( UNARCHIVE mulle-objc-unarchive.bat
                           PATHS "${DEPENDENCY_DIR}/${CMAKE_BUILD_TYPE}/bin"
                                 "${DEPENDENCY_DIR}/bin"
                                 "${DEPENDENCY_DIR}/${FALLBACK_BUILD_TYPE}/bin")
         find_program( OPTIMIZE mulle-objc-optimize.bat
                           PATHS "${DEPENDENCY_DIR}/${CMAKE_BUILD_TYPE}/bin"
                                 "${DEPENDENCY_DIR}/bin"
                                 "${DEPENDENCY_DIR}/${FALLBACK_BUILD_TYPE}/bin")
      else()
         find_program( UNARCHIVE mulle-objc-unarchive
                           PATHS "${DEPENDENCY_DIR}/${CMAKE_BUILD_TYPE}/bin"
                                 "${DEPENDENCY_DIR}/bin"
                                 "${DEPENDENCY_DIR}/${FALLBACK_BUILD_TYPE}/bin")
         find_program( OPTIMIZE mulle-objc-optimize
                           PATHS "${DEPENDENCY_DIR}/${CMAKE_BUILD_TYPE}/bin"
                                 "${DEPENDENCY_DIR}/bin"
                                 "${DEPENDENCY_DIR}/${FALLBACK_BUILD_TYPE}/bin")
      endif()


      add_custom_command( OUTPUT ${CUSTOM_OUTPUT}
       COMMAND chmod -R +w ${DEPENDENCY_DIR}
       COMMAND ${UNARCHIVE} --unarchive-dir ${DEPENDENCY_DIR}/unarchive
                            ${ALL_LOAD_DEPENDENCY_LIBRARIES}
       COMMAND chmod -R -w ${DEPENDENCY_DIR}
       COMMAND ${OPTIMIZE} --c-name ${OPTIMIZABLE_LOAD_NAME}
                           --objc-name ${ALL_LOAD_NAME}
                           --unarchive-dir ${DEPENDENCY_DIR}/unarchive
                           --dependency-dir ${DEPENDENCY_DIR}
                           --optimize-dir ${OPTIMIZE_DIR}
                           --coverage-dir ${COVERAGE_DIR}
                           ${ALL_LOAD_DEPENDENCY_LIBRARIES}
       DEPENDS ${ALL_LOAD_DEPENDENCY_LIBRARIES}
       COMMENT "Create optimizable Objective-C libraries"
      )


      add_custom_target( "_${LIBRARY_NAME}_optimized_libraries"
         DEPENDS ${CUSTOM_OUTPUT}
      )

      # replace ALL_LOAD_DEPENDENCY_LIBRARIES with the non-optimzable stuff
      set( ALL_LOAD_DEPENDENCY_LIBRARIES
         ${OPTIMIZE_DIR}/${ALL_LOAD_NAME}
      )

      #
      # move the rest which are optimized into regular DEPENDENCY_LIBRARIES
      # to pick up regular C symbols
      #
      set( DEPENDENCY_LIBRARIES
         ${DEPENDENCY_LIBRARIES}
         ${OPTIMIZE_DIR}/${OPTIMIZABLE_LOAD_NAME}
      )

      add_dependencies( ${LIBRARY_NAME} "_${LIBRARY_NAME}_optimized_libraries")
   endif()

   include( OptimizedLinkAuxObjC OPTIONAL)

endif()

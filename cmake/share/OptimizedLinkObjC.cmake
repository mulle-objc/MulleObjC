#
# Optimize static linking of mulle-objc executables with coverage
# information.
#
# Input:
#    EXECUTABLE_NAME
#    OBJC_DEPENDENCY_LIBRARIES
#
# Optional:
#    OBJC_OPTIMIZABLE_LIBRARIES
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


if( NOT OBJC_OPTIMIZABLE_LIBRARIES)
   set( OBJC_OPTIMIZABLE_LIBRARIES ${OBJC_DEPENDENCY_LIBRARIES})
endif()

set( ALL_LOAD_NAME "${CMAKE_STATIC_LIBRARY_PREFIX}_${EXECUTABLE_NAME}_ObjC${CMAKE_STATIC_LIBRARY_SUFFIX}")
set( OPTIMIZABLE_LOAD_NAME  "${CMAKE_STATIC_LIBRARY_PREFIX}_${EXECUTABLE_NAME}_c${CMAKE_STATIC_LIBRARY_SUFFIX}")

message( STATUS "OPTIMIZABLE_LOAD_NAME is ${OPTIMIZABLE_LOAD_NAME}")
message( STATUS "ALL_LOAD_NAME is ${ALL_LOAD_NAME}")
message( STATUS "DEPENDENCIES_DIR is ${DEPENDENCIES_DIR}")
message( STATUS "COVERAGE_DIR is ${COVERAGE_DIR}")
message( STATUS "OPTIMIZE_DIR is ${OPTIMIZE_DIR}")

set( CUSTOM_OUTPUT
${OPTIMIZABLE_LOAD_NAME}
${ALL_LOAD_NAME}
)

if( MSVC)
   find_program( UNARCHIVE mulle-objc-unarchive.bat "${DEPENDENCIES_DIR}/bin")
   find_program( OPTIMIZE mulle-objc-optimize.bat "${DEPENDENCIES_DIR}/bin")
else()
   find_program( UNARCHIVE mulle-objc-unarchive "${DEPENDENCIES_DIR}/bin")
   find_program( OPTIMIZE mulle-objc-optimize "${DEPENDENCIES_DIR}/bin")
endif()


add_custom_command( OUTPUT ${CUSTOM_OUTPUT}
  COMMAND chmod -R +w ${DEPENDENCIES_DIR}
  COMMAND ${UNARCHIVE} --unarchive-dir ${DEPENDENCIES_DIR}/unarchive
                       ${OBJC_OPTIMIZABLE_LIBRARIES}
  COMMAND chmod -R -w ${DEPENDENCIES_DIR}
  COMMAND ${OPTIMIZE} --c-name ${OPTIMIZABLE_LOAD_NAME}
                      --objc-name ${ALL_LOAD_NAME}
                      --unarchive-dir ${DEPENDENCIES_DIR}/unarchive
                      --dependencies-dir ${DEPENDENCIES_DIR}
                      --optimize-dir ${OPTIMIZE_DIR}
                      --coverage-dir ${COVERAGE_DIR}
                      ${OBJC_OPTIMIZABLE_LIBRARIES}
  DEPENDS ${OBJC_OPTIMIZABLE_LIBRARIES}
  COMMENT "Create optimizable Objective-C libraries"
)


add_custom_target( "_${EXECUTABLE_NAME}_optimized_libraries"
DEPENDS ${CUSTOM_OUTPUT}
)

set( ALL_LOAD_LIBRARY
${OPTIMIZE_DIR}/${ALL_LOAD_NAME}
)

set( NORMAL_LOAD_LIBRARY
${OPTIMIZE_DIR}/${OPTIMIZABLE_LOAD_NAME}
)

add_dependencies( "${EXECUTABLE_NAME}" "_${EXECUTABLE_NAME}_optimized_libraries")

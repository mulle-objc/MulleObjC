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
      find_program( CREATE_INC mulle-objc-create-dependencies-inc.bat ${DEPENDENCIES_DIR}/bin)
    else()
      find_program( CREATE_INC mulle-objc-create-dependencies-inc ${DEPENDENCIES_DIR}/bin)
    endif()
endif()

add_custom_command( TARGET ${OBJC_LIBRARY_NAME}
   POST_BUILD
   COMMAND ${CREATE_INC}
              -v
              -c "${CMAKE_BUILD_TYPE}"
              -o "${DEPENDENCIES_INC}"
              ${OBJC_LIBRARY_NAME}
              ${OBJC_DEPENDENCY_NAMES}
   DEPENDS "$<TARGET_FILE:${OBJC_LIBRARY_NAME}>"
           "${OBJC_DEPENDENCY_LIBRARIES}"
   VERBATIM
)

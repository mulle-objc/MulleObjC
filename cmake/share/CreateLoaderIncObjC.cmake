### If you want to edit this, copy it from cmake/share to cmake. It will be
### picked up in preference over the one in cmake/share. And it will not get
### clobbered with the next upgrade.

# can be included multiple times
# define OBJC_LOADER_INC
#        CREATE_OBJC_LOADER_INC
#        LIBRARY_NAME for multiple libraries
#

if( MULLE_TRACE_INCLUDE)
   message( STATUS "# Include \"${CMAKE_CURRENT_LIST_FILE}\"" )
endif()

# this is the second part, the option is in DefineLoaderIncObjC.cmake

if( CREATE_OBJC_LOADER_INC)
   if( NOT LIBRARY_NAME)
      set( LIBRARY_NAME "${PROJECT_NAME}")
   endif()

   #
   # Create src/objc-loader.inc for Objective-C projects. This contains a
   # list of all the classes and categories, contained in a library.
   #
   # runs in build dir
   if( NOT MULLE_OBJC_LOADER_TOOL)
      message( FATAL_ERROR "Executable \"mulle-objc-loader-tool\" not found")
   endif()

   if( NOT OBJC_LOADER_INC)
      set( OBJC_LOADER_INC "${CMAKE_SOURCE_DIR}/src/reflect/objc-loader.inc")
   endif()

   set_source_files_properties( "${OBJC_LOADER_INC}"
      PROPERTIES GENERATED TRUE
   )
   # add to headers being installed, not part of project headers though
   # because it is too late here
   set( PUBLIC_HEADERS
      ${PUBLIC_HEADERS}
      ${OBJC_LOADER_INC}
   )
   message( STATUS "OBJC_LOADER_INC is \"${OBJC_LOADER_INC}\"")

   if( INHERITED_OBJC_LOADERS)
     list( REMOVE_DUPLICATES INHERITED_OBJC_LOADERS)
   endif()

   message( STATUS "INHERITED_OBJC_LOADERS is \"${INHERITED_OBJC_LOADERS}\"")


   # The preferred way:
   #
   # _1_MulleObjC is an object library (a collection of files).
   # _2_MulleObjC is the loader with OBJC_LOADER_INC.
   #
   # Produce a static library _3_MulleObjC from _1_MulleObjC
   # to feed into MULLE_OBJC_LOADER_TOOL.
   #
   # The static library is, so that the commandline doesn't overflow for
   # many .o files.
   # In the end OBJC_LOADER_INC will be generated, which will be
   # included by the Loader.
   #
   if( TARGET "_2_${LIBRARY_NAME}")
      add_library( "_3_${LIBRARY_NAME}" STATIC
         $<TARGET_OBJECTS:_1_${LIBRARY_NAME}>
      )
      set( OBJC_LOADER_LIBRARY "$<TARGET_FILE:_3_${LIBRARY_NAME}>")

      set( STAGE2_HEADERS
         ${STAGE2_HEADERS}
         ${OBJC_LOADER_INC}
      )
   else()
      if( TARGET "_1_${LIBRARY_NAME}")
         message( FATAL_ERROR "_1_${LIBRARY_NAME} is defined, but _2_${LIBRARY_NAME} is missing")
      endif()
      set( OBJC_LOADER_LIBRARY "$<TARGET_FILE:${LIBRARY_NAME}>")
   endif()

   add_custom_command(
      OUTPUT ${OBJC_LOADER_INC}
      COMMAND ${MULLE_OBJC_LOADER_TOOL}
                 $ENV{MULLE_OBJC_LOADER_TOOL_FLAGS}
                 -c "${CMAKE_BUILD_TYPE}"
                 -o "${OBJC_LOADER_INC}"
                 ${OBJC_LOADER_LIBRARY}
                 ${INHERITED_OBJC_LOADERS}
      DEPENDS ${OBJC_LOADER_LIBRARY}
              ${ALL_LOAD_DEPENDENCY_LIBRARIES}
      COMMENT "Create: ${OBJC_LOADER_INC}"
      VERBATIM
   )

   add_custom_target( "__objc_loader_inc__"
      DEPENDS ${OBJC_LOADER_INC}
   )

   if( TARGET "_2_${LIBRARY_NAME}")
      add_dependencies( "_2_${LIBRARY_NAME}" __objc_loader_inc__)
   else()
      add_dependencies( "${LIBRARY_NAME}" __objc_loader_inc__)
   endif()

   #
   # tricky: this file can only be installed during link phase.
   #         Used by optimization.
   #
   if( LINK_PHASE)
      install( FILES "${OBJC_LOADER_INC}" DESTINATION "include/${LIBRARY_NAME}/private")
   endif()
endif()

include( CreateLoaderIncAuxObjC OPTIONAL)

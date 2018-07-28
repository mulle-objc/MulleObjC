# can be included multiple times

if( MULLE_TRACE_INCLUDE)
   message( STATUS "# Include \"${CMAKE_CURRENT_LIST_FILE}\"" )
endif()

# check if available first

if( NOT MULLE_OBJC_LOADER_TOOL)
   if( MSVC)
      find_program( MULLE_OBJC_LOADER_TOOL mulle-objc-loader-tool.bat "${DEPENDENCY_DIR}/bin")
   else()
      find_program( MULLE_OBJC_LOADER_TOOL mulle-objc-loader-tool "${DEPENDENCY_DIR}/bin")
   endif()
   message( STATUS "MULLE_OBJC_LOADER_TOOL is ${MULLE_OBJC_LOADER_TOOL}")
endif()


if( NOT LIBRARY_NAME)
   set( LIBRARY_NAME "MulleObjC")
endif()



if( NOT __DEFINE_LOADER_INC_OBJC_CMAKE__)
   set( __DEFINE_LOADER_INC_OBJC_CMAKE__ ON)

   #
   # if tool does not exist, we are maybe compiling for apple clang
   # if the _1_ _2_ targets do not exist, we are part of an old fashioned
   # CMakeLists.txt
   #
   if( MULLE_OBJC_LOADER_TOOL AND TARGET "_1_${LIBRARY_NAME}" AND TARGET "_2_${LIBRARY_NAME}")
      option( CREATE_OBJC_LOADER_INC "Create objc-loader.inc for Objective-C libraries" ON)
   else()
      option( CREATE_OBJC_LOADER_INC "Create objc-loader.inc for Objective-C libraries" OFF)
   endif()
endif()


#
# Create src/objc-loader.inc for Objective-C projects. This contains a
# list of all the classes and categories, contained in a library.
#
if( CREATE_OBJC_LOADER_INC)
   # runs in build dir
   if( NOT MULLE_OBJC_LOADER_TOOL)
      message( FATAL_ERROR "Executable \"mulle-objc-loader-tool\" not found")
   endif()

   if( NOT OBJC_LOADER_INC)
      set( OBJC_LOADER_INC "${CMAKE_SOURCE_DIR}/src/objc-loader.inc")
   endif()
   set_source_files_properties( "${OBJC_LOADER_INC}"
      PROPERTIES GENERATED TRUE
   )
   message( STATUS "OBJC_LOADER_INC is ${OBJC_LOADER_INC}")

   set( STAGE2_HEADERS
      ${STAGE2_HEADERS}
      ${OBJC_LOADER_INC}
   )
endif()

include( DefineLoaderIncObjCAux OPTIONAL)

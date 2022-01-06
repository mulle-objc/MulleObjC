### If you want to edit this, copy it from cmake/share to cmake. It will be
### picked up in preference over the one in cmake/share. And it will not get
### clobbered with the next upgrade.

if( NOT __COMPILER_DETECTION_AUX_C_CMAKE__)
   set( __COMPILER_DETECTION_AUX_C_CMAKE__ ON)

   if( MULLE_TRACE_INCLUDE)
      message( STATUS "# Include \"${CMAKE_CURRENT_LIST_FILE}\"" )
   endif()

   #
   # Detect if compiling with mulle-clang
   #
   if( MULLE_C_COMPILER_ID MATCHES "MulleClang" OR "$ENV{CC}" MATCHES ".*mulle-cl.*")
      set( MULLE_OBJC ON)
   else()
      set( MULLE_OBJC OFF)
   endif()

   include( CompilerDetectionAuxObjC OPTIONAL)

endif()


# extension : mulle-objc/objc-cmake
# directory : project/all
# template  : .../CompilerDetectionAuxC.cmake
# Suppress this comment with `export MULLE_SDE_GENERATE_FILE_COMMENTS=NO`

### If you want to edit this, copy it from cmake/share to cmake. It will be
### picked up in preference over the one in cmake/share. And it will not get
### clobbered with the next upgrade.

if( NOT __EXECUTABLE_C_AUX_CMAKE__)
   set( __EXECUTABLE_C_AUX_CMAKE__ ON)

   if( MULLE_TRACE_INCLUDE)
      message( STATUS "# Include \"${CMAKE_CURRENT_LIST_FILE}\"" )
   endif()

   # up here for orthogonality with C
   include( ExecutableAuxObjC OPTIONAL)

   include( ExecutableObjC)
   include( OptimizedLinkObjC)

endif()

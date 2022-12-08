### If you want to edit this, copy it from cmake/share to cmake. It will be
### picked up in preference over the one in cmake/share. And it will not get
### clobbered with the next upgrade.

if( NOT __AAM_SUPPORT_CMAKE__)
   set( __AAM_SUPPORT_CMAKE__ ON)

   if( MULLE_TRACE_INCLUDE)
      message( STATUS "# Include \"${CMAKE_CURRENT_LIST_FILE}\"" )
   endif()

   #
   # Input:
   #
   # SOURCES
   #
   # Optional:
   #
   #
   set( AAM_VERSION 3)


   set( AAM_SOURCES)
   foreach( file ${SOURCES})
      if( "${file}" MATCHES ".*\\.aam")
         list( APPEND AAM_SOURCES "${file}")
      endif()
   endforeach()


   set_source_files_properties(
      ${AAM_SOURCES}
      PROPERTIES LANGUAGE C
   )

   include( AAMSupportAuxObjC OPTIONAL)

endif()

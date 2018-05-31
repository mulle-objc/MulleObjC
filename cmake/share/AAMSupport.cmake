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

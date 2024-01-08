### If you want to edit this, copy it from cmake/share to cmake. It will be
### picked up in preference over the one in cmake/share. And it will not get
### clobbered with the next upgrade.

cmake_minimum_required( VERSION 3.13)

# this needs to run again for each executable so no include check
#if( NOT __EXECUTABLE_OBJC_CMAKE__)
#   set( __EXECUTABLE_OBJC_CMAKE__ ON)

if( MULLE_TRACE_INCLUDE)
   message( STATUS "# Include \"${CMAKE_CURRENT_LIST_FILE}\"" )
endif()

if( NOT EXECUTABLE_NAME)
   set( EXECUTABLE_NAME "${PROJECT_NAME}")
endif()

#
# need this for .aam projects
#
set_target_properties( "${EXECUTABLE_NAME}"
   PROPERTIES LINKER_LANGUAGE C
)

#
# only for mulle-clang
#
if( UNIX AND NOT (APPLE OR COSMOPOLITAN OR MUSL_STATIC_ONLY))
   if( LINK_PHASE)
      target_link_options( "${EXECUTABLE_LINK_TARGET}"
         PUBLIC
            "SHELL:LINKER:--export-dynamic"
      )
   endif()
endif()

#
# MEMO: if I don't "if" MULLE_ATINIT_LIBRARY, then the compiler test on
#       cmake on Apple will error out, because it doesn't link it for
#       testing the compiler.
#
if( APPLE AND MULLE_OBJC)
   if( LINK_PHASE)
      if( MULLE_OBJC_RUNTIME_LIBRARY)
         target_link_options( "${EXECUTABLE_LINK_TARGET}"
            PUBLIC
               "SHELL:LINKER:-exported_symbol,___register_mulle_objc_universe"
         )
      endif()

      if( MULLE_ATINIT_LIBRARY)
         target_link_options( "${EXECUTABLE_LINK_TARGET}"
            PUBLIC
               "SHELL:LINKER:-exported_symbol,__mulle_atinit"
         )
      endif()
      if( MULLE_ATEXIT_LIBRARY)
         target_link_options( "${EXECUTABLE_LINK_TARGET}"
            PUBLIC
               "SHELL:LINKER:-exported_symbol,_mulle_atexit"
         )
      endif()
   endif()
endif()

include( ExecutableAuxObjC OPTIONAL)

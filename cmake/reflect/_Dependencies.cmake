# This file will be regenerated by `mulle-sourcetree-to-cmake` via
# `mulle-sde reflect` and any edits will be lost.
#
# This file will be included by cmake/share/Files.cmake
#
# Disable generation of this file with:
#
# mulle-sde environment set MULLE_SOURCETREE_TO_CMAKE_DEPENDENCIES_FILE DISABLE
#
if( MULLE_TRACE_INCLUDE)
   message( STATUS "# Include \"${CMAKE_CURRENT_LIST_FILE}\"" )
endif()

#
# Generated from sourcetree: 6C69EF4A-B5C3-449C-95EE-466B3FCCA76E;mulle-objc-debug;no-all-load,no-cmake-loader,no-cmake-searchpath,no-header,no-import,no-public,no-singlephase;
# Disable with : `mulle-sourcetree mark mulle-objc-debug no-link`
# Disable for this platform: `mulle-sourcetree mark mulle-objc-debug no-cmake-platform-darwin`
#
if( NOT MULLE_OBJC_DEBUG_LIBRARY)
   find_library( MULLE_OBJC_DEBUG_LIBRARY NAMES ${CMAKE_STATIC_LIBRARY_PREFIX}mulle-objc-debug${CMAKE_STATIC_LIBRARY_SUFFIX} mulle-objc-debug NO_CMAKE_SYSTEM_PATH NO_SYSTEM_ENVIRONMENT_PATH)
   message( STATUS "MULLE_OBJC_DEBUG_LIBRARY is ${MULLE_OBJC_DEBUG_LIBRARY}")
   #
   # The order looks ascending, but due to the way this file is read
   # it ends up being descending, which is what we need.
   #
   if( MULLE_OBJC_DEBUG_LIBRARY)
      #
      # Add MULLE_OBJC_DEBUG_LIBRARY to DEPENDENCY_LIBRARIES list.
      # Disable with: `mulle-sourcetree mark mulle-objc-debug no-cmake-add`
      #
      set( DEPENDENCY_LIBRARIES
         ${DEPENDENCY_LIBRARIES}
         ${MULLE_OBJC_DEBUG_LIBRARY}
         CACHE INTERNAL "need to cache this"
      )
      #
      # Inherit information from dependency.
      # Encompasses: no-cmake-searchpath,no-cmake-dependency,no-cmake-loader
      # Disable with: `mulle-sourcetree mark mulle-objc-debug no-cmake-inherit`
      #
      # temporarily expand CMAKE_MODULE_PATH
      get_filename_component( _TMP_MULLE_OBJC_DEBUG_ROOT "${MULLE_OBJC_DEBUG_LIBRARY}" DIRECTORY)
      get_filename_component( _TMP_MULLE_OBJC_DEBUG_ROOT "${_TMP_MULLE_OBJC_DEBUG_ROOT}" DIRECTORY)
      #
      #
      # Search for "DependenciesAndLibraries.cmake" to include.
      # Disable with: `mulle-sourcetree mark mulle-objc-debug no-cmake-dependency`
      #
      foreach( _TMP_MULLE_OBJC_DEBUG_NAME "mulle-objc-debug")
         set( _TMP_MULLE_OBJC_DEBUG_DIR "${_TMP_MULLE_OBJC_DEBUG_ROOT}/include/${_TMP_MULLE_OBJC_DEBUG_NAME}/cmake")
         # use explicit path to avoid "surprises"
         if( EXISTS "${_TMP_MULLE_OBJC_DEBUG_DIR}/DependenciesAndLibraries.cmake")
            unset( MULLE_OBJC_DEBUG_DEFINITIONS)
            list( INSERT CMAKE_MODULE_PATH 0 "${_TMP_MULLE_OBJC_DEBUG_DIR}")
            # we only want top level INHERIT_OBJC_LOADERS, so disable them
            if( NOT NO_INHERIT_OBJC_LOADERS)
               set( NO_INHERIT_OBJC_LOADERS OFF)
            endif()
            list( APPEND _TMP_INHERIT_OBJC_LOADERS ${NO_INHERIT_OBJC_LOADERS})
            set( NO_INHERIT_OBJC_LOADERS ON)
            #
            include( "${_TMP_MULLE_OBJC_DEBUG_DIR}/DependenciesAndLibraries.cmake")
            #
            list( GET _TMP_INHERIT_OBJC_LOADERS -1 NO_INHERIT_OBJC_LOADERS)
            list( REMOVE_AT _TMP_INHERIT_OBJC_LOADERS -1)
            #
            list( REMOVE_ITEM CMAKE_MODULE_PATH "${_TMP_MULLE_OBJC_DEBUG_DIR}")
            set( INHERITED_DEFINITIONS
               ${INHERITED_DEFINITIONS}
               ${MULLE_OBJC_DEBUG_DEFINITIONS}
               CACHE INTERNAL "need to cache this"
            )
            break()
         else()
            message( STATUS "${_TMP_MULLE_OBJC_DEBUG_DIR}/DependenciesAndLibraries.cmake not found")
         endif()
      endforeach()
   else()
      # Disable with: `mulle-sourcetree mark mulle-objc-debug no-require-link`
      message( FATAL_ERROR "MULLE_OBJC_DEBUG_LIBRARY was not found")
   endif()
endif()


#
# Generated from sourcetree: 6a1a8ae7-8c93-4908-ae06-722cd7143197;mulle-objc-runtime;no-cmake-searchpath,no-header,no-import,no-singlephase;
# Disable with : `mulle-sourcetree mark mulle-objc-runtime no-link`
# Disable for this platform: `mulle-sourcetree mark mulle-objc-runtime no-cmake-platform-darwin`
#
if( NOT MULLE_OBJC_RUNTIME_LIBRARY)
   find_library( MULLE_OBJC_RUNTIME_LIBRARY NAMES ${CMAKE_STATIC_LIBRARY_PREFIX}mulle-objc-runtime${CMAKE_STATIC_LIBRARY_SUFFIX} mulle-objc-runtime NO_CMAKE_SYSTEM_PATH NO_SYSTEM_ENVIRONMENT_PATH)
   message( STATUS "MULLE_OBJC_RUNTIME_LIBRARY is ${MULLE_OBJC_RUNTIME_LIBRARY}")
   #
   # The order looks ascending, but due to the way this file is read
   # it ends up being descending, which is what we need.
   #
   if( MULLE_OBJC_RUNTIME_LIBRARY)
      #
      # Add MULLE_OBJC_RUNTIME_LIBRARY to ALL_LOAD_DEPENDENCY_LIBRARIES list.
      # Disable with: `mulle-sourcetree mark mulle-objc-runtime no-cmake-add`
      #
      set( ALL_LOAD_DEPENDENCY_LIBRARIES
         ${ALL_LOAD_DEPENDENCY_LIBRARIES}
         ${MULLE_OBJC_RUNTIME_LIBRARY}
         CACHE INTERNAL "need to cache this"
      )
      #
      # Inherit information from dependency.
      # Encompasses: no-cmake-searchpath,no-cmake-dependency,no-cmake-loader
      # Disable with: `mulle-sourcetree mark mulle-objc-runtime no-cmake-inherit`
      #
      # temporarily expand CMAKE_MODULE_PATH
      get_filename_component( _TMP_MULLE_OBJC_RUNTIME_ROOT "${MULLE_OBJC_RUNTIME_LIBRARY}" DIRECTORY)
      get_filename_component( _TMP_MULLE_OBJC_RUNTIME_ROOT "${_TMP_MULLE_OBJC_RUNTIME_ROOT}" DIRECTORY)
      #
      #
      # Search for "DependenciesAndLibraries.cmake" to include.
      # Disable with: `mulle-sourcetree mark mulle-objc-runtime no-cmake-dependency`
      #
      foreach( _TMP_MULLE_OBJC_RUNTIME_NAME "mulle-objc-runtime")
         set( _TMP_MULLE_OBJC_RUNTIME_DIR "${_TMP_MULLE_OBJC_RUNTIME_ROOT}/include/${_TMP_MULLE_OBJC_RUNTIME_NAME}/cmake")
         # use explicit path to avoid "surprises"
         if( EXISTS "${_TMP_MULLE_OBJC_RUNTIME_DIR}/DependenciesAndLibraries.cmake")
            unset( MULLE_OBJC_RUNTIME_DEFINITIONS)
            list( INSERT CMAKE_MODULE_PATH 0 "${_TMP_MULLE_OBJC_RUNTIME_DIR}")
            #
            include( "${_TMP_MULLE_OBJC_RUNTIME_DIR}/DependenciesAndLibraries.cmake")
            #
            #
            list( REMOVE_ITEM CMAKE_MODULE_PATH "${_TMP_MULLE_OBJC_RUNTIME_DIR}")
            set( INHERITED_DEFINITIONS
               ${INHERITED_DEFINITIONS}
               ${MULLE_OBJC_RUNTIME_DEFINITIONS}
               CACHE INTERNAL "need to cache this"
            )
            break()
         else()
            message( STATUS "${_TMP_MULLE_OBJC_RUNTIME_DIR}/DependenciesAndLibraries.cmake not found")
         endif()
      endforeach()
      #
      # Search for "MulleObjCLoader+<name>.h" in include directory.
      # Disable with: `mulle-sourcetree mark mulle-objc-runtime no-cmake-loader`
      #
      if( NOT NO_INHERIT_OBJC_LOADERS)
         foreach( _TMP_MULLE_OBJC_RUNTIME_NAME "mulle-objc-runtime")
            set( _TMP_MULLE_OBJC_RUNTIME_FILE "${_TMP_MULLE_OBJC_RUNTIME_ROOT}/include/${_TMP_MULLE_OBJC_RUNTIME_NAME}/MulleObjCLoader+${_TMP_MULLE_OBJC_RUNTIME_NAME}.h")
            if( EXISTS "${_TMP_MULLE_OBJC_RUNTIME_FILE}")
               set( INHERITED_OBJC_LOADERS
                  ${INHERITED_OBJC_LOADERS}
                  ${_TMP_MULLE_OBJC_RUNTIME_FILE}
                  CACHE INTERNAL "need to cache this"
               )
               break()
            endif()
         endforeach()
      endif()
   else()
      # Disable with: `mulle-sourcetree mark mulle-objc-runtime no-require-link`
      message( FATAL_ERROR "MULLE_OBJC_RUNTIME_LIBRARY was not found")
   endif()
endif()


#
# Generated from sourcetree: e2dd59c0-8e52-4deb-a014-f44435122832;mulle-container;no-all-load,no-cmake-inherit,no-cmake-searchpath,no-import,no-singlephase;
# Disable with : `mulle-sourcetree mark mulle-container no-link`
# Disable for this platform: `mulle-sourcetree mark mulle-container no-cmake-platform-darwin`
#
if( NOT MULLE_CONTAINER_LIBRARY)
   find_library( MULLE_CONTAINER_LIBRARY NAMES ${CMAKE_STATIC_LIBRARY_PREFIX}mulle-container${CMAKE_STATIC_LIBRARY_SUFFIX} mulle-container NO_CMAKE_SYSTEM_PATH NO_SYSTEM_ENVIRONMENT_PATH)
   message( STATUS "MULLE_CONTAINER_LIBRARY is ${MULLE_CONTAINER_LIBRARY}")
   #
   # The order looks ascending, but due to the way this file is read
   # it ends up being descending, which is what we need.
   #
   if( MULLE_CONTAINER_LIBRARY)
      #
      # Add MULLE_CONTAINER_LIBRARY to DEPENDENCY_LIBRARIES list.
      # Disable with: `mulle-sourcetree mark mulle-container no-cmake-add`
      #
      set( DEPENDENCY_LIBRARIES
         ${DEPENDENCY_LIBRARIES}
         ${MULLE_CONTAINER_LIBRARY}
         CACHE INTERNAL "need to cache this"
      )
      # intentionally left blank
   else()
      # Disable with: `mulle-sourcetree mark mulle-container no-require-link`
      message( FATAL_ERROR "MULLE_CONTAINER_LIBRARY was not found")
   endif()
endif()


#
# Generated from sourcetree: 35955F81-51A7-4110-961E-9411CD19E833;mulle-fprintf;no-all-load,no-cmake-loader,no-cmake-searchpath,no-import,no-singlephase;
# Disable with : `mulle-sourcetree mark mulle-fprintf no-link`
# Disable for this platform: `mulle-sourcetree mark mulle-fprintf no-cmake-platform-darwin`
#
if( NOT MULLE_FPRINTF_LIBRARY)
   find_library( MULLE_FPRINTF_LIBRARY NAMES ${CMAKE_STATIC_LIBRARY_PREFIX}mulle-fprintf${CMAKE_STATIC_LIBRARY_SUFFIX} mulle-fprintf NO_CMAKE_SYSTEM_PATH NO_SYSTEM_ENVIRONMENT_PATH)
   message( STATUS "MULLE_FPRINTF_LIBRARY is ${MULLE_FPRINTF_LIBRARY}")
   #
   # The order looks ascending, but due to the way this file is read
   # it ends up being descending, which is what we need.
   #
   if( MULLE_FPRINTF_LIBRARY)
      #
      # Add MULLE_FPRINTF_LIBRARY to DEPENDENCY_LIBRARIES list.
      # Disable with: `mulle-sourcetree mark mulle-fprintf no-cmake-add`
      #
      set( DEPENDENCY_LIBRARIES
         ${DEPENDENCY_LIBRARIES}
         ${MULLE_FPRINTF_LIBRARY}
         CACHE INTERNAL "need to cache this"
      )
      #
      # Inherit information from dependency.
      # Encompasses: no-cmake-searchpath,no-cmake-dependency,no-cmake-loader
      # Disable with: `mulle-sourcetree mark mulle-fprintf no-cmake-inherit`
      #
      # temporarily expand CMAKE_MODULE_PATH
      get_filename_component( _TMP_MULLE_FPRINTF_ROOT "${MULLE_FPRINTF_LIBRARY}" DIRECTORY)
      get_filename_component( _TMP_MULLE_FPRINTF_ROOT "${_TMP_MULLE_FPRINTF_ROOT}" DIRECTORY)
      #
      #
      # Search for "DependenciesAndLibraries.cmake" to include.
      # Disable with: `mulle-sourcetree mark mulle-fprintf no-cmake-dependency`
      #
      foreach( _TMP_MULLE_FPRINTF_NAME "mulle-fprintf")
         set( _TMP_MULLE_FPRINTF_DIR "${_TMP_MULLE_FPRINTF_ROOT}/include/${_TMP_MULLE_FPRINTF_NAME}/cmake")
         # use explicit path to avoid "surprises"
         if( EXISTS "${_TMP_MULLE_FPRINTF_DIR}/DependenciesAndLibraries.cmake")
            unset( MULLE_FPRINTF_DEFINITIONS)
            list( INSERT CMAKE_MODULE_PATH 0 "${_TMP_MULLE_FPRINTF_DIR}")
            # we only want top level INHERIT_OBJC_LOADERS, so disable them
            if( NOT NO_INHERIT_OBJC_LOADERS)
               set( NO_INHERIT_OBJC_LOADERS OFF)
            endif()
            list( APPEND _TMP_INHERIT_OBJC_LOADERS ${NO_INHERIT_OBJC_LOADERS})
            set( NO_INHERIT_OBJC_LOADERS ON)
            #
            include( "${_TMP_MULLE_FPRINTF_DIR}/DependenciesAndLibraries.cmake")
            #
            list( GET _TMP_INHERIT_OBJC_LOADERS -1 NO_INHERIT_OBJC_LOADERS)
            list( REMOVE_AT _TMP_INHERIT_OBJC_LOADERS -1)
            #
            list( REMOVE_ITEM CMAKE_MODULE_PATH "${_TMP_MULLE_FPRINTF_DIR}")
            set( INHERITED_DEFINITIONS
               ${INHERITED_DEFINITIONS}
               ${MULLE_FPRINTF_DEFINITIONS}
               CACHE INTERNAL "need to cache this"
            )
            break()
         else()
            message( STATUS "${_TMP_MULLE_FPRINTF_DIR}/DependenciesAndLibraries.cmake not found")
         endif()
      endforeach()
   else()
      # Disable with: `mulle-sourcetree mark mulle-fprintf no-require-link`
      message( FATAL_ERROR "MULLE_FPRINTF_LIBRARY was not found")
   endif()
endif()

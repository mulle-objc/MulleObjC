cmake_minimum_required( VERSION 3.13...99.99)

set(CMAKE_C_COMPILER_WORKS 1)

project( macro C)

set( SOURCES
main.m
Foo.m
)

add_executable( macro.exe
${SOURCES}
)

get_filename_component( C_COMPILER_NAME "${CMAKE_C_COMPILER}" NAME_WE)

if( "${C_COMPILER_NAME}" MATCHES "mulle-cl*")
   if( CMAKE_BUILD_TYPE MATCHES "^Debug|^Test")
      target_compile_options( "macro.exe" PRIVATE -fobjc-tao)
      message( STATUS "TAO enabled via compiler flag")
   endif()
endif()


target_link_libraries( macro.exe
   ${TEST_LIBRARIES}
)

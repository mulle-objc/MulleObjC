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

if( CMAKE_BUILD_TYPE MATCHES "^Debug|^Test")
   target_compile_options( "macro.exe" PRIVATE -fobjc-tao)
   message( STATUS "TAO enabled via compiler flag")
endif()


target_link_libraries( macro.exe
   ${TEST_LIBRARIES}
)

# Export symbols needed for Windows DLL dynamic linking
if( WIN32)
   target_link_options( macro.exe
      PUBLIC
         "-Wl,--export-all-symbols"
   )
endif()

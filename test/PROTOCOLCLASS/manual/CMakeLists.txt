cmake_minimum_required( VERSION 3.13...99.99)

set(CMAKE_C_COMPILER_WORKS 1)

project( manual C)

set( SOURCES
main.m
Foo.m
)

add_executable( manual.exe
${SOURCES}
)

if( CMAKE_BUILD_TYPE MATCHES "^Debug|^Test")
   target_compile_options( "manual.exe" PRIVATE -fobjc-tao)
   message( STATUS "TAO enabled via compiler flag")
endif()


target_link_libraries( manual.exe
   ${TEST_LIBRARIES}
)

# Export symbols needed for Windows DLL dynamic linking
if( WIN32)
   target_link_options( manual.exe
      PUBLIC
         "-Wl,--export-all-symbols"
   )
endif()

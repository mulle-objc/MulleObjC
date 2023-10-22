cmake_minimum_required( VERSION 3.14)

set(CMAKE_C_COMPILER_WORKS 1)

project( macro C)

set( SOURCES
main.m
Foo.m
)

add_executable( macro.exe
${SOURCES}
)

target_link_libraries( macro.exe
   ${TEST_LIBRARIES}
)

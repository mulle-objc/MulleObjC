cmake_minimum_required( VERSION 3.14)

set(CMAKE_C_COMPILER_WORKS 1)

project( manual C)

set( SOURCES
main.m
Foo.m
)

add_executable( manual.exe
${SOURCES}
)

target_link_libraries( manual.exe
   ${TEST_LIBRARIES}
)

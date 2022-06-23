cmake_minimum_required( VERSION 3.15)

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

# MULLE_MAKE_VERSION='2.2.2' '/bin/cmake'  -G Unix\ Makefiles \
#  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
#  -DCMAKE_BUILD_TYPE=Test \
#  -DCMAKE_C_COMPILER=mulle-clang \
#  -DCMAKE_C_FLAGS='-I/home/nat/.mulle/var/MulleObjC-d1c1acfc730b/dependency/Debug/include \
#  -DMULLE_TEST=1 \
#  -DMULLE_INCLUDE_DYNAMIC=1' \
#  -DCMAKE_CXX_FLAGS='\
#  -I/home/nat/.mulle/var/MulleObjC-d1c1acfc730b/dependency/Debug/include \
#  -DMULLE_TEST=1 \
#  -DMULLE_INCLUDE_DYNAMIC=1' \
#  -DMULLE_TECHNICAL_FLAGS=-vvv \
#  -DCMAKE_RULE_MESSAGES=OFF \
#  -DTEST_LIBRARIES='-L/home/nat/.mulle/var/MulleObjC-d1c1acfc730b/dependency/Debug/lib;-Wl,--no-as-needed;...' \

project( tao-load C)

cmake_minimum_required( VERSION 3.13...99.99)


add_executable( "${PROJECT_NAME}.exe"
   main.m
)

# MEMO: this will already fail at load time, so what are we tesing here ?
if( CMAKE_BUILD_TYPE STREQUAL 'Release')
set_source_files_properties( main.m PROPERTIES COMPILE_OPTIONS "-fobjc-tao")
else()
set_source_files_properties( main.m PROPERTIES COMPILE_OPTIONS "-fno-objc-tao")
endif()

message( STATUS "TEST_LIBRARIES: ${TEST_LIBRARIES}")

target_link_libraries( "${PROJECT_NAME}.exe"
   ${TEST_LIBRARIES}
)

# Export symbols for Windows DLL dynamic linking

if( WIN32)
   target_link_options( "${PROJECT_NAME}.exe"
      PUBLIC
         "-Wl,--export-all-symbols"
   )
endif()
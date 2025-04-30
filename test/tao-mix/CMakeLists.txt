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
cmake_minimum_required(VERSION 3.15)

set( CMAKE_C_COMPILER_WORKS 1)

project( tao-mix C)

cmake_minimum_required( VERSION 3.13...99.99)

set_source_files_properties( tao.m PROPERTIES COMPILE_OPTIONS "-fobjc-tao")
set_source_files_properties( no-tao.m PROPERTIES COMPILE_OPTIONS "-fno-objc-tao")

add_executable( tao-mix.exe
   main.m
   tao.m
   no-tao.m
)

target_link_libraries( tao-mix.exe
   ${TEST_LIBRARIES}
)

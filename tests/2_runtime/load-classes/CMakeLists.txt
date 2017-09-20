
# make the order inconvenient
set( SOURCES
Root.m
Foo3.m
ProtoClass2.m
Foo1.m
Base.m
ProtoClass1.m
Foo2.m
main.m)

add_executable( load-classes
${SOURCES}
)


message( "CMAKE_C_FLAGS = ${CMAKE_C_FLAGS}")
message( "CMAKE_C_FLAGS_DEBUG = ${CMAKE_C_FLAGS_DEBUG}")
message( "CMAKE_C_FLAGS_RELEASE = ${CMAKE_C_FLAGS_RELEASE}")

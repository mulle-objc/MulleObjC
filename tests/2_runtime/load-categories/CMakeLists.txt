
# make the order inconvinient
set( SOURCES
Base+C1.m
Base+C2.m
ProtoClass1.m
Base.m
Foo+C1.m
Foo+C2.m
Foo.m
Root.m
Foo+C3.m
ProtoClass2.m
main.m)

add_executable( load-categories
${SOURCES}
)


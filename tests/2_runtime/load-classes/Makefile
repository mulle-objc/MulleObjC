OUTPUT ?= load

# make the order inconvinient
SOURCES= Root.m Foo3.m ProtoClass2.m Foo1.m Base.m ProtoClass1.m Foo2.m main.m

OBJECTS=$(SOURCES:.c=.o)

all:  $(OUTPUT)

$(OUTPUT):   $(OBJECTS)
	mulle-clang $(CFLAGS) -o $@ $(OBJECTS) $(LDFLAGS)

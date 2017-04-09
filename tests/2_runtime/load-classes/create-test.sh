#! /bin/sh


PATH="`pwd -P`/..:$PATH"
export PATH

create-class.sh Root
create-classprotocol.sh ProtoClass1
create-classprotocol.sh ProtoClass2
create-protocol.sh Proto1
create-protocol.sh Proto2


create-class.sh -s Root Base

create-class.sh -s Base -p Proto1 -p Proto2 Foo1
create-class.sh -s Base -p Proto1 -c ProtoClass2 Foo2
create-class.sh -s Base -c ProtoClass1 -c ProtoClass2 Foo3

cat <<EOF > main.m
int   main( int argc, char *argv[])
{
   // just look for +load output
   return( 0);
}
EOF

TABSTOP="`printf "\t"`"

cat <<EOF > Makefile
OUTPUT ?= load-classes

# make the order inconvinient
SOURCES= \
Root.m \
Foo3.m \
ProtoClass2.m \
Foo1.m \
Base.m \
ProtoClass1.m \
Foo2.m \
main.m

OBJECTS=\$(SOURCES:.c=.o)

all:  \$(OUTPUT)

\$(OUTPUT):   \$(OBJECTS)
${TABSTOP}mulle-clang \$(CFLAGS) -o \$@ \$(OBJECTS) \$(LDFLAGS)
EOF

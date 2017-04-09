#! /bin/sh


PATH="`pwd -P`/..:$PATH"
export PATH

create-class.sh Root
create-classprotocol.sh ProtoClass1
create-classprotocol.sh ProtoClass2


create-class.sh -s Root Base

create-class.sh -s Base Foo

create-category.sh -c ProtoClass1 -d C2 Base C1
create-category.sh  Base C2

create-category.sh -d C2 Foo C1
create-category.sh -d C3 Foo C2
create-category.sh -c ProtoClass2 Foo C3


cat <<EOF > main.m
int   main( int argc, char *argv[])
{
   // just look for +load output
   return( 0);
}
EOF

TABSTOP="`printf "\t"`"

cat <<EOF > Makefile
OUTPUT ?= load-categories

# make the order inconvinient
SOURCES= \
Base+C1.m \
Base+C2.m \
ProtoClass1.m \
Base.m \
Foo+C1.m \
Foo+C2.m \
Foo.m \
Root.m  \
Foo+C3.m \
ProtoClass2.m \
main.m

OBJECTS=\$(SOURCES:.c=.o)

all:  \$(OUTPUT)

\$(OUTPUT):   \$(OBJECTS)
${TABSTOP}mulle-clang \$(CFLAGS) -o \$@ \$(OBJECTS) \$(LDFLAGS)
EOF

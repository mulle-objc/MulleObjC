#! /bin/sh

levels="-O0 -O1 -O2 -O3 -Os"


compile_apple()
{
	cc "$1" -DNDEBUG -DNSBLOCKASSERTIONS main.m -o "$2"  -framework Foundation
}


compile_mulle()
{
	mulle-clang "$1" -DNDEBUG -DNSBLOCKASSERTIONS main.m -o "$2" -I../dependencies/include -I../build/Products/Release/usr/local/include  ../build/Products/Release/libMulleStandaloneObjC.dylib
}


flag=

for CFLAGS in $levels
do
   csv="apple${CFLAGS}.csv"
   if [ ! -f "${csv}" ]
 	then
	   exe="apple-benchmark${CFLAGS}"
   	compile_apple "${CFLAGS}" "${exe}"
	   ./"${exe}" $flag > "${csv}"
	fi
   flag=--noheader

   csv="mulle${CFLAGS}.csv"
   if [ ! -f "${csv}" ]
 	then
	   exe="mulle-benchmark${CFLAGS}"
	   compile_mulle "${CFLAGS}" "${exe}"
	   ./"${exe}" $flag > "${csv}"
	fi
done


# now paste results together

printf "" > results.csv

for CFLAGS in $levels
do
   printf ";Apple ${CFLAGS}" >> results.csv

done

for CFLAGS in $levels
do
   printf ";Mulle ${CFLAGS}" >> results.csv
done
echo >> results.csv

paste -d\; apple-O*.csv mulle-O*.csv >> results.csv


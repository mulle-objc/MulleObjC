#! /bin/sh

levels="-O2"  # "-O0 -O1 -O2 -O3 -Os"
arch=${1:-x86_64}


compile_apple()
{
	cc "$1" -arch "${arch}" -DNDEBUG -DNSBLOCKASSERTIONS main.m -o "$2"  -framework Foundation
}


compile_mulle()
{
	mulle-clang "$1" -arch "${arch}" -DNDEBUG -DNSBLOCKASSERTIONS main.m -o "$2" -I../dependencies/include -I../build/Products/Release/usr/local/include  ../build/Products/Release/libMulleStandaloneObjC.dylib
}


flag=

for CFLAGS in $levels
do
   csv="apple-${arch}${CFLAGS}.csv"
   if [ ! -f "${csv}" ]
 	then
	   exe="apple-benchmark-${arch}${CFLAGS}"
   	compile_apple "${CFLAGS}" "${exe}"
	   ./"${exe}" $flag > "${csv}"
	fi
   flag=--noheader

   csv="mulle-${arch}${CFLAGS}.csv"
   if [ ! -f "${csv}" ]
 	then
	   exe="mulle-benchmark-${arch}${CFLAGS}"
	   compile_mulle "${CFLAGS}" "${exe}"
	   ./"${exe}" $flag > "${csv}"
	fi
done


# now paste results together

results="results-${arch}.csv"
printf "${arch}" > "${results}"

for CFLAGS in $levels
do
   printf ";Apple ${CFLAGS}" >> "${results}"
   printf ";Mulle ${CFLAGS}" >> "${results}"

done
echo >> "${results}"

FILES=
for CFLAGS in $levels
do
	FILES="${FILES} apple-${arch}${CFLAGS}.csv mulle-${arch}${CFLAGS}.csv"
done

paste -d\; ${FILES} >> "${results}"

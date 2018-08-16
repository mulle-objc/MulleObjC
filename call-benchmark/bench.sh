#! /bin/sh -x

#levels="-O2"
levels="-O0 -O1 -O2 -O3 -Os"
arch=${1:-x86_64}


compile_apple()
{
   eval cc "'$1'" \
      -arch "'${arch}'" \
      -g \
      -DNDEBUG \
      -DNSBLOCKASSERTIONS \
      -framework Foundation \
      -o "$2"  \
      main.m
}


compile_mulle()
{
   #
   # MEMO DOES NOT WORK ANYMORE BECAUSE mulle-bootstrap code has been
   # removed here. It turns out, I really need a mulle-compile and a
   # mulle-link command
   #
   eval mulle-clang "'$1'" \
       -arch "'${arch}'" \
       -g \
       -DNDEBUG \
       -DNSBLOCKASSERTIONS \
       -Wl,-rpath '$PWD/../tests/lib' \
       -I../tests/include  \
       ../tests/lib/libMulleObjCStandalone.dylib \
       -o "'$2'" \
       main.m
}

echo "Be sure that you have created an optimized build in tests with:"
echo "   ( cd ../tests ; ./build-test.sh )"
echo "otherwise the libraries will not be found."

set -e

# first mulle result generates the row header
flag=
for CFLAGS in $levels
do
   csv="mulle-${arch}${CFLAGS}.csv"
   if [ ! -f "${csv}" ]
   then
      exe="mulle-benchmark-${arch}${CFLAGS}"
      echo "$exe (${CFLAGS})" >&2
      compile_mulle "${CFLAGS}" "${exe}"
      DYLD_LIBRARY_PATH="../tests/lib" ./"${exe}" $flag > "${csv}"
   fi

   flag=--noheader
done

for CFLAGS in $levels
do
   csv="apple-${arch}${CFLAGS}.csv"
   if [ ! -f "${csv}" ]
   then
      exe="apple-benchmark-${arch}${CFLAGS}"
      echo "$exe (${CFLAGS})" >&2
      compile_apple "${CFLAGS}" "${exe}"
      ./"${exe}" $flag > "${csv}"
   fi
done


# now paste results together

results="results-${arch}.csv"
printf "${arch}" > "${results}"

for CFLAGS in $levels
do
   printf ";Mulle ${CFLAGS}" >> "${results}"
   printf ";Apple ${CFLAGS}" >> "${results}"
done
echo >> "${results}"

FILES=
for CFLAGS in $levels
do
   FILES="${FILES} mulle-${arch}${CFLAGS}.csv apple-${arch}${CFLAGS}.csv"
done

paste -d\; ${FILES} >> "${results}"

#! /bin/sh


#
# Very basic compiler test script. It's useful to check the compiler, when
# MulleObjC doesn't come up. The results aren't run, but it makes sure
# that the compilation steps work.
#
# Otherwise these tests are run by the top level and much more convenient
# run-tests.sh script
#

DEPENDENCIES_DIR="`mulle-bootstrap paths dependencies`" || exit 1

CFLAGS="${CFLAGS} -I'${DEPENDENCIES_DIR}/include' -L'${DEPENDENCIES_DIR}/lib' -lmulle_objc_standalone"
CC="${CC:-mulle-clang}"


fail()
{
   echo "\"$name\" failed" >&2
   exit 1
}


run_test()
{
   test="$1" ; shift
   ext="$1" ; shift

   local name

   name="`echo "$test" | sed "s/\\(.*\\)${ext}/\1/"`"

   echo "${CC}" "${CFLAGS}" "${test}"
   eval "${CC}" "${CFLAGS}" "${test}"
   rval="$?"

   case "$rval" in
      0)
         [ -f "${name}.ccdiag" ] && fail "$name"
      ;;

      *)
         [ ! -f "${name}.ccdiag" ] && fail "$name"
      ;;
   esac
}

run_tests_with_extension()
{
   ext="$1" ; shift

   IFS="
"
   for test in `find . -name "*${ext}" -print`
   do
      run_test "${test}" "${ext}" "$@"
   done
}

run_tests_with_extension ".m"
run_tests_with_extension ".aam"

echo "All tests passed" >&2

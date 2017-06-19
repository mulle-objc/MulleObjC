#! /bin/sh

DSTFILE="${1:-src/dependencies.inc}"
BUILDPATH="${2:-build}"

case "`uname -s`" in
   Darwin)
      STANDALONE_LIB="libMulleObjCStandalone.dylib"
   ;;

   MINGW*|Win*|WIN*)
     STANDALONE_LIB="libMulleObjCStandalone.dll" # assume
   ;;

   *)
     STANDALONE_LIB="libMulleObjCStandalone.so"
   ;;
esac


# only runs on OS X out of the box
eval `mulle-bootstrap paths path`

if [ ! -f "${BUILDPATH}/${STANDALONE_LIB}" ]
then
   echo "${BUILDPATH}/${STANDALONE_LIB} not found, mulle-build first" >&2
   exit 1
fi

#
# First get all classes and categories "below" OS for later removal
# Then get all standalone classes, but remove Posix classes and
# OS specifica. The remainder are osbase-dependencies
#
mulle-objc-list -d "${BUILDPATH}/${STANDALONE_LIB}" | \
   fgrep -v  MulleObjCLoader | \
   sort > "${DSTFILE}" || exit 1

echo "${DSTFILE} written" >&2
exit 0

#! /bin/sh


# only runs on OS X out of the box
eval `mulle-bootstrap paths path`

if [ ! -f "build/libMulleObjCStandalone.dylib" ]
then
   echo "build/libMulleObjCStandalone.dylib not found, mulle-build first" >&2
   exit 1
fi

#
# First get all classes and categories "below" OS for later removal
# Then get all standalone classes, but remove Posix classes and
# OS specifica. The remainder are osbase-dependencies
#
mulle-objc-list -d "build/libMulleObjCStandalone.dylib" > src/dependencies.inc || exit 1

echo "src/dependencies.inc written" >&2
exit 0

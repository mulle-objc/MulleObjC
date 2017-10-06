#! /usr/bin/env bash

LIBRARY_SHORTNAME="MulleObjC"

if [ ! -f "mulle-tests/test-m-common.sh" ]
then
   echo "you must mulle-bootstrap first" >&2
   exit 1
fi

. "mulle-tests/test-m-common.sh"
. "mulle-tests/test-tools-common.sh"
. "mulle-tests/test-sharedlib-common.sh"
. "mulle-tests/build-test-common.sh"

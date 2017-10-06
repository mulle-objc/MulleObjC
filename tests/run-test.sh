#! /usr/bin/env bash
#  run-test.sh
#  MulleObjC
#
#  Created by Nat! on 01.11.13.
#  Copyright (c) 2013 Mulle kybernetiK. All rights reserved.
#  (was run-mulle-scion-test)

LIBRARY_SHORTNAME="MulleObjC"

if [ -f "mulle-tests/test-m-common.sh" ]
then
   echo "you must mulle-bootstrap first" >&2
   exit 1
fi


. "mulle-tests/test-m-common.sh"
. "mulle-tests/test-tools-common.sh"
. "mulle-tests/test-sharedlib-common.sh"
. "mulle-tests/run-test-common.sh"

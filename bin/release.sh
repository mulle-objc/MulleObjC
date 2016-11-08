#! /bin/sh

PROJECT="MulleObjC"                   # requires camel-case
DESC="Objective-C root classes using the mulle-objc runtime"
DEPENDENCIES='${DEPENDENCY_TAP}/mulle-objc
${DEPENDENCY_TAP}/mulle-container'    # no camel case, will be evaled later!
LANGUAGE=objc                         # c,cpp, objc

#
# Ideally you don't hafta change anything below this line
#
# source mulle-homebrew.sh (clumsily)
MULLE_BOOTSTRAP_FAIL_PREFIX="release.sh"

. ./bin/repository-info.sh || exit 1
. ./bin/mulle-homebrew/mulle-homebrew.sh || exit 1

# parse options
homebrew_parse_options "$@"

# dial past options
while [ $# -ne 0 ]
do
   case "$1" in
      -*)
         shift
      ;;
      *)
         break;
      ;;
   esac
done


#
# these can usually be deduced, if you follow the conventions
#
NAME="MulleObjC"
HEADER="src/ns_rootconfiguration.h"
VERSIONNAME="MULLE_OBJC_VERSION"
VERSION="`get_header_version "${HEADER}" "${VERSIONNAME}"`"

HOMEPAGE="`eval echo "${HOMEPAGE}"`"


# --- HOMEBREW TAP ---
# Specify to where and under what bame to publish via your brew tap
#
RBFILE="${NAME}.rb"                    # ruby file for brew
HOMEBREWTAP="../homebrew-software"     # your tap repository path


# --- GIT ---
# tag to tag your release
# and the origin where
TAG="${1:-${TAGPREFIX}${VERSION}}"


main()
{
   git_main "${ORIGIN}" "${TAG}" || exit 1
   homebrew_main
}

main "$@"

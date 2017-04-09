#! /bin/sh


log_error()
{
   printf "${C_ERROR}%b${C_RESET}\n" "$*"
}


log_fail()
{
   log_error "Error: $*"
}


fail()
{
   log_fail "$*"
   exit 1
}


create_h_file()
{
   cat <<EOF
#import <MulleObjC/MulleObjC.h>

@protocol ${PROTOCOL}
@end
EOF
}


main()
{
   [ "$#" -ne 0 ] || fail "protocol name missing"
   [ "$#" -eq 1 ] || fail "superflous trash"

   PROTOCOL="$1"
   shift

   create_h_file > "${PROTOCOL}.h"
}


main "$@"

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




concat()
{
   local i
   local s

   for i in "$@"
   do
      if [ -z "${i}" ]
      then
         continue
      fi

      if [ -z "${s}" ]
      then
         s="${i}"
      else
         s="${s} ${i}"
      fi
   done

   echo "${s}"
}



create_h_file()
{
   cat <<EOF
#import <MulleObjC/MulleObjC.h>

@class ${CLASSPROTOCOL};
@protocol ${CLASSPROTOCOL}
@end
EOF
}


create_m_file()
{
   cat <<EOF
#import "${CLASSPROTOCOL}.h"

#include <stdio.h>

@interface $CLASSPROTOCOL < $CLASSPROTOCOL>
@end


@implementation $CLASSPROTOCOL

+ (void) load
{
    printf( "$CLASSPROTOCOL\n");
}
@end
EOF
}



main()
{
   [ "$#" -ne 0 ] || fail "classprotocol name missing"
   [ "$#" -eq 1 ] || fail "superflous trash"

   CLASSPROTOCOL="$1"
   shift


   create_h_file > "${CLASSPROTOCOL}.h"
   create_m_file > "${CLASSPROTOCOL}.m"
}


main "$@"

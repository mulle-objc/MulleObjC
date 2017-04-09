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



print_protocol_declarations()
{
   if [ ! -z "${PROTOCOLS}" -o ! -z "${CLASSPROTOCOLS}" ]
   then
      for protocol in $CLASSPROTOCOLS
      do
         echo "@class ${protocol};"
         echo "@protocol ${protocol};"
      done

      for protocol in $PROTOCOLS
      do
         echo "@protocol ${protocol};"
      done

      echo ""
   fi
}


print_protocol_inclusions()
{
   if [ ! -z "${PROTOCOLS}" -o ! -z "${CLASSPROTOCOLS}" ]
   then
      printf " <"

      local seperator

      seperator=" "
      for protocol in $CLASSPROTOCOLS
      do
         printf "${seperator}${protocol}"
         seperator=", "
      done

      for protocol in $PROTOCOLS
      do
         printf "${seperator}${protocol}"
         seperator=", "
      done

      printf ">"
   fi
}


create_h_file()
{
   if [ -z "${SUPERCLASS}" ]
   then
      echo "#import <MulleObjC/MulleObjC.h>"
   else
      echo "#import \"${SUPERCLASS}.h\""
   fi
   echo ""

   print_protocol_declarations

   printf "@interface ${CLASS}"

   if [ ! -z "${SUPERCLASS}" ]
   then
      printf " : ${SUPERCLASS}"
   fi

   print_protocol_inclusions

   printf "\n"

   echo "@end"
}


create_m_file()
{
   cat <<EOF
#import "${CLASS}.h"

#include <stdio.h>


@implementation $CLASS

+ (void) load
{
    printf( "$CLASS\n");
}
@end
EOF
}



main()
{
   while [ $# -ne 0 ]
   do
      case "$1" in
         -p|--protocol)
            shift
            [ "$#" -ne 0 ] || fail "protocol name missing"

            PROTOCOLS="`concat "${PROTOCOLS}" "$1"`"
         ;;

         -c|--class-protocol)
            shift
            [ "$#" -ne 0 ] || fail "classprotocol name missing"

            CLASSPROTOCOLS="`concat "${CLASSPROTOCOLS}" "$1"`"
         ;;

         -s|--superclass)
            shift
            [ "$#" -ne 0 ] || fail "superclass name missing"

            SUPERCLASS="$1"
         ;;

         *)
            break
         ;;
      esac

      shift
   done

   [ "$#" -ne 0 ] || fail "class name missing"
   [ "$#" -eq 1 ] || fail "superflous trash"

   CLASS="$1"
   shift


   create_h_file > "${CLASS}.h"
   create_m_file > "${CLASS}.m"
}


main "$@"

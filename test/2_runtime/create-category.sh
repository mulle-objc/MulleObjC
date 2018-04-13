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


create_m_file()
{
   cat <<EOF
#import "${CLASS}.h"

#include <stdio.h>


EOF

   print_protocol_declarations

   printf "%s" "@interface $CLASS( $CATEGORY)"

   print_protocol_inclusions

   echo ""
   echo "@end"
   echo ""

   cat <<EOF
@implementation $CLASS( $CATEGORY)

+ (void) load
{
    printf( "$CLASS( $CATEGORY)\n");
}

EOF

   if [ ! -z "${DEPENDENCIES}" ]
   then

      cat <<EOF
+ (struct _mulle_objc_dependency *) dependencies
{
   static struct _mulle_objc_dependency  dependencies[] =
   {
EOF

      for dependency in $DEPENDENCIES
      do
         echo "   { @selector( ${CLASS}), @selector( ${dependency}) },"
      done

      cat <<EOF
      { 0, 0 }
   };

   return( dependencies);
}

EOF
   fi

   echo "@end"
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

         -c|--classprotocol)
            shift
            [ "$#" -ne 0 ] || fail "classprotocol name missing"

            CLASSPROTOCOLS="`concat "${CLASSPROTOCOLS}" "$1"`"
         ;;

         -d|--dependency)
            shift
            [ "$#" -ne 0 ] || fail "category name missing"

            DEPENDENCIES="`concat "${DEPENDENCIES}" "$1"`"
         ;;

         *)
            break
         ;;
      esac

      shift
   done

   [ "$#" -ne 0 ] || fail "class name missing"

   CLASS="$1"
   shift

   [ "$#" -ne 0 ] || fail "category name missing"
   [ "$#" -eq 1 ] || fail "superflous trash"

   CATEGORY="$1"
   shift

   create_m_file > "${CLASS}+${CATEGORY}.m"
}


main "$@"

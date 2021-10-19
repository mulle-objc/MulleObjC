#! /usr/bin/env bash 

CHARSET0="abcdefghijklmnopqrstuvwxyz_"
CHARSET="abcdefghijklmnopqrstuvwxyz_0123456789"

generate_random_string()
{
   local len="$1"

   local i

   RVAL="${CHARSET0:RANDOM%${#CHARSET0}:1}"

   i=1
   while [ $i -lt $len ]
   do
      RVAL="${RVAL}${CHARSET:RANDOM%${#CHARSET}:1}"
      i=$((i + 1))
   done
}


METHOD_CALLS=

n_selectors=128
i=0
while [ $i -lt 128 ]
do
   generate_random_string 8

   hash="`mulle-objc-uniqueid "$RVAL" `" || exit 1

   case "${hash:6:1}" in
      f|0)
         echo "+ (SEL) $RVAL { return( @selector( $RVAL)); } // $hash"
         METHOD_CALL="      case $i : assert( [self ${RVAL}] == @selector( $RVAL)); break;"
         if [ -z "${METHOD_CALLS}" ]
         then
            METHOD_CALLS="${METHOD_CALL}"
         else
            METHOD_CALLS="${METHOD_CALLS}
${METHOD_CALL}"
         fi
         i=$((i+1))
      ;;
   esac
done


echo ""
echo "${METHOD_CALLS}"



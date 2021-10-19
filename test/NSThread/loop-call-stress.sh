#!/usr/bin/env bash

while :
do
   ./call-stress.exe 2> /dev/null > log

   i=1
   expect="0"
   while [ $i -lt 1024 ]
   do
      expect="${expect}"$'\n'"$i"
      i=$((i + 1))
   done

   #
   # check that everything is sorted nicely
   #
   a_output="`sed -n '/^a:/s/a: //p' log `"
   b_output="`sed -n '/^b:/s/b: //p' log `"

   if [ "${a_output}" != "${expect}" ]
   then
      echo "**FAIL**" >&2
      echo "a:"
      echo "${a_output}"
      exit 1
   fi

   if [ "${b_output}" != "${expect}" ]
   then
      echo "**FAIL**" >&2
      echo "b:"
      echo "${b_output}"
      exit 1
   fi

   printf "."
done
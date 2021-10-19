#! /usr/bin/env bash


i=0

while [ $i -lt 1024 ]
do
   cat <<EOF
   fprintf( stderr, "%s\n", [self foo_$i]);
EOF
    i=$((i + 1))
done



#! /usr/bin/env bash


i=0

while [ $i -lt 1024 ]
do
   cat <<EOF
- (char *) foo_$i { return( "$i"); }
EOF
    i=$((i + 1))
done



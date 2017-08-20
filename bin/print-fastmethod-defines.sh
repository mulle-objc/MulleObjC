#! /bin/sh

EXE="${1:-mulle-objc-uniqueid}"

FAST_METHOD_START=8

METHODS="length
count
self
hash
nextObject
timeIntervalSinceReferenceDate
lock
unlock
class
isKindOfClass:
objectAtIndex:
characterAtIndex:
methodForSelector:
respondsToSelector:"

i="${FAST_METHOD_START}"

for method in ${METHODS}
do
   value="`${EXE} "${method}"`" || exit 1
   echo "#define MULLE_OBJC_FASTMETHODHASH_$i ;MULLE_OBJC_METHODID( 0x${value}) ;// \"${method}\""
   i="`expr $i + 1`"
done | column -t -s ';'

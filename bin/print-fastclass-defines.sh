#! /bin/sh

EXE="${1:-mulle-objc-uniqueid}"

FAST_CLASS_START=0

CLASSES="NSArray
NSAutoreleasePool
NSCalendarDate
NSCharacterSet
NSData
NSDate
NSDecimalNumber
NSDictionary
NSMutableArray
NSMutableData
NSMutableDictiona
NSMutableSet
NSMutableString
NSNumber
NSSet
NSString"

i="${FAST_CLASS_START}"

for class in ${CLASSES}
do
   value="`${EXE} "${class}"`" || exit 1
   echo "#define MULLE_OBJC_FASTCLASS_$i; MULLE_OBJC_CLASSID( 0x${value}) ;// \"${class}\""
   i="`expr $i + 1`"
done | column -t -s ';'
#import <MulleObjC/MulleObjC.h>
#import <MulleObjC/mulle-objc-enum.h>

#include <stddef.h>


typedef NS_ENUM( int, Color)
{
   ColorRed   = 0,
   ColorGreen = 1,
   ColorBlue  = 2
};

NS_ENUM_TABLE( Color, 3) =
{
   NS_ENUM_ITEM( ColorRed),
   NS_ENUM_ITEM( ColorGreen),
   NS_ENUM_ITEM( ColorBlue)
};

// table with a NULL sentinel to test NULL key guard
static struct { char *s; int value; }  BadTable[] =
{
   { "Foo", 1 },
   { NULL, 0 }
};


int  main( void)
{
   unsigned long long   value;
   int                  rval;

   // known value
   value = 0xDEAD;
   rval  = NS_ENUM_PARSE_STRICT( Color, "ColorRed", &value);
   mulle_printf( "%d %lld\n", rval, value);

   // unknown value - must not crash, should return NO
   value = 0xDEAD;
   rval  = NS_ENUM_PARSE_STRICT( Color, "259", &value);
   mulle_printf( "%d %lld\n", rval, value);

   // unknown value - must not crash, should return NO
   value = 0xDEAD;
   rval  = NS_ENUM_PARSE_STRICT( Color, "Unknown", &value);
   mulle_printf( "%d %lld\n", rval, value);

   // NULL - must not crash
   value = 0xDEAD;
   rval  = NS_ENUM_PARSE_STRICT( Color, NULL, &value);
   mulle_printf( "%d %lld\n", rval, value);

   // table with NULL key entry - must not crash
   value = 0xDEAD;
   rval  = _NS_ENUM_ParseUTF8String_strict( BadTable, 2, sizeof( BadTable[0]),
                                            offsetof( struct { char *s; int value; }, value),
                                            sizeof( int), "Bar", &value);
   mulle_printf( "%d %lld\n", rval, value);

   return( 0);
}

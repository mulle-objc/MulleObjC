#include <MulleObjC/NSByteOrder.h>
#include <stdio.h>
#include <assert.h>


static void   test_ns_swap( void)
{
   assert( NSSwapShort( 0x1234) == 0x3412);
   assert( NSSwapInt( 0x12345678) == 0x78563412);
   assert( NSSwapLongLong( 0x123456789ABCDEF0ULL) == 0xF0DEBC9A78563412ULL);
}


static void   test_mulle_objc_swap( void)
{
   assert( MulleObjCSwapUInt16( 0x1234) == 0x3412);
   assert( MulleObjCSwapUInt32( 0x12345678) == 0x78563412);
}


static void   test_ns_endian( void)
{
   unsigned short   val = 0x1234;
   
   assert( NSSwapBigShortToHost( NSSwapHostShortToBig( val)) == val);
   assert( NSSwapLittleShortToHost( NSSwapHostShortToLittle( val)) == val);
   
   unsigned int   val32 = 0x12345678;
   assert( NSSwapBigIntToHost( NSSwapHostIntToBig( val32)) == val32);
   assert( NSSwapLittleIntToHost( NSSwapHostIntToLittle( val32)) == val32);
}


static void   test_ns_float( void)
{
   float   f = 1.5f;
   NSSwappedFloat   sf = NSConvertHostFloatToSwapped( f);
   
   assert( NSConvertSwappedFloatToHost( sf) == f);
   
   NSSwappedFloat   big = NSSwapHostFloatToBig( f);
   assert( NSSwapBigFloatToHost( big) == f);
   
   NSSwappedFloat   little = NSSwapHostFloatToLittle( f);
   assert( NSSwapLittleFloatToHost( little) == f);
}


static void   test_ns_double( void)
{
   double   d = 2.5;
   NSSwappedDouble   sd = NSConvertHostDoubleToSwapped( d);
   
   assert( NSConvertSwappedDoubleToHost( sd) == d);
   
   NSSwappedDouble   big = NSSwapHostDoubleToBig( d);
   assert( NSSwapBigDoubleToHost( big) == d);
}


int   main( void)
{
   test_ns_swap();
   test_mulle_objc_swap();
   test_ns_endian();
   test_ns_float();
   test_ns_double();
   
   printf( "All compatibility tests passed\n");
   return( 0);
}

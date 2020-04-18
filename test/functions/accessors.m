#import <MulleObjC/MulleObjC.h>


@interface Foo : NSObject

@property BOOL                 v_B;
@property char                 v_c;
@property unsigned char        v_C;
@property short                v_s;
@property unsigned short       v_S;
@property int                  v_i;
@property unsigned int         v_I;
@property long                 v_l;
@property unsigned long        v_L;
@property long long            v_q;
@property unsigned long long   v_Q;
@property float                v_f;
@property double               v_d;
@property long double          v_D;
@property NSRange              v_range;

@end


@implementation Foo
@end



int   main( int argc, char *argv[])
{
   Foo   *foo;

   foo = [Foo object];

   MulleObjCObjectSetBOOL( foo, @selector( setV_B:), YES);
   if( MulleObjCObjectGetBOOL( foo, @selector( v_B)) != YES)
   {
      printf( "BOOL fail\n");
      return( 1);
   }
   MulleObjCObjectSetChar( foo, @selector( setV_c:), 18);
   if( MulleObjCObjectGetChar( foo, @selector( v_c)) != 18)
   {
      printf( "char fail\n");
      return( 1);
   }
   MulleObjCObjectSetShort( foo, @selector( setV_s:), 1848);
   if( MulleObjCObjectGetShort( foo, @selector( v_s)) != 1848)
   {
      printf( "short fail\n");
      return( 1);
   }
   MulleObjCObjectSetInt( foo, @selector( setV_i:), 1848*1000);
   if( MulleObjCObjectGetInt( foo, @selector( v_i)) != 1848*1000)
   {
      printf( "int fail\n");
      return( 1);
   }

   MulleObjCObjectSetLong( foo, @selector( setV_l:), 1848*1000);
   if( MulleObjCObjectGetInt( foo, @selector( v_l)) != 1848*1000)
   {
      printf( "long fail\n");
      return( 1);
   }

   MulleObjCObjectSetLongLong( foo, @selector( setV_q:), 1848*1000*1000);
   if( MulleObjCObjectGetLongLong( foo, @selector( v_q)) != 1848*1000*1000)
   {
      printf( "long long fail\n");
      return( 1);
   }

   MulleObjCObjectSetFloat( foo, @selector( setV_f:), 18.48f);
   if( MulleObjCObjectGetFloat( foo, @selector( v_f)) != 18.48f)
   {
      printf( "float fail \n");
      return( 1);
   }

   MulleObjCObjectSetDouble( foo, @selector( setV_d:), 18.48);
   if( MulleObjCObjectGetDouble( foo, @selector( v_d)) != 18.48)
   {
      printf( "double fail\n");
      return( 1);
   }

   MulleObjCObjectSetLongDouble( foo, @selector( setV_D:), 18.48);
   if( MulleObjCObjectGetLongDouble( foo, @selector( v_D)) != 18.48)
   {
      printf( "long double fail\n");
      return( 1);
   }

   MulleObjCObjectSetRange( foo, @selector( setV_range:), NSMakeRange( 18, 48));
   if( ! NSEqualRanges( MulleObjCObjectGetRange( foo, @selector( v_range)), NSMakeRange( 18, 48)))
   {
      printf( "range fail\n");
      return( 1);
   }

   return( 0);
}


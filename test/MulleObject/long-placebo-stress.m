#import <MulleObjC/MulleObjC.h>

#include <stdio.h>


@interface Foo : MulleObject

@property( assign, dynamic) long  myLongValue00;
@property( assign, dynamic) long  myLongValue01;
@property( assign, dynamic) long  myLongValue02;
@property( assign, dynamic) long  myLongValue03;
@property( assign, dynamic) long  myLongValue04;
@property( assign, dynamic) long  myLongValue05;
@property( assign, dynamic) long  myLongValue06;
@property( assign, dynamic) long  myLongValue07;
@property( assign, dynamic) long  myLongValue08;
@property( assign, dynamic) long  myLongValue09;
@property( assign, dynamic) long  myLongValue10;
@property( assign, dynamic) long  myLongValue11;
@property( assign, dynamic) long  myLongValue12;
@property( assign, dynamic) long  myLongValue13;
@property( assign, dynamic) long  myLongValue14;
@property( assign, dynamic) long  myLongValue15;
@property( assign, dynamic) long  myLongValue16;
@property( assign, dynamic) long  myLongValue17;
@property( assign, dynamic) long  myLongValue18;
@property( assign, dynamic) long  myLongValue19;
@property( assign, dynamic) long  myLongValue20;
@property( assign, dynamic) long  myLongValue21;
@property( assign, dynamic) long  myLongValue22;
@property( assign, dynamic) long  myLongValue23;

@end


@implementation Foo

@dynamic myLongValue00;
@dynamic myLongValue01;
@dynamic myLongValue02;
@dynamic myLongValue03;
@dynamic myLongValue04;
@dynamic myLongValue05;
@dynamic myLongValue06;
@dynamic myLongValue07;
@dynamic myLongValue08;
@dynamic myLongValue09;
@dynamic myLongValue10;
@dynamic myLongValue11;
@dynamic myLongValue12;
@dynamic myLongValue13;
@dynamic myLongValue14;
@dynamic myLongValue15;
@dynamic myLongValue16;
@dynamic myLongValue17;
@dynamic myLongValue18;
@dynamic myLongValue19;
@dynamic myLongValue20;
@dynamic myLongValue21;
@dynamic myLongValue22;
@dynamic myLongValue23;

@end


#define LOOPS (1000*1000)

int  main()
{
   Foo   *obj;
   int   j;

   obj = [Foo object];
   for( j = 0; j < LOOPS; j++)
   {
      [obj setMyLongValue01:[obj myLongValue00] + 1];
      [obj setMyLongValue02:[obj myLongValue01] + 1];
      [obj setMyLongValue03:[obj myLongValue02] + 1];
      [obj setMyLongValue04:[obj myLongValue03] + 1];
      [obj setMyLongValue05:[obj myLongValue04] + 1];
      [obj setMyLongValue06:[obj myLongValue05] + 1];
      [obj setMyLongValue07:[obj myLongValue06] + 1];
      [obj setMyLongValue08:[obj myLongValue07] + 1];
      [obj setMyLongValue09:[obj myLongValue08] + 1];
      [obj setMyLongValue10:[obj myLongValue09] + 1];
      [obj setMyLongValue11:[obj myLongValue10] + 1];
      [obj setMyLongValue12:[obj myLongValue11] + 1];
      [obj setMyLongValue13:[obj myLongValue12] + 1];
      [obj setMyLongValue14:[obj myLongValue13] + 1];
      [obj setMyLongValue15:[obj myLongValue14] + 1];
      [obj setMyLongValue16:[obj myLongValue15] + 1];
      [obj setMyLongValue17:[obj myLongValue16] + 1];
      [obj setMyLongValue18:[obj myLongValue17] + 1];
      [obj setMyLongValue19:[obj myLongValue18] + 1];
      [obj setMyLongValue20:[obj myLongValue19] + 1];
      [obj setMyLongValue21:[obj myLongValue20] + 1];
      [obj setMyLongValue22:[obj myLongValue21] + 1];
      [obj setMyLongValue23:[obj myLongValue22] + 1];
      [obj setMyLongValue00:[obj myLongValue23] + 1];
   }
   printf( "%.1f\n", [obj myLongValue00] / (double) LOOPS);
   return( 0);
}




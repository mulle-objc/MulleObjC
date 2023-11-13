#import <MulleObjC/MulleObjC.h>



@interface Bar  : NSObject

@property( assign) NSUInteger  count;
@property( assign) float       borderWidth;
@property( retain) Bar         *object;
@property( retain) Bar         *nilObject;
@property( assign) char        *string;
@property( assign) char        *nullString;

@end 


@implementation Bar 

- (char *) UTF8String
{
   return( "VfL Bochum 1848");
}

@end 


static void   test_bar( void)
{
   Bar   *x = [Bar object];
   Bar   *y = [Bar object];
   char  *s;

   [x setObject:y];
   [x setCount:1848];
   [x setBorderWidth:18.48];
   [x setString:"Vfl Bochum 1848"];

   mulle_buffer_do( buffer)
   {
      MulleObjCDescribeIvars( buffer, x);
      s = mulle_buffer_get_string( buffer);
      printf( "%s\n", s);
   }
}


int   main( int argc, char *argv[])
{
   test_bar();

   return( 0);
}


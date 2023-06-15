#import <MulleObjC/MulleObjC.h>


static void   test_array( void)
{
   double a[ 3] = { 1, 1848, 3 };
   char   *s;

   mulle_buffer_do( buffer)
   {
      MulleObjCDescribeMemory( buffer, 
                               mulle_data_make( a, sizeof( a)), 
                               @encode( double[ 3]));
      s = mulle_buffer_get_string( buffer);
      printf( "%s\n", s);
   }
}


static void   test_union( void)
{
   union abc {  int a; char b; double c; } x = { .a = 1848 } ;
   char   *s;

   mulle_buffer_do( buffer)
   {
      MulleObjCDescribeMemory( buffer, 
                               mulle_data_make( &x, sizeof( x)), 
                               @encode( union abc));
      s = mulle_buffer_get_string( buffer);
      printf( "%s\n", s);
   }
}

static void   test_struct( void)
{
   struct abc {  int a; char b; double c; } x = { 1848, '2', 3 } ;
   char   *s;

   mulle_buffer_do( buffer)
   {
      MulleObjCDescribeMemory( buffer, 
                               mulle_data_make( &x, sizeof( x)), 
                               @encode( struct abc));
      s = mulle_buffer_get_string( buffer);
      printf( "%s\n", s);
   }
}

static void   test_float( void)
{
   float   x = 1848;
   char    *s;
   
   mulle_buffer_do( buffer)
   {
      MulleObjCDescribeMemory( buffer, 
                               mulle_data_make( &x, sizeof( x)), 
                               @encode( float));
      s = mulle_buffer_get_string( buffer);
      printf( "%s\n", s);
   }
}

static void   test_double( void)
{
   double   x = 1848;
   char     *s;
   
   mulle_buffer_do( buffer)
   {
      MulleObjCDescribeMemory( buffer, 
                               mulle_data_make( &x, sizeof( x)), 
                               @encode( double));
      s = mulle_buffer_get_string( buffer);
      printf( "%s\n", s);
   }
}


static void   test_long_long( void)
{
   long long   x = 1848;
   char  *s;
   
   mulle_buffer_do( buffer)
   {
      MulleObjCDescribeMemory( buffer, 
                               mulle_data_make( &x, sizeof( x)), 
                               @encode( long long));
      s = mulle_buffer_get_string( buffer);
      printf( "%s\n", s);
   }
}

static void   test_int( void)
{
   int   x = 1848;
   char  *s;

   mulle_buffer_do( buffer)
   {
      MulleObjCDescribeMemory( buffer, 
                               mulle_data_make( &x, sizeof( x)), 
                               @encode( int));
      s = mulle_buffer_get_string( buffer);
      printf( "%s\n", s);
   }
}

static void   test_char( void)
{
   int   x = 'V';
   char  *s;

   mulle_buffer_do( buffer)
   {
      MulleObjCDescribeMemory( buffer, 
                               mulle_data_make( &x, sizeof( x)), 
                               @encode( char));
      s = mulle_buffer_get_string( buffer);
      printf( "%s\n", s);
   }
}

static void   test_selector( void)
{
   SEL   x = @selector( callMeMaybe:);
   char  *s;

   mulle_buffer_do( buffer)
   {
      MulleObjCDescribeMemory( buffer, 
                               mulle_data_make( &x, sizeof( x)), 
                               @encode( SEL));
      s = mulle_buffer_get_string( buffer);
      printf( "%s\n", s);
   }
}


static void   test_pointer( void)
{
   void   *x = (void *) 0x1848;
   char  *s;

   mulle_buffer_do( buffer)
   {
      MulleObjCDescribeMemory( buffer, 
                               mulle_data_make( &x, sizeof( x)), 
                               @encode( void *));
      s = mulle_buffer_get_string( buffer);
      printf( "%s\n", s);
   }
}


@interface Foo  : NSObject
@end 


@implementation Foo 

- (char *) UTF8String
{
   return( "VfL Bochum 1848");
}

@end 


static void   test_object( void)
{
   Foo   *x = [Foo object];
   char  *s;

   mulle_buffer_do( buffer)
   {
      MulleObjCDescribeMemory( buffer, 
                               mulle_data_make( &x, sizeof( x)), 
                               @encode( Foo *));
      s = mulle_buffer_get_string( buffer);
      printf( "%s\n", s);
   }
}


static void   test_charptr( void)
{
   char  *x = "VfL Bochum 1848";
   char  *s;

   mulle_buffer_do( buffer)
   {
      MulleObjCDescribeMemory( buffer, 
                               mulle_data_make( &x, sizeof( x)), 
                               @encode( char *));
      s = mulle_buffer_get_string( buffer);
      printf( "%s\n", s);
   }
}



static void   test_broken( void)
{
   char  *x = "VfL Bochum 1848";
   char  *s;

   mulle_buffer_do( buffer)
   {
      MulleObjCDescribeMemory( buffer, 
                               mulle_data_make( &x, sizeof( x)), 
                               "]kaputt[");
      s = mulle_buffer_get_string( buffer);
      printf( "%s\n", s);
   }
}



int   main( int argc, char *argv[])
{
   test_char();
   test_int();
   test_long_long();
   test_float();
   test_double();

   test_union();
   test_struct();
   test_array();

   test_object();
   test_selector();
   test_pointer();
   test_charptr();

   test_broken();

   return( 0);
}


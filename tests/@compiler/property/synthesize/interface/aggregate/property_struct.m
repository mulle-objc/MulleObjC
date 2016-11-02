#include <mulle_objc/mulle_objc.h>
#include <float.h>
#include <stdint.h>


struct abc
{
   long     a;
   double   b;
   void     *c;
};



static void   print_void_ptr( void *x)
{
   switch( (intptr_t) x)
   {
   case INTPTR_MIN :
      printf( "INTPTR_MIN");
      break;

   case INTPTR_MAX :
      printf( "INTPTR_MAX");
      break;

   default :
      printf( "%ld", (intptr_t) x);
      return;
   }
}


static void   print_double( double x)
{
   if( x == DBL_MIN)
   {
      printf( "DBL_MIN");
      return;
   }

   if( x == DBL_MAX)
   {
      printf( "DBL_MAX");
      return;
   }

   printf( "%f", x);
}


static void   print_long( long x)
{
   switch( x)
   {
   case LONG_MIN :
      printf( "LONG_MIN");
      break;

   case LONG_MAX :
      printf( "LONG_MAX");
      break;

   default :
      printf( "%ld", x);
      return;
   }
}

static void   print_struct_abc( struct abc x)
{
   printf( "{\n   a = ");
   print_long( x.a);
   printf( ",\n   b = ");
   print_double( x.b);
   printf( ",\n   c = ");
   print_void_ptr( x.c);
   printf( "\n}\n");
}



@interface Foo

@property struct abc   value;

@end


@implementation Foo

+ (id) new
{
   return( mulle_objc_class_alloc_instance( self, calloc));
}

@end


main()
{
   Foo  *foo;

   foo = [Foo new];

   [foo setValue:(struct abc){ .a = LONG_MIN, .b = 18.48, .c = 0 }];
   print_struct_abc( [foo value]);

   [foo setValue:(struct abc){ .a = 1848, .b = 0, .c = (void *) -1848 }];
   print_struct_abc( [foo value]);

   [foo setValue:(struct abc){ .a = 0, .b = -18.48, .c = (void *) INTPTR_MAX }];
   print_struct_abc( [foo value]);

   [foo setValue:(struct abc){ .a = -1848, .b = DBL_MIN, .c = (void *) INTPTR_MIN }];
   print_struct_abc( [foo value]);

   [foo setValue:(struct abc){ .a = LONG_MAX, .b = DBL_MAX, .c = (void *) 1848 }];
   print_struct_abc( [foo value]);
}

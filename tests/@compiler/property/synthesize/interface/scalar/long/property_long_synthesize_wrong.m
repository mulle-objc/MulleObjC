#include <mulle_objc/mulle_objc.h>


static void   print_long( long x)
{
   switch( x)
   {
   case LONG_MIN :
      printf( "LONG_MIN\n");
      break;

   case LONG_MAX :
      printf( "LONG_MAX\n");
      break;

   default :
      printf( "%ld\n", x);
      return;
   }
}



@interface Foo
{
   long   _wrong;
}

@property long   value;

@end


@implementation Foo

@synthesize value = _wrong;

+ (id) new
{
   return( mulle_objc_class_alloc_instance( self, NULL));
}


@end


main()
{
   Foo  *foo;

   foo = [Foo new];

   [foo setValue:LONG_MIN];
   print_long( [foo value]);

   [foo setValue:1848];
   print_long( [foo value]);


   [foo setValue:0];
   print_long( [foo value]);

   [foo setValue:-1848];
   print_long( [foo value]);

   [foo setValue:LONG_MAX];
   print_long( [foo value]);
}

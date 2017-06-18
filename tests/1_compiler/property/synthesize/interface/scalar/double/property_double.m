#include <mulle_objc_runtime/mulle_objc_runtime.h>
#include <float.h>


static void   print_double( double x)
{
   if( x == DBL_MIN)
   {
      printf( "DBL_MIN\n");
      return;
   }

   if( x == DBL_MAX)
   {
      printf( "DBL_MAX\n");
      return;
   }

   printf( "%.2f\n", x);
}



@interface Foo

@property double   value;

+ (id) new;
- (id) retain;
- (void) release;

@end


@implementation Foo

+ (id) new
{
   return( mulle_objc_infraclass_alloc_instance( self, NULL));
}

@end


main()
{
   Foo  *foo;

   foo = [Foo new];

   [foo setValue:DBL_MIN];
   print_double( [foo value]);

   [foo setValue:18.48];
   print_double( [foo value]);


   [foo setValue:0];
   print_double( [foo value]);

   [foo setValue:-18.48];
   print_double( [foo value]);

   [foo setValue:DBL_MAX];
   print_double( [foo value]);
}

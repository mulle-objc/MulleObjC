#include <mulle_objc_runtime/mulle_objc_runtime.h>

struct bar
{
   char unused;
   char value;
   char unused2;
};

@interface Foo
@end


static void   print_struct_bar( struct bar x)
{
   switch( x.value)
   {
   case CHAR_MIN :
      printf( "CHAR_MIN\n");
      break;

   case CHAR_MAX :
      printf( "CHAR_MAX\n");
      break;

   default :
      printf( "%d\n", (int) x.value);
      return;
   }
}


@implementation Foo

+ (void) struct_bar:(struct bar) x
{
   print_struct_bar( x);
}


// return value be different than argument
+ (struct bar) struct_bar2:(struct bar) x
{
   switch( x.value)
   {
   case 0  : return( (struct bar){ .value = CHAR_MIN });
   case 1  : return( (struct bar){ .value = 18 });
   case 2  : return( (struct bar){ .value = 0 });
   case 3  : return( (struct bar){ .value = -18 });
   case 4  : return( (struct bar){ .value = CHAR_MAX });
   }
}


@end


main()
{
   [Foo struct_bar:(struct bar){ .value = CHAR_MIN }];
   [Foo struct_bar:(struct bar){ .value = 18 }];
   [Foo struct_bar:(struct bar){ .value = 0 }];
   [Foo struct_bar:(struct bar){ .value = -18 }];
   [Foo struct_bar:(struct bar){ .value = CHAR_MAX }];

   print_struct_bar( [Foo struct_bar2:(struct bar){ .value = 0}]);
   print_struct_bar( [Foo struct_bar2:(struct bar){ .value = 1}]);
   print_struct_bar( [Foo struct_bar2:(struct bar){ .value = 2}]);
   print_struct_bar( [Foo struct_bar2:(struct bar){ .value = 3}]);
   print_struct_bar( [Foo struct_bar2:(struct bar){ .value = 4}]);
}

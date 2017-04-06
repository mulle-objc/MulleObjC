#include <mulle_objc/mulle_objc.h>


@interface Foo
@end


static void   print_void_ptr( void *x)
{
   switch( (intptr_t) x)
   {
   case INTPTR_MIN :
      printf( "INTPTR_MIN\n");
      break;

   case INTPTR_MAX :
      printf( "INTPTR_MAX\n");
      break;

   default :
      printf( "%ld\n", (intptr_t) x);
      return;
   }
}


@implementation Foo

+ (void) void_ptr:(void *) a
{
   print_void_ptr( a);
}


// return value be different than argument
+ (void *) void_ptr2:(void *) x
{
   switch( (intptr_t) x)
   {
   case 0  : return( (void *) INTPTR_MIN);
   case 1  : return( (void *) 1848);
   case 2  : return( (void *) 0);
   case 3  : return( (void *) -1848);
   case 4  : return( (void *) INTPTR_MAX);
   }
}


@end


main()
{
   [Foo void_ptr:(void *) INTPTR_MIN];
   [Foo void_ptr:(void *) 1848];
   [Foo void_ptr:(void *) 0];
   [Foo void_ptr:(void *) -1848];
   [Foo void_ptr:(void *) INTPTR_MAX];

   print_void_ptr( [Foo void_ptr2:0]);
   print_void_ptr( [Foo void_ptr2:1]);
   print_void_ptr( [Foo void_ptr2:2]);
   print_void_ptr( [Foo void_ptr2:3]);
   print_void_ptr( [Foo void_ptr2:4]);
}

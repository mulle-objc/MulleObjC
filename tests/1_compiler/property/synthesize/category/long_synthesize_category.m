#include <mulle_objc_runtime/mulle_objc_runtime.h>


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
@end

@interface Foo ( Property)

@property long  value;

@end


@implementation Foo

+ (id) new
{
   return( [mulle_objc_infraclass_alloc_instance( self, NULL) init]);
}


- (id) init
{
   return( self);
}

@end


@implementation Foo( Property)

@synthesize value; // no can do

@end



main()
{
   Foo  *foo;

   foo = [Foo new];

   [foo setValue:LONG_MIN];
   print_long( [foo value]);
}

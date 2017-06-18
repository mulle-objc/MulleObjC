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

@property long   value1;
@property long   value2;

@end


@implementation Foo

@synthesize value1;
@dynamic value2;

+ (id) new
{
   return( [mulle_objc_infraclass_alloc_instance( self, NULL) init]);
}


- (id) init
{
	printf( "value1 = %ld\n", ((char *) &self->_value1 - (char *) self) / sizeof( long));
	printf( "value2 = %ld\n", ((char *) &self->_value2 - (char *) self) / sizeof( long));
   return( self);
}


- (void) setValue2:(long) x {}
- (long) value2 { return( 1848); }

@end


@interface Bar : Foo

@property long   value3;

@end


@implementation Bar

@synthesize value3;

- (id) init
{
	[super init];
	printf( "value3 = %ld\n", ((char *) &self->_value3 - (char *) self) / sizeof( long));
   return( self);
}

@end


main()
{
   Foo  *foo;
   Bar  *bar;

   foo = [Foo new];

   [foo setValue1:LONG_MIN];
   print_long( [foo value1]);
   [foo setValue2:LONG_MAX];
   print_long( [foo value2]);

   bar = [Bar new];

   [bar setValue1:LONG_MIN];
   print_long( [bar value1]);
   [bar setValue2:LONG_MAX];
   print_long( [bar value2]);
   [bar setValue3:1080408];
   print_long( [bar value3]);
}

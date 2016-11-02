#include <mulle_objc/mulle_objc.h>


@interface Bar

- (void) print;

@end


@implementation Bar

+ (id) new
{
   return( (Bar *) mulle_objc_class_alloc_instance( self, calloc));
}


- (void) print
{
   printf( "Bar: %s\n", _mulle_objc_class_get_name( _mulle_objc_object_get_class( self)));
}

@end



@interface Foo : Bar

- (id) newBar;

@end


@implementation Foo

- (id) newBar
{
   return( [Bar new]);
}

@end


int  main( void)
{
   Foo  *foo;
   Bar  *bar;

   foo = [Foo new];
   bar = [foo newBar];

   [foo print];
   [bar print];
}

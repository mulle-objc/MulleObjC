#include <mulle_objc/mulle_objc.h>


@interface Bar

- (void) print;

@end


@implementation Bar

+ (id) new
{
   return( mulle_objc_class_alloc_instance( self, calloc));
}


- (void) print
{
   printf( "Bar\n");
}

@end



@interface Foo

- (id) newBar;
- (void) print;

@end


@implementation Foo

+ (id) new
{
   return( mulle_objc_class_alloc_instance( self, calloc));
}


- (id) newBar
{
   return( [Bar new]);
}


- (void) print
{
   printf( "Foo\n");
}

@end


main()
{
   Foo  *foo;
   Bar  *bar;

   foo = [Foo new];
   bar = [foo newBar];
   [foo print];
   [bar print];
}

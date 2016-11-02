#include <mulle_objc/mulle_objc.h>


@interface Foo
@end


@implementation Foo

+ (id) new
{
   return( mulle_objc_class_alloc_instance( self, calloc));
}

@end


@implementation Foo( Category1)

- (void) printA
{
	printf( "A\n");
}

+ (void) printA
{
	printf( "+A\n");
}

@end


@implementation Foo( Category2)

- (void) printB
{
	printf( "B\n");
}


+ (void) printB
{
	printf( "+B\n");
}

@end


main()
{
   Foo  *foo;

   [Foo printA];
   [Foo printB];

   foo = [Foo new];

   [foo printA];
   [foo printB];
}

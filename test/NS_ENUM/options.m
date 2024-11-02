#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjC/MulleObjC.h>
#endif


typedef NS_OPTIONS( short, Foo)
{
   FooA = 0x01,
   FooB = 0x04,
   FooC = 0x10
};


extern NS_OPTIONS_TABLE( Foo, 3);


NS_OPTIONS_TABLE( Foo, 3) =
{
   NS_OPTIONS_ITEM( FooA),
   NS_OPTIONS_ITEM( FooB),
   NS_OPTIONS_ITEM( FooC)
};


int   main( void)
{
   printf( "%s\n", NS_OPTIONS_PRINT( Foo, FooA));
   printf( "%s\n", NS_OPTIONS_PRINT( Foo, FooB|FooC));
   printf( "%s\n", NS_OPTIONS_PRINT( Foo, FooA|FooB|FooC));

   printf( "%s\n", NS_OPTIONS_PRINT( Foo, NS_OPTIONS_PARSE( Foo, "FooA")));
   printf( "%s\n", NS_OPTIONS_PRINT( Foo, NS_OPTIONS_PARSE( Foo, "FooB|FooC")));
   printf( "%s\n", NS_OPTIONS_PRINT( Foo, NS_OPTIONS_PARSE( Foo, "FooA|FooB|FooC")));

   return( 0);
}

#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjC/MulleObjC.h>
#endif


typedef NS_ENUM( NSUInteger, Foo)
{
   FooA,
   FooB,
   FooC
};


extern NS_ENUM_TABLE( Foo, 3);


NS_ENUM_TABLE( Foo, 3) =
{
   NS_ENUM_ITEM( FooA),
   NS_ENUM_ITEM( FooB),
   NS_ENUM_ITEM( FooC)
};




int   main( void)
{
   printf( "%s\n", NS_ENUM_PRINT( Foo, FooA));
   printf( "%s\n", NS_ENUM_PRINT( Foo, FooB));
   printf( "%s\n", NS_ENUM_PRINT( Foo, FooC));

   printf( "%lld\n", NS_ENUM_PARSE( Foo, "FooA"));
   printf( "%lld\n", NS_ENUM_PARSE( Foo, "FooB"));
   printf( "%lld\n", NS_ENUM_PARSE( Foo, "FooC"));

   return( 0);
}

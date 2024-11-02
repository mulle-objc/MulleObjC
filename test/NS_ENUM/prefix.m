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
   printf( "%zd\n", NS_OPTIONS_PREFIX_LEN( Foo));

   return( 0);
}

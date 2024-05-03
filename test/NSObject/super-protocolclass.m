#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjC/MulleObjC.h>
#endif


//
_PROTOCOLCLASS_INTERFACE0( A)

@optional
- (void) method1;

PROTOCOLCLASS_END()


_PROTOCOLCLASS_INTERFACE0( B)

@optional
- (void) method2;

PROTOCOLCLASS_END()


@interface Foo < A, B>

+ (void) method0;
- (void) method3;

@end


PROTOCOLCLASS_IMPLEMENTATION( A)

+ (void) method0
{
   mulle_printf( "%s\n", __PRETTY_FUNCTION__);
}

- (void) method1
{
   mulle_printf( "%s\n", __PRETTY_FUNCTION__);
}

PROTOCOLCLASS_END()


PROTOCOLCLASS_IMPLEMENTATION( B)

+ (void) method0
{
   mulle_printf( "%s\n", __PRETTY_FUNCTION__);
}

- (void) method2
{
   mulle_printf( "%s\n", __PRETTY_FUNCTION__);
}

PROTOCOLCLASS_END()


@implementation Foo

- (void) method0
{
   mulle_printf( "%s\n", __PRETTY_FUNCTION__);
}

- (void) method3
{
   mulle_printf( "%s\n", __PRETTY_FUNCTION__);
}

@end


int  main( void)
{
   [Foo method0];
   [Foo method1];
//   [Foo method2];
//   [Foo method3];

   return( 0);
}

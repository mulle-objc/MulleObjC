#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjC/MulleObjC.h>
#endif


//
@protocol_interface  A

@optional
- (void) method1;

@end


@protocol_interface  B

@optional
- (void) method2;

@end


@interface Foo < A, B>

+ (void) method0;
- (void) method3;

@end


@protocol_implementation  A

+ (void) method0
{
   mulle_printf( "%s\n", __PRETTY_FUNCTION__);
}

- (void) method1
{
   mulle_printf( "%s\n", __PRETTY_FUNCTION__);
}

@end


@protocol_implementation  B

+ (void) method0
{
   mulle_printf( "%s\n", __PRETTY_FUNCTION__);
}

- (void) method2
{
   mulle_printf( "%s\n", __PRETTY_FUNCTION__);
}

@end


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

#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
# pragma message "this test does not work with Apple Foundation"
#else
# import <MulleObjC/MulleObjC.h>
#endif



#define FooProperties \
   @property int   a


@protocol_interface  Foo
//{
      FooProperties;
//}
@end


@protocol_implementation  Foo
//{
      @dynamic a;
//}
@end


@interface MyClass : NSObject < Foo>
@end


@implementation MyClass

- (id) init
{
   _a = 1848;
   return( self);
}


- (void) print
{
   printf( "%d\n", _a);
}

@end



int main( void)
{
   MyClass   *obj;

   @autoreleasepool
   {
      obj = [[MyClass new] autorelease];
      [obj print];
   }
   return( 0);
}

#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
# pragma message "this test does not work with Apple Foundation"
#else
# import <MulleObjC/MulleObjC.h>
#endif



#define FooProperties \
   @property int   a


@mixin  Foo
//{
      FooProperties;
//}
@end


@implementation  Foo
//{
      @dynamic a;
//}
@end


@interface MyClass : NSObject < Foo>

FooProperties;

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

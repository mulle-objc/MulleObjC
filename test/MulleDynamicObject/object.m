#import <MulleObjC/MulleObjC.h>

#include <stdio.h>



@interface Foo : MulleDynamicObject

@property( dynamic, retain) id   myValue;

@end

@implementation Foo

@dynamic myValue;

@end


@interface Bar : Foo

@property( dynamic, retain) id   notMyValue;

@end

@implementation Bar

@dynamic notMyValue;

@end


@interface Value : NSObject
@end

@implementation Value

- (char *) UTF8String
{
   return( "Value");
}
@end



int  main()
{
   id    value;
   BOOL  flag;

   {
      Foo   *obj;
      obj = [Foo object];

      [obj setMyValue:[Value object]];
      value = [obj myValue];
      mulle_printf( "%@\n", value);

      flag = [obj respondsToSelector:@selector( myValue)];
      mulle_printf( "respondsTo( myValue) = %btd\n", flag);
      flag = [obj respondsToSelector:@selector( notMyValue)];
      mulle_printf( "respondsTo( notMyValue) = %btd\n", flag);
      flag = [obj respondsToSelector:@selector( unknownValue)];
      mulle_printf( "respondsTo( unknownValue) = %btd\n", flag);
   }

   {
      Bar   *obj;

      obj = [Bar object];

      [obj setMyValue:[Value object]];
      value = [obj myValue];
      mulle_printf( "%@\n", value);

      flag = [obj respondsToSelector:@selector( myValue)];
      mulle_printf( "respondsTo( myValue) = %btd\n", flag);
      flag = [obj respondsToSelector:@selector( notMyValue)];
      mulle_printf( "respondsTo( notMyValue) = %btd\n", flag);
      flag = [obj respondsToSelector:@selector( unknownValue)];
      mulle_printf( "respondsTo( unknownValue) = %btd\n", flag);
   }
   return( 0);
}

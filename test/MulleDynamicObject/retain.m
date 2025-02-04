#import <MulleObjC/MulleObjC.h>

#include <stdio.h>

#define VALUE_HAS_NAME

@interface Foo : MulleDynamicObject
@end

@interface Foo( MoarValues)

@property( dynamic, retain) id  retainValue;

@end


@implementation Foo
@end


@implementation Foo( MoarValues)

@dynamic retainValue;

@end



@interface Value : NSObject <NSCopying>

@property( assign) char  *nameUTF8String;

@end


@implementation Value


+ (instancetype) objectWithNameUTF8String:(char *) s
{
   Value  *value;

   value = [self object];
   value->_nameUTF8String = s;
   return( value);
}


- (char *) UTF8String
{
   return( _nameUTF8String);
}


// terrible hack for this test
- (id) copy
{
   return( [[[self class] objectWithNameUTF8String:"copy"] retain]);
}

@end





int  main()
{
   Foo     *obj;
   Foo     *copy;

   @autoreleasepool
   {
      obj = [Foo object];
      [obj setRetainValue:[Value objectWithNameUTF8String:"retain"]];

      mulle_printf( "%@\n", [obj retainValue]);
      [obj mullePerformFinalize];
   }

   return( 0);
}


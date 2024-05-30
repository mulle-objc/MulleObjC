#import <MulleObjC/MulleObjC.h>

#include <stdio.h>


@interface Foo : MulleDynamicObject
@end


@interface Foo( MoarValues)

@property( dynamic, retain) id  retainValue;
@property( dynamic, assign) id  assignValue;
@property( dynamic, copy)   id  copyValue;

@end


@implementation Foo
@end


@implementation Foo( MoarValues)

@dynamic retainValue;
@dynamic assignValue;
@dynamic copyValue;

@end


@interface Value : MulleDynamicObject <NSCopying>

@property( dynamic) char  *nameUTF8String;

@end


@implementation Value

@dynamic nameUTF8String;

+ (instancetype) objectWithNameUTF8String:(char *) s
{
   Value  *value;

   value = [self object];
   [value setNameUTF8String:s];
   return( value);
}

- (char *) UTF8String
{
   return( [self nameUTF8String]);
}


// terrible hack for this test
- (id) copy
{
   return( [self mutableCopy]);
}

@end



int  main()
{
   Foo     *obj;

   @autoreleasepool
   {
      obj = [Foo object];
      [obj setCopyValue:[Value objectWithNameUTF8String:"copy"]];
      [obj setAssignValue:[Value objectWithNameUTF8String:"assign"]];
      [obj setRetainValue:[Value objectWithNameUTF8String:"retain"]];

      mulle_printf( "%@\n", [obj copyValue]);
      mulle_printf( "%@\n", [obj assignValue]);
      mulle_printf( "%@\n", [obj retainValue]);
      [obj mullePerformFinalize];
   }

   return( 0);
}


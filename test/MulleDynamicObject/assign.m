#import <MulleObjC/MulleObjC.h>

#include <stdio.h>

#define VALUE_HAS_NAME
#define DO_COPY

@interface Foo : MulleDynamicObject
@end

@interface Foo( MoarValues)

@property( dynamic, assign) id  assignValue;

@end


@implementation Foo
@end


@implementation Foo( MoarValues)

@dynamic assignValue;

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
#ifdef VALUE_HAS_NAME
   [value setNameUTF8String:s];
#endif
   return( value);
}


- (char *) UTF8String
{
#ifdef VALUE_HAS_NAME
   return( [self nameUTF8String]);
#else
   return( "assign");
#endif
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
   Foo     *copy;

   @autoreleasepool
   {
      obj = [Foo object];
      [obj setAssignValue:[Value objectWithNameUTF8String:"assign"]];

#ifdef DO_COPY
      copy = [[obj mutableCopy] autorelease];

      mulle_printf( "%@\n", [copy assignValue]);
      [copy mullePerformFinalize];
#else
      mulle_printf( "%@\n", [obj assignValue]);
#endif
      [obj mullePerformFinalize];
   }

   return( 0);
}


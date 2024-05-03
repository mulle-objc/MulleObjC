#import <MulleObjC/MulleObjC.h>

#include <stdio.h>

#define VALUE_HAS_NAME
#define DO_COPY

@interface Foo : MulleObject
@end

@interface Foo( MoarValues)

@property( dynamic, retain) id  retainValue;

@end


@implementation Foo
@end


@implementation Foo( MoarValues)

@dynamic retainValue;

@end


@interface Value : MulleObject <NSCopying>

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
   return( "retainValue");
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
      [obj setRetainValue:[Value objectWithNameUTF8String:"retain"]];

#ifdef DO_COPY
      copy = [[obj mutableCopy] autorelease];

      mulle_printf( "%@\n", [copy retainValue]);
      [copy mullePerformFinalize];
#else
      mulle_printf( "%@\n", [obj retainValue]);
#endif
      [obj mullePerformFinalize];
   }

   return( 0);
}


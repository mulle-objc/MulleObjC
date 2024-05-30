#import <MulleObjC/MulleObjC.h>

#include <stdio.h>


//
// This test shows how we can add a dynamic property via a protocol class.
// The protocol class can then provide further methods that operate on 
// the comment property...
//
PROTOCOLCLASS_INTERFACE0( Comment)

@property( dynamic, retain) id  comment;

PROTOCOLCLASS_END()


PROTOCOLCLASS_IMPLEMENTATION( Comment)
PROTOCOLCLASS_END()


@interface Foo : MulleDynamicObject < Comment>
@end


@implementation Foo
@end


// because we don't have NSString, fake up a small class to serve as an
// UTF8 container
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

// queries by mulle_printf for %@
- (char *) UTF8String
{
   return( [self nameUTF8String]);
}

@end



int  main()
{
   Foo     *obj;
   Value   *value;

   @autoreleasepool
   {
      obj   = [Foo object];
      value = [Value objectWithNameUTF8String:"VfL Bochum 1848"];
      [obj setComment:value];
      mulle_printf( "%@\n", [obj comment]);
   }

   return( 0);
}


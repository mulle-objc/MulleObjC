#import <MulleObjC/MulleObjC.h>

#include <stdio.h>


//
// This test shows how we can add a dynamic property via a protocol class.
// The protocol class can then provide further methods that operate on 
// the comment property...
//
@protocol_interface Comment < NSObject>

@property( dynamic, retain) id  comment;

@end


@protocol_implementation  Comment
@end


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

   value = [self instance];
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
      obj   = [Foo instance];
      value = [Value objectWithNameUTF8String:"VfL Bochum 1848"];
      [obj setComment:value];
      mulle_printf( "%@\n", [obj comment]);
   }

   return( 0);
}


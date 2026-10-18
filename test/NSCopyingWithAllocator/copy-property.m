#import <MulleObjC/MulleObjC.h>

#include <stdio.h>
#include <string.h>


//
// Test the property walk of NSCopyingWithAllocator.
//
// NSCopyingWithAllocator.h documents that a '@property( copy) id' is
// "copied" when an object is transferred to another allocator. So the
// clone returned by -copyWithAllocator: must own a copy of the value.
//
// The test uses a *synthesized* property (not @property( dynamic)), because
// _MulleObjCInstanceCopyWithAllocatorProperty returns early for dynamic
// properties. This is a MulleObjC test, not a compiler test.
//
@interface Value : NSObject < NSCopying, NSCopyingWithAllocator>
{
   char   *_name;
}

- (char *) name;

// returns +1, like -copy should
+ (instancetype) valueWithName:(char *) name;

@end


@implementation Value

+ (instancetype) valueWithName:(char *) name
{
   Value   *value;

   value = [self new];
   value->_name = name;
   return( value);
}


- (char *) name
{
   return( _name);
}


- (id) copy
{
   return( [Value valueWithName:_name]);
}

@end


@interface Foo : NSObject
{
   Value   *_value;
}

@property( copy) Value   *value;

@end


@implementation Foo

@synthesize value = _value;

@end


int   main( void)
{
   Foo                      *obj;
   Foo                      *clone;
   Value                    *value;
   struct mulle_allocator   *allocator;
   struct mulle_allocator   other;
   int                      rval;

   rval = 0;

   @autoreleasepool
   {
      obj   = [Foo instance];
      value = [Value valueWithName:"hello"];
      [obj setValue:value];
      [value release];

      value = [obj value];
      mulle_printf( "obj.value: %s\n", value ? [value name] : "(null)");
      if( ! value)
         rval = 2;
      else
      {
         //
         // _MulleObjCInstanceCopyWithAllocator just returns [obj retain], when
         // the target allocator is the objects own allocator. A copy of the
         // allocator struct is a *different* allocator (distinct address), but
         // it allocates and frees exactly like the original one.
         //
         allocator = MulleObjCInstanceGetAllocator( obj);
         other     = *allocator;

         clone = _MulleObjCInstanceCopyWithAllocator( obj, 0, &other);

         value = [clone value];
         mulle_printf( "clone.value: %s\n", value ? [value name] : "(null)");

         if( ! value || ! [value name] || strcmp( [value name], "hello"))
            rval = 1;

         [clone release];
      }
   }

   return( rval);
}

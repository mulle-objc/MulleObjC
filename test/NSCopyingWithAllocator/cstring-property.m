#import <MulleObjC/MulleObjC.h>

#include <stdio.h>
#include <string.h>


//
// Test the C string walk of NSCopyingWithAllocator.
//
// A '@property( copy) char *' is not an object, so it can not be sent
// copyWithAllocator:. The clone returned by -copyWithAllocator: must own a
// duplicate of the string instead (and the source gives up its own string).
//
@interface Foo : NSObject
{
   char   *_cstr;
}

@property( copy) char   *cstr;

@end


@implementation Foo

@synthesize cstr = _cstr;

@end


int   main( void)
{
   Foo                      *obj;
   Foo                      *clone;
   struct mulle_allocator   *allocator;
   struct mulle_allocator   other;
   char                     buf[ 64];
   char                     *p;
   int                      rval;

   rval = 0;

   @autoreleasepool
   {
      obj = [Foo instance];

      strcpy( buf, "hello");
      [obj setCstr:buf];
      strcpy( buf, "xxxxx");

      p = [obj cstr];
      mulle_printf( "obj.cstr: %s\n", p ? p : "(null)");
      if( ! p || strcmp( p, "hello"))
         rval = 2;

      // a *copy* of the allocator struct, so the "already there" fast path
      // of _MulleObjCInstanceCopyWithAllocator is not taken
      allocator = MulleObjCInstanceGetAllocator( obj);
      other     = *allocator;

      clone = _MulleObjCInstanceCopyWithAllocator( obj, 0, &other);

      p = [clone cstr];
      mulle_printf( "clone.cstr: %s\n", p ? p : "(null)");
      if( ! p || strcmp( p, "hello"))
         rval = 1;

      [clone release];
   }

   return( rval);
}

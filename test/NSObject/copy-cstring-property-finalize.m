#ifdef __MULLE_OBJC__
# import <MulleObjC/MulleObjC.h>
#else
# import <Foundation/Foundation.h>
#endif

#include <string.h>


//
// A '@property( copy) char *' is not an object. The compiler emits a
// 'cstring' setter and marks the property 'setterclear', so MulleObjC's
// standard -finalize clears the property by calling the setter with NULL.
// That frees the duplicated string and NULLs the ivar.
//
// If the property were not cleared, the duplicated string would leak.
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


int  main( void)
{
   Foo    *obj;
   char   buf[ 64];

   obj = [Foo new];

   // the setter duplicates, so the ivar does not alias buf
   strcpy( buf, "hello");
   [obj setCstr:buf];
   strcpy( buf, "xxxxx");
   mulle_printf( "cstr: %s\n", [obj cstr]);

   // -finalize clears the property, freeing the duplicated string
   [obj finalize];
   mulle_printf( "cstr after finalize: %s\n",
                 [obj cstr] ? [obj cstr] : "(null)");

   [obj release];
   return( 0);
}

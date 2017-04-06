#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjC/MulleObjC.h>
#endif



@implementation Foo
@end


@implementation Foo ( Category)
@end


// just don't leak anything
main()
{
   return( 0);
}

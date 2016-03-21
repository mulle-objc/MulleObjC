#ifndef __MULLE_OBJC_RUNTIME__
# import <Foundation/Foundation.h>
#else
# import <MulleStandaloneObjC/MulleStandaloneObjC.h>
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

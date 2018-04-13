#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
# pragma message "this test does not work with Apple Foundation"
#else
# import <MulleObjC/MulleObjC.h>
#endif


@interface Foo : NSObject
@end


@implementation Foo

- (void) dealloc
{
   printf( "-dealloc\n");
   [super dealloc];
}

@end



int  main()
{
   [[Foo new] autorelease];
   return( 0);
}

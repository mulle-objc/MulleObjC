#ifndef __MULLE_OBJC_RUNTIME__
# import <Foundation/Foundation.h>
# pragma message "this test does not work with Apple Foundation"
#else
# import <MulleStandaloneObjC/MulleStandaloneObjC.h>
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

#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
# pragma message "this test does not work with Apple Foundation"
#else
# import <MulleObjC/MulleObjC.h>
#endif


@interface Foo : NSObject
@end

static int   n_instances;

@implementation Foo

+ (id) new
{
   ++n_instances;
   printf( "+new\n");
   return( [super new]);
}


- (void) dealloc
{
   --n_instances;
   printf( "-dealloc\n");
   [super dealloc];
}

@end



int  main()
{
   Foo                 *foo;
   NSAutoreleasePool   *pool;

   pool = [NSAutoreleasePool new];
   {
      foo = [[Foo new] autorelease];
      printf( "%d\n", n_instances);
      [pool mulleReleaseAllObjects];
      printf( "%d\n", n_instances);
   }
   [pool release];
   printf( "%d\n", n_instances);

   return( 0);
}

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

+ (id) alloc
{
   ++n_instances;
   printf( "+alloc\n");
   return( [super alloc]);
}

- (id) init
{
   printf( "-init\n");
   return( [super init]);
}


- (void) finalize
{
   printf( "-finalize\n");
   [super finalize];
}


- (void) dealloc
{
   --n_instances;
   printf( "-dealloc\n");
   [super dealloc];
}

@end


main()
{
   Foo   *foo;

   @autoreleasepool
   {
      foo = [[[Foo alloc] init] autorelease];
      printf( "%d\n", n_instances);
   }
   printf( "%d\n", n_instances);

   return( 0);
}

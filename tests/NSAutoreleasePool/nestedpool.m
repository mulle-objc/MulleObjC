#ifndef __MULLE_OBJC_RUNTIME__
# import <Foundation/Foundation.h>
# pragma message "this test does not work with Apple Foundation"
#else
# import <MulleStandaloneObjC/MulleStandaloneObjC.h>
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
   printf( "autoreleasepool 1 opens %d\n", n_instances);
   @autoreleasepool
   {
      [[Foo new] autorelease];

      printf( "autoreleasepool 2 opens %d\n", n_instances);
      @autoreleasepool
      {
         [[Foo new] autorelease];

         printf( "autoreleasepool 3 opens %d\n", n_instances);
         @autoreleasepool
         {
            [[Foo new] autorelease];
            printf( "autoreleasepool 3 closes %d\n", n_instances);
         }
         printf( "autoreleasepool 2 closes %d\n", n_instances);
      }
      printf( "autoreleasepool 1 closes %d\n", n_instances);
   }
}

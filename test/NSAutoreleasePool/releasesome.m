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



//
// | # |  P1  |  P2  |  P3  |
// |---|------|------|------|
// | 0 |      |      |      |
// | 1 |      |      |   x  |
// | 2 |      |   x  |      |
// | 3 |      |   x  |   x  |
// | 4 |   x  |      |      |
// | 5 |   x  |      |   x  |
// | 6 |   x  |   x  |      |
// | 7 |   x  |   x  |   x  |
//
int  main()
{
   Foo                 *foo[ 8];
   NSAutoreleasePool   *pool;
   NSUInteger          previous;
   NSUInteger          count;
   NSUInteger          i;

   for( i = 0; i < 8; i++)
      foo[ i] = [Foo new];

   @autoreleasepool // P1
   {
      for( i = 0; i < 8; i++)
         if( i & 0x4)
            [foo[ i] autorelease];

      @autoreleasepool // P2
      {
         for( i = 0; i < 8; i++)
            if( i & 0x2)
               [[foo[ i] retain] autorelease];

         @autoreleasepool // P3
         {
            for( i = 0; i < 8; i++)
               if( i & 0x1)
                  [[foo[ i] retain] autorelease];

            for( i = 0; i < 8; i++)
            {
               mulle_printf( "%td: %td (%td)\n",
                              i,
                              [[NSAutoreleasePool mulleDefaultAutoreleasePool] mulleCountObject:foo[ i]],
                              [NSAutoreleasePool mulleCountObject:foo[ i]]);
            }

            // everything is setup: now remove objects from the
            // autoreleasepool stack
            previous = [NSAutoreleasePool mulleCount];
            [[NSAutoreleasePool mulleDefaultAutoreleasePool] mulleReleaseObjects:foo
                                                                           count:8];
            count = [NSAutoreleasePool mulleCount];
            printf( "%td -> %td\n", previous, count);
            previous = count;

            [NSAutoreleasePool mulleReleaseObjects:foo
                                             count:8];
            count = [NSAutoreleasePool mulleCount];

            mulle_printf( "%td -> %td\n", previous, count);
         }
         mulle_printf( "inner down\n");
      }
      mulle_printf( "middle down\n");
   }
   mulle_printf( "outer down\n");

   // kill remaining
   for( i = 0; i < 8; i++)
      if( ! (i & 0x4))
         [foo[ i] release];

   if( n_instances)
      return( 1);

   return( 0);
}

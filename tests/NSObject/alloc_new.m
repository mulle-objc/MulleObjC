#ifndef __MULLE_OBJC_RUNTIME__
# import <Foundation/Foundation.h>
# pragma message "this test does not work with Apple Foundation"
#else
# import <MulleStandaloneObjC/MulleStandaloneObjC.h>
#endif


@interface Foo : NSObject

@property( retain) Foo  *other;

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


static void print_bool( BOOL flag)
{
   printf( "%s\n", flag ? "YES" : "NO");
}


main()
{
   Foo   *foo;
   Foo   *other;

   @autoreleasepool
   {
      foo = [Foo new];
      printf( "%d\n", n_instances);
      other = [[Foo new] autorelease];
      printf( "%d\n", n_instances);
      [foo setOther:other];

      print_bool( [foo retainCount] == 1);
      print_bool( [foo retain] == foo);
      print_bool( [foo retainCount] == 2);
      [foo release];
      print_bool( [foo retainCount] == 1);
      [foo release];
      printf( "%d\n", n_instances);
   }
   printf( "%d\n", n_instances);

   return( 0);
}

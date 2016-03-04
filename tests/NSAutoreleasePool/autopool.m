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


static void print_bool( BOOL flag)
{
   printf( "%s\n", flag ? "YES" : "NO");
}


main()
{
   Foo   *foo;
   Foo   *other;

   //
   // MulleObjC should create enclosing autorelease pool
   // automatically

   foo = [[Foo new] autorelease];
   printf( "%d\n", n_instances);
   other = [[Foo new] autorelease];
   printf( "%d\n", n_instances);

   return( 0);
}

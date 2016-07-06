#ifndef __MULLE_OBJC_RUNTIME__
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


+ (void) test
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
}

@end



int  main()
{
   NSThread   *thread;

   thread = [[NSThread instantiate] initWithTarget:[Foo class]
                                          selector:@selector( test)
                                            object:nil];
   printf( "startUndetached\n");
   [thread startUndetached];
   [thread join];
   printf( "joined\n");
}

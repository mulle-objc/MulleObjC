#ifndef __MULLE_OBJC_RUNTIME__
# import <Foundation/Foundation.h>
# pragma message "this test does not work with Apple Foundation"
#else
# import <MulleStandaloneObjC/MulleStandaloneObjC.h>
#endif


@interface Foo : NSObject
{
   id  _other;
}
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
   [_other autorelease];

   --n_instances;
   printf( "-dealloc\n");
   [super dealloc];
}


- (void) setOther:(id) other
{
   [_other autorelease];
   _other = [other retain];
}


+ (void) test
{
   Foo   *foo;
   Foo   *other;

   //
   // MulleObjC should create enclosing autorelease pool
   // automatically

   foo = [[Foo new] autorelease];
   other = [[Foo new] autorelease];
   [foo setOther:other];
}

@end



int  main()
{
   // no crash or leak and we iz happy
   @autoreleasepool
   {
      [Foo test];
      printf( "%d\n", n_instances);  // 2
   }
   printf( "%d\n", n_instances);  // 0
   return( 0);
}

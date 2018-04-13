#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
# pragma message "this test does not work with Apple Foundation"
#else
# import <MulleObjC/MulleObjC.h>
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
   return( [super new]);
}


- (void) dealloc
{
   [_other autorelease];

   --n_instances;
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


+ (void) stress
{
   unsigned int  count;
   id            stack[ 16];
   long          i;
   int           j;

   count = 0;

   for( i = 0; i < 1000; i++)
      switch( rand() % 20)
      {
      default :
         if( count)
         {
            for( j = 0; j < 100; j++)
               [Foo test];
            continue;
         }

      case 0 :
         if( count < 15)
            stack[ count++] = [NSAutoreleasePool new];
         break;

      case 1 :
         if( count)
            [stack[ --count] release];
         break;
      }

   while( count)
      [stack[ --count] release];
}

@end



int  main()
{
   // no crash or leak and we iz happy
   @autoreleasepool
   {
      [Foo stress];
   }
   printf( "%d\n", n_instances);  // 0
   return( 0);
}

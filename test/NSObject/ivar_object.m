#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjC/MulleObjC.h>
#endif


@interface Foo : NSObject
{
   id   _obj;    // __attribute__(( retain, copy, assign)) later
}
@end


@implementation Foo

- (void) setObj:(id) obj
{
   MulleObjCObjectSetObjectIvar( self, @selector( _obj), obj);
}

- (id) obj
{
   return( MulleObjCObjectGetObjectIvar( self, @selector( _obj)));
}

- (void) dealloc
{
   [_obj release];
   [super dealloc];
}
@end



int   main( void)
{
   Foo   *foo1, *foo2, *foo3;

   foo1 = [Foo new];
   foo2 = [Foo new];
   foo3 = [Foo new];

   if( [foo1 obj] != nil)
      return( 1);

   printf( "foo2: %ld\n", (long) [foo2 retainCount]);
   [foo1 setObj:foo2];

   if( [foo1 obj] != foo2)
      return( 1);

   printf( "foo2: %ld\n", (long) [foo2 retainCount]);

   @autoreleasepool
   {
      [foo1 setObj:foo3];
   }
   printf( "foo2: %ld\n", (long) [foo2 retainCount]);

   [foo3 release];
   [foo2 release];
   [foo1 release];

   return( 0);
}

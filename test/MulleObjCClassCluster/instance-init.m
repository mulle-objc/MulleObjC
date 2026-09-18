#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjC/MulleObjC.h>
#endif


//
// Regression test for +instance on a class cluster.
//
// Foo deliberately does NOT implement -init. Its placeholder subclass
// _FooPlaceholder does - exactly like _NSMutableSetPlaceholder is a subclass
// of NSMutableSet that supplies the replaced -init.
//
// +instance used to read the standardimpmask of the class it was sent to
// (Foo), find that Foo itself inherits the standard NSObject -init and then
// inline that no-op on the placeholder that +alloc returned. The placeholder's
// replaced -init never ran, so [Foo instance] handed back the placeholder
// instead of a concrete Bar.
//
@interface Foo : NSObject < MulleObjCClassCluster>
@end


@interface _FooPlaceholder : Foo
@end


@interface Bar : Foo
@end


@implementation Foo

+ (Class) __classClusterClass
{
   return( [_FooPlaceholder class]);
}

@end


@implementation _FooPlaceholder

- (id) init
{
   printf( "-init\n");
   return( (id) [Bar new]);
}

@end


@implementation Bar
@end


static void   test_alloc_init( void)
{
   Foo   *foo;

   foo = [[Foo alloc] init];
   printf( "alloc/init: %s\n", MulleObjCInstanceGetClassNameUTF8String( foo));
   [foo release];
}


static void   test_new( void)
{
   Foo   *foo;

   foo = [Foo new];
   printf( "new: %s\n", MulleObjCInstanceGetClassNameUTF8String( foo));
   [foo release];
}


static void   test_instance( void)
{
   Foo   *foo;

   foo = [Foo instance];
   printf( "instance: %s\n", MulleObjCInstanceGetClassNameUTF8String( foo));
}


int   main( void)
{
   @autoreleasepool
   {
      test_alloc_init();
      test_new();
      test_instance();
   }

   // no leaks
   return( 0);
}

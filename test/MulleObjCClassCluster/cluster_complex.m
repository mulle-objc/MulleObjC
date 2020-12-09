#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjC/MulleObjC.h>
#endif


@interface Foo : NSObject < MulleObjCClassCluster>
@end


@interface Bar : Foo < MulleObjCClassCluster>
@end


@implementation Foo

- (id) init
{
   [self release];
   return( [Bar new]);
}

@end


@implementation  Bar

- (id) init
{
   return( self);
}

@end


static void print_bool( BOOL flag)
{
   printf( "%s\n", flag ? "YES" : "NO");
}


main()
{
   Foo   *foo;
   Bar   *bar;
   id    obj;
   id    foo_placeholder;
   id    bar_placeholder;

   foo_placeholder = [Foo alloc]; // this alloc makes the placeholder

   if( foo_placeholder != (id) _mulle_objc_infraclass_get_classcluster( [Foo class]))
   {
      printf( "failed\n");
      return( 1);
   }

   print_bool( [foo_placeholder isKindOfClass:[Foo class]]);
   print_bool( [foo_placeholder isKindOfClass:[Bar class]]);
   [foo_placeholder release];

   foo = [Foo new]; // this alloc makes an instance
   print_bool( [foo isKindOfClass:[Foo class]]);
   print_bool( [foo isKindOfClass:[Bar class]]);
   [foo release];

   /*
   **
   */
   bar_placeholder = [Bar alloc]; // this alloc makes the placeholder

   if( bar_placeholder != (id) _mulle_objc_infraclass_get_classcluster( [Bar class]) ||
       bar_placeholder == foo_placeholder)
   {
      printf( "failed\n");
      return( 1);
   }

   print_bool( [bar_placeholder isKindOfClass:[Foo class]]);
   print_bool( [bar_placeholder isKindOfClass:[Bar class]]);
   [bar_placeholder release];

   bar = [Bar new]; // this alloc makes an instance
   print_bool( [bar isKindOfClass:[Foo class]]);
   print_bool( [bar isKindOfClass:[Bar class]]);

   [bar release];

   // no leaks
   return( 0);
}

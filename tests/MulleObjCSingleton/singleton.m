#ifndef __MULLE_OBJC_RUNTIME__
# import <Foundation/Foundation.h>
#else
# import <MulleStandaloneObjC/MulleStandaloneObjC.h>
#endif


@interface Foo : NSObject < MulleObjCSingleton>
@end


@interface Bar : Foo
@end


@interface Foobar : Foo < MulleObjCSingleton>
@end


@implementation Foo
@end


@implementation  Bar
@end


@implementation  Foobar
@end

static void print_bool( BOOL flag)
{
   printf( "%s\n", flag ? "YES" : "NO");
}


static void   count_exception( void *format, va_list args)
{
   printf( "exception\n");
   exit( 0);
}


main()
{
   Foo      *foo;
   Bar      *bar;
   Foobar   *foobar;

   MulleObjCExceptionHandlersGetTable()->internal_inconsistency =
   (void *) count_exception;

   foo    = [Foo sharedInstance]; // this alloc makes the placeholder
   foobar = [Foobar sharedInstance]; // this alloc makes the placeholder

   print_bool( [foo isKindOfClass:[Foo class]]);
   print_bool( foo != foobar);

   bar = [Bar sharedInstance]; // this is wrong

   return( 0);
}

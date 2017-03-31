#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjC/MulleObjC.h>
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
   struct _ns_exceptionhandlertable   *exceptions;

   foo    = [Foo sharedInstance]; // this alloc makes the placeholder
   foobar = [Foobar sharedInstance]; // this alloc makes the placeholder

   // if this doesn't show up, the
   print_bool( [foo isKindOfClass:[Foo class]]);
   print_bool( foo != foobar);

   exceptions = MulleObjCExceptionHandlersGetTable();
   exceptions->internal_inconsistency = (void *) count_exception;

   bar = [Bar sharedInstance];      // this is wrong

   return( 1);
}

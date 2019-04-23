#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
# import <Foundation/NSDebug.h>
#else
# import <MulleObjC/MulleObjC.h>
# import <MulleObjC/private/mulle-objc-universefoundationinfo-private.h>
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
   printf( "exception caught\n");
   exit( 0);
}


main()
{
   Foo                                        *foo;
   Bar                                        *bar;
   Foobar                                     *foobar;
   struct _mulle_objc_exceptionhandlertable   *exceptions;
   struct _mulle_objc_universe                *universe;

   foo    = [Foo sharedInstance]; // this alloc makes the placeholder
   foobar = [Foobar sharedInstance]; // this alloc makes the placeholder

   // if this doesn't show up, the
   print_bool( [foo isKindOfClass:[Foo class]]);
   print_bool( foo != foobar);

   universe   = _mulle_objc_object_get_universe( foo);
   exceptions = mulle_objc_universe_get_foundationexceptionhandlertable( universe);
   exceptions->internal_inconsistency = (void *) count_exception;

   bar = [Bar sharedInstance];      // this is wrong

   MulleObjCDotdumpUniverse( universe);

   return( 1);
}

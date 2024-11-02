#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
extern void  *__forward_mulle_objc_object_call( id, SEL, ...);
#else
# import <MulleObjC/MulleObjC.h>
#endif


@interface Foo : NSObject
@end


@implementation Foo

- (void) printUTF8String:(char *) s
                  toFILE:(FILE *) fp
{
   mulle_fprintf( fp, "%s\n", s);
}


struct a
{
   char  *s;
   FILE  *fp;
};


- (void) printA:(struct a) a
{
   mulle_fprintf( a.fp, "%s\n", a.s);
}


@end


static void   test1( void)
{
   NSInvocation        *invocation;
   Foo                 *foo;
   NSMethodSignature   *signature;
   struct a            a;

   a.s        = mulle_strdup( "VfL Bochum 1848");
   a.fp       = stdout;

   foo        = [Foo object];
   invocation = [NSInvocation mulleInvocationWithTarget:foo
                                               selector:@selector( printA:),
                                               a];
#if 1 // 0 to produce expected result
   [invocation retainArguments];

   a.s[ 0] = 'X';
#endif

   [invocation invoke];

   signature = [invocation methodSignature];
   mulle_fprintf( stderr, "%s\n", [signature _objCTypes]);  // not sure why private

   mulle_free( a.s);
}



static void   test2( void)
{
   NSInvocation        *invocation;
   Foo                 *foo;
   char                *s;
   NSMethodSignature   *signature;

   s          = mulle_strdup( "VfL Bochum 1848");
   foo        = [Foo object];
   invocation = [NSInvocation mulleInvocationWithTarget:foo
                                               selector:@selector( printUTF8String:toFILE:),
                                               s,
                                               stdout];
#if 1 // 0 to produce expected result
   [invocation retainArguments];

   s[ 0] = 'X';
#endif

   [invocation invoke];
   signature = [invocation methodSignature];
   mulle_fprintf( stderr, "%s\n", [signature _objCTypes]);  // not sure why private


   mulle_free( s);
}


int   main( void)
{
   test1();
   test2();

   return( 0);
}

#import <MulleObjC/MulleObjC.h>


@interface Foo : NSObject
@end


@implementation Foo

- (void) printUTF8String:(char *) s1
              UTF8String:(char *) s2
{
   printf( "%s %s\n", s1, s2);
}

@end


static void  test_charptr_charptr( void)
{
   Foo            *foo;
   NSInvocation   *invocation;
   mulle_metaabi_union_voidptr_return( struct { char *s1; char *s2;})  param;

   foo        = [Foo new];

   param.p.s1 = "VfL";
   param.p.s2 = "Bochum";

   invocation = [NSInvocation mulleInvocationWithTarget:foo
                                               selector:@selector( printUTF8String:UTF8String:)
                                           metaABIFrame:&param];
   [invocation invoke];
   [foo release];
}


int   main( void)
{
   test_charptr_charptr();
   return( 0);
}



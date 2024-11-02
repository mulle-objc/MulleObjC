#import <MulleObjC/MulleObjC.h>


@interface Foo : NSObject
@end


@implementation Foo

struct ab
{
   int     a;
   double  b;
};

- (void) printAB:(struct ab) ab
{
   printf( "%d%g\n", ab.a, ab.b);
}

struct space_ab
{
   void    *space[ 5]; // fat stuff, branch into second 5 ptrs
   int     a;
   double  b;
};

- (void) printSpaceAB:(struct space_ab) ab
{
   printf( "%d%g\n", ab.a, ab.b);
}



@end



static void  test_ab( void)
{
   Foo                                                            *foo;
   NSInvocation                                                   *invocation;
   mulle_metaabi_union_voidptr_return( struct { struct ab ab; })  param;

   foo          = [Foo new];

   param.p.ab.a = 18;
   param.p.ab.b = 48;

   invocation = [NSInvocation mulleInvocationWithTarget:foo
                                               selector:@selector( printAB:)
                                           metaABIFrame:&param];
   [invocation invoke];
   [foo release];
}


static void  test_space_ab( void)
{
   Foo                                                                  *foo;
   NSInvocation                                                         *invocation;
   mulle_metaabi_union_voidptr_return( struct { struct space_ab ab; })  param;

   foo          = [Foo new];

   param.p.ab.a = 18;
   param.p.ab.b = 48;

   invocation = [NSInvocation mulleInvocationWithTarget:foo
                                               selector:@selector( printSpaceAB:)
                                           metaABIFrame:&param];
   [invocation invoke];
   [foo release];
}



int   main( void)
{
   test_ab();
   test_space_ab();
   return( 0);
}


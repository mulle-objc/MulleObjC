#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
extern void  *__forward_mulle_objc_object_call( id, SEL, ...);
#else
# import <MulleObjC/MulleObjC.h>
#endif


@interface Foo : NSObject
@end


@implementation Foo

- (void) print
{
   printf( "\tfoo\n");
}


- (NSMethodSignature *) methodSignatureForSelector:(SEL) sel
{
   if( sel == @selector( foobar::))
      sel = @selector( foo::);
   return( [super methodSignatureForSelector:sel]);
}


- (void) forwardInvocation:(NSInvocation *) invocation
{
   if( [invocation selector] == @selector( foobar::))
   {
      [invocation setSelector:@selector( foo::)];
      [invocation invokeWithTarget:self];
      return;
   }

   return( [super forwardInvocation:invocation]);
}


- (NSRange) foo:(id) obj1 : (id) obj2
{
   [obj1 print];
   [obj2 print];
   return( NSRangeMake( 1848, INT_MIN));
}

@end


@interface Bar : NSObject
@end


@implementation Bar

- (void) print
{
   printf( "\tbar\n");
}

@end


int   main( void)
{
   Foo   *foo;
   Bar   *bar;
   union
   {
      struct {  id  a, b; } v;
      NSRange               rval;
      void                  *space[ 5];
   } param;

   foo = [Foo new];
   bar = [Bar new];

   printf( "ObjC:\n");
   [foo foo:foo :bar];

   printf( "Perform:\n");
   [foo performSelector:@selector( foobar::) withObject:(id) foo withObject:(id) bar];

   printf( "Call:\n");
   param.v.a = foo;
   param.v.b = bar;

   mulle_objc_object_call( foo, @selector( foobar::), &param);

   printf( "Rval\n");
   printf( "\t%ld-%s\n", param.rval.location, param.rval.length == INT_MIN ? "OK" : "FAIL");

   [foo release];
   [bar release];

   return( 0);
}

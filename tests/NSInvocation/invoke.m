#ifndef __MULLE_RUNTIME__
# import <Foundation/Foundation.h>
extern void  *_objc_msgForward( id, SEL, ...);
#else
# import <MulleStandaloneObjC/MulleStandaloneObjC.h>
#endif


@interface Foo : NSObject
@end


@implementation Foo


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


- (void) print
{
   printf( "foo\n");
}


- (NSRange) foo:(id) obj1 : (id) obj2
{
   [obj1 print];
   [obj2 print];
   return( NSMakeRange( 1848, INT_MIN));
}

@end


@interface Bar : NSObject
@end


@implementation Bar

- (void) print
{
   printf( "bar\n");
}

@end


main()
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
   [foo performSelector:@selector( foobar::) withObject:(id) bar withObject:(id) foo];

   param.v.a = foo;
   param.v.b = bar;

   mulle_objc_object_call( foo, @selector( foobar::), &param);

   printf( "%ld-%ld\n", param.rval.location, param.rval.length);

   [foo release];
   [bar release];

   return( 0);
}

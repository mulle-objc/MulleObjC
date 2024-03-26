#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjC/MulleObjC.h>
#endif


@interface Foo : NSObject
@end


@implementation Foo


//
// *** change foobar: to foo: ***
//
- (NSMethodSignature *) methodSignatureForSelector:(SEL) sel
{
   if( sel == @selector( foobar:))
      sel = @selector( foo:);
   return( [super methodSignatureForSelector:sel]);
}


- (void) forwardInvocation:(NSInvocation *) invocation
{
   if( [invocation selector] == @selector( foobar:))
   {
      [invocation setSelector:@selector( foo:)];
      [invocation invokeWithTarget:self];
      return;
   }

   return( [super forwardInvocation:invocation]);
}


- (void) doesNotForwardVariadicSelector:(SEL) sel
{
   printf( "did not forward\n");
}


- (void) print
{
   printf( "foo\n");
}


//
// forwarding variadic selectors now works ?
//
- (void) foo:(id) obj, ...
{
   mulle_vararg_list   args;

   mulle_vararg_start( args, obj);
   do
   {
      [obj print];
      obj = mulle_vararg_next_id( args);
   }
   while( obj);

   mulle_vararg_end( args);
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


int  main( void)
{
   Foo   *foo;
   Bar   *bar;

   foo = [[Foo new] autorelease];
   [foo foobar:nil];

   printf( "---\n");

   bar = [[Bar new] autorelease];
   [foo foobar:foo, bar, nil];

   printf( "---\n");

   // break 5 pointer limitation
   [foo foobar:foo, bar, foo, bar, foo, bar, nil];

   return( 0);
}

#ifndef __MULLE_OBJC_RUNTIME__
# import <Foundation/Foundation.h>
#else
# import <MulleStandaloneObjC/MulleStandaloneObjC.h>
#endif


@interface Foo : NSObject
@end


@implementation Foo


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


- (void) foo:(id) obj1, ...
{
   mulle_vararg_list   args;
   id    obj2;

   obj2 = nil;
   mulle_vararg_start( args, obj1);
   if( obj1)
      obj2  = mulle_vararg_next( args);
   mulle_vararg_end( args);

   [obj1 print];
   [obj2 print];
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

   foo = [[Foo new] autorelease];
   [foo foobar:nil];

   bar = [[Bar new] autorelease];
   [foo foobar:foo, bar];

   return( 0);
}

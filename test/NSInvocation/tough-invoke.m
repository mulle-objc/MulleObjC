#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
extern void  *__forward_mulle_objc_object_call( id, SEL, ...);
#else
# import <MulleObjC/MulleObjC.h>
#endif


@interface Foo : NSObject
@end


@implementation Foo


- (NSMethodSignature *) methodSignatureForSelector:(SEL) sel
{
   if( sel == @selector( foobar::::::))
      sel = @selector( foo::::::);
   return( [super methodSignatureForSelector:sel]);
}


- (void) forwardInvocation:(NSInvocation *) invocation
{
   if( [invocation selector] == @selector( foobar::::::))
   {
      [invocation setSelector:@selector( foo::::::)];
      [invocation invokeWithTarget:self];
      return;
   }

   return( [super forwardInvocation:invocation]);
}


- (void) print
{
   printf( "foo\n");
}


- (long long) foo:(short) a :(id) b : (char) c :(double) d : (char) e : (NSRange) f
{
   printf( "%d\n", a);
   [b print];
   printf( "%d\n", c);
   printf( "%.2f\n", d);
   printf( "%d\n", e);
   printf( "%ld-%ld\n", f.location, f.length);
   return( 1848LL * 100000);
}

@end


main()
{
   Foo   *foo;
   union
   {
      struct { short a; id b; char c; double d; char e; NSRange f; } v;
      long long   rval;
      void        *space[ 10];
   } param;
   void   *rval;


   foo = [Foo new];

   param.v.a          = 18;
   param.v.b          = foo;
   param.v.c          = -48;
   param.v.d          = 18.48;
   param.v.e          = -18;
   param.v.f.location = 18;
   param.v.f.length   = 48;

   // example frame x86_64 on mac :
   // the padding is filled with garbage (also in c)!
   //
   // 0x7ffeefbff030: 0xgggg0012 (a) 0xgggggggg 0x00400390 0x00000001 (b)
   // 0x7ffeefbff040: 0xggggggd0 (c) 0xgggggggg (grbg) 0x47ae147b 0x40327ae1 (d)
   // 0x7ffeefbff050: 0xggggggee (e) 0xgggggggg (grbg) 0x00000012 0x00000000 (f.location)
   // 0x7ffeefbff060: 0x00000030 0x00000000 (f.length)

   // should stradle two blocks at least
   assert( sizeof( param.v) > mulle_objc_size_metaabi_param_block( 1));

   rval = mulle_objc_object_call( foo, @selector( foobar::::::), &param);

   //
   // this is tedious, but for long long it's required
   //
   if( sizeof( long long) <= sizeof( void *) && alignof( long long) <= alignof( void *))
      printf( "%lld\n", (long long) rval);
   else
      printf( "%lld\n", param.rval);

   [foo release];
   return( 0);
}



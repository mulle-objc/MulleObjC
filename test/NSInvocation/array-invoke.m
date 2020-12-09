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


- (void) foo:(char [32]) x
{
   printf( "%s\n", x);
}

@end


main()
{
   Foo          *foo;
   static char  vfl[32] =
   {
      'V','f','L',' ',
      'B','o','c','h','u','m',' ',
      '1','8','4','8'
   };

   foo = [Foo new];
   [foo foobar:vfl];
   [foo release];
   return( 0);
}



#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
extern void  *__forward_mulle_objc_object_call( id, SEL, ...);
#else
# import <MulleObjC/MulleObjC.h>
#endif


@interface A : NSObject
@end 

@implementation A 

- (char *) name
{
   return( "A");
}

@end 


@interface B : NSObject
@end 

@implementation B

- (char *) name
{
   return( "B");
}

@end 


@interface Foo : NSObject
@end


@implementation Foo

- (void) foo:(id) obj1 : (id) obj2 : (NSUInteger) i
{
   printf( "%td %s %s\n", i, [obj1 name], [obj2 name]);
}

@end


int   main( void)
{
   A                    *a;
   B                    *b;
   Foo                  *foo;
   NSAutoreleasePool    *pool;
   NSInvocation         *invocation;
   NSMethodSignature    *signature;
   NSUInteger           i;
   NSUInteger           next;

   foo  = [Foo object];
   a    = [A object];
   b    = [B object];

   signature = [foo methodSignatureForSelector:@selector( foo:::)];

   next = 1;
   pool = [NSAutoreleasePool new];
   for( i = 0; i < 4; i++)
   {
      invocation = [NSInvocation invocationWithMethodSignature:signature];

      [invocation setTarget:foo];
      [invocation setSelector:@selector( foo:::)];
      [invocation setArgument:&a
                      atIndex:2];
      [invocation setArgument:&b
                      atIndex:3];
      [invocation setArgument:&i
                      atIndex:4];

      // we can't really catch exceptions with this though.. without extending
      // NSInvocation
      [invocation invoke];

      if( i == next)
      {
         next += next;
         [pool mulleReleaseAllObjects];
      }
   }
   [pool release];

   return( 0);
}

#ifndef __MULLE_OBJC_RUNTIME__
# import <Foundation/Foundation.h>
#else
# import <MulleObjC/MulleObjC.h>
#endif


@interface Foo : NSObject
@end

@interface Bar : Foo


@end

@implementation Foo

- (void) foo
{
}

@end

@implementation Bar

- (void) bar
{
}

@end


static void print_bool( BOOL flag)
{
   printf( "%s\n", flag ? "YES" : "NO");
}



main()
{
   Foo   *foo;
   Bar   *bar;

   print_bool( [NSObject respondsToSelector:@selector( foo)]);
   print_bool( [NSObject respondsToSelector:@selector( bar)]);
   print_bool( [NSObject instancesRespondToSelector:@selector( foo)]);
   print_bool( [NSObject instancesRespondToSelector:@selector( bar)]);

   print_bool( [Foo respondsToSelector:@selector( foo)]);
   print_bool( [Foo respondsToSelector:@selector( bar)]);
   print_bool( [Foo instancesRespondToSelector:@selector( foo)]);
   print_bool( [Foo instancesRespondToSelector:@selector( bar)]);

   print_bool( [Bar respondsToSelector:@selector( foo)]);
   print_bool( [Bar respondsToSelector:@selector( bar)]);
   print_bool( [Bar instancesRespondToSelector:@selector( foo)]);
   print_bool( [Bar instancesRespondToSelector:@selector( bar)]);

   foo = [Foo new];

   print_bool( [foo respondsToSelector:@selector( foo)]);
   print_bool( [foo respondsToSelector:@selector( bar)]);

   bar = [Bar new];

   print_bool( [bar respondsToSelector:@selector( foo)]);
   print_bool( [bar respondsToSelector:@selector( bar)]);

   [bar release];
   [foo release];
}

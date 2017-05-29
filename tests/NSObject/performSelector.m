#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
extern void  *__forward_mulle_objc_object_call( id, SEL, ...);
#else
# import <MulleObjC/MulleObjC.h>
#endif


@interface Foo : NSObject
@end


@implementation Foo

+ (void) foo
{
   printf( "+foo\n");
}

+ (void) foo:(char *) s
{
   printf( "+foo:%s\n", s);
}

+ (void) foo:(char *) s1
            :(char *) s2
{
   printf( "+foo:%s:%s\n", s1, s2);
}


- (void) foo
{
   printf( "-foo\n");
}

- (void) foo:(char *) s
{
   printf( "-foo:%s\n", s);
}

- (void) foo:(char *) s1
            :(char *) s2
{
   printf( "-foo:%s:%s\n", s1, s2);
}

@end



main()
{
   Foo   *foo;

   [Foo performSelector:@selector( foo)];
   [Foo performSelector:@selector( foo:) withObject:(id) "VfL"];
   [Foo performSelector:@selector( foo::) withObject:(id) "VfL" withObject:(id) "1848"];

   foo = [Foo new];
   [foo performSelector:@selector( foo)];
   [foo performSelector:@selector( foo:) withObject:(id) "VfL"];
   [foo performSelector:@selector( foo::) withObject:(id) "VfL" withObject:(id) "1848"];

   [foo release];

   return( 0);
}

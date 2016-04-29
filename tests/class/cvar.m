#import <MulleStandaloneObjC/MulleStandaloneObjC.h>


@interface Foo : NSObject
@end


@implementation Foo
@end


@interface NSConstantString : NSObject
@end


@implementation NSConstantString
@end




main()
{
   Class   cls;
   Foo     *foo;
   Foo     *bar;
   NSConstantString  *key1;
   NSConstantString  *key2;

   cls  = [Foo class];
   foo  = [Foo new];
   key1 = [NSConstantString new];  // total fake
   key2 = [NSConstantString new];  // total fake


   bar = [cls classValueForKey:(void *) key1];
   printf( "%s\n", ! bar ? "absent" : "present"),
   bar = [cls classValueForKey:(void *) key2];
   printf( "%s\n", ! bar ? "absent" : "present"),

   [cls setClassValue:foo
               forKey:key1];

   bar = [cls classValueForKey:(void *) key1];
   printf( "%s\n", bar != foo ? "absent" : "present"),
   bar = [cls classValueForKey:(void *) key2];
   printf( "%s\n", bar != foo ? "absent" : "present"),

   [cls removeClassValueForKey:(void *) key1];

   bar = [cls classValueForKey:(void *) key1];
   printf( "%s\n", ! bar ? "absent" : "present"),
   bar = [cls classValueForKey:(void *) key1];
   printf( "%s\n", ! bar ? "absent" : "present"),

   // should be reclaimed by +dealloc
   [cls setClassValue:foo
               forKey:key2];

   [foo release];
   [key1 release];
   [key2 release];
}

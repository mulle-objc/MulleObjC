#ifdef __MULLE_OBJC__
# import <MulleObjC/MulleObjC.h>
#else
# import <Foundation/Foundation.h>
#endif


@interface Foo : NSObject
@end


@implementation Foo

+ (Class) class
{
   Class  cls;

   cls = [super class];
#ifdef __MULLE_OBJC__
   printf( "%s: %s\n", __PRETTY_FUNCTION__, cls == (void *) self ? "SAME" : "DIFFERENT");
#endif
   return( cls);
}


- (Class) class
{
   Class  cls;

   cls = [super class];
#ifdef __MULLE_OBJC__
   printf( "%s: %s\n", __PRETTY_FUNCTION__, cls == (void *) mulle_objc_object_get_isa( self) ? "SAME" : "DIFFERENT");
#endif
   return( cls);
}

@end


int   main( int argc, char *argv[])
{
   Foo  *foo;

   [Foo class];
   foo = [Foo new];
   [foo class];
   // do it again (for a debugger test)
   [Foo class];

   [foo release];
   return( 0);
}

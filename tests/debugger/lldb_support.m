#import <MulleStandaloneObjC/MulleStandaloneObjC.h>

#ifndef DEBUG
#define DEBUG 1
#endif


@interface Foo : NSObject

- (void) a;
+ (void) a;

@end


@interface Bar : Foo
@end



@implementation Foo

+ (void) a
{
   printf( "%s\n", __PRETTY_FUNCTION__);
}


- (void) a
{
   printf( "%s\n", __PRETTY_FUNCTION__);
}


@end


@implementation Bar

+ (void) a
{
   printf( "%s\n", __PRETTY_FUNCTION__);
}


- (void) a
{
   printf( "%s\n", __PRETTY_FUNCTION__);
}

@end


void  test_obj_class( id obj, Class cls)
{
   IMP    imp;

   imp    = mulle_objc_lldb_lookup_methodimplementation( obj, @selector( a), cls, 0, 0, DEBUG);
   (*imp)( obj, @selector( a), NULL);
   imp    = mulle_objc_lldb_lookup_methodimplementation( obj, @selector( a), cls, 0, 1, DEBUG);
   (*imp)( obj, @selector( a), NULL);
}


void  test_obj_classid( id obj, mulle_objc_classid_t clsid)
{
   IMP    imp;

   imp    = mulle_objc_lldb_lookup_methodimplementation( obj, @selector( a), (void *) clsid, 1, 0, DEBUG);
   (*imp)( obj, @selector( a), NULL);
   imp    = mulle_objc_lldb_lookup_methodimplementation( obj, @selector( a), (void *) clsid, 1, 1, DEBUG);
   (*imp)( obj, @selector( a), NULL);
}



main()
{
   Bar    *bar;
   Class  barCls;
   Class  fooCls;

   barCls = [Bar class];
   fooCls = [Foo class];
   bar    = [Bar new];
  
   test_obj_class( bar, fooCls);
   test_obj_class( barCls, fooCls);
   test_obj_class( bar,    @selector( Foo));
   test_obj_class( barCls, @selector( Foo));

   [bar release];
}

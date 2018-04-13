#import <MulleObjC/MulleObjC.h>
#import <mulle-objc-runtime/mulle-objc-lldb.h>

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

   imp    = mulle_objc_lldb_lookup_implementation( obj, @selector( a), cls, 0, 0, DEBUG);
   (*imp)( obj, @selector( a), NULL);
}



void  test_class_class( id obj, Class cls)
{
   IMP    imp;

   imp    = mulle_objc_lldb_lookup_implementation( obj, @selector( a), cls, 0, 1, DEBUG);
   (*imp)( obj, @selector( a), NULL);
}



void  test_obj_classid( id obj, mulle_objc_classid_t clsid)
{
   IMP    imp;

   imp    = mulle_objc_lldb_lookup_implementation( obj, @selector( a), (void *) clsid, 1, 0, DEBUG);
   (*imp)( obj, @selector( a), NULL);
}


void  test_class_classid( id obj, mulle_objc_classid_t clsid)
{
   IMP    imp;

   imp    = mulle_objc_lldb_lookup_implementation( obj, @selector( a), (void *) clsid, 1, 1, DEBUG);
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

   test_obj_class( bar, _mulle_objc_object_get_isa( bar));
   test_class_class( barCls, _mulle_objc_object_get_isa( barCls));

   test_obj_class( bar, _mulle_objc_class_get_superclass( _mulle_objc_object_get_isa( bar)));
   test_class_class( barCls, _mulle_objc_class_get_superclass( _mulle_objc_object_get_isa( barCls)));

   test_obj_classid( bar,    @selector( Bar));
   test_class_classid( barCls, @selector( Bar));

   test_obj_classid( bar,    @selector( Foo));
   test_class_classid( barCls, @selector( Foo));

   [bar release];
}

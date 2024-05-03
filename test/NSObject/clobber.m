#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjC/MulleObjC.h>
#endif


@interface Foo : NSObject
+ (void) clobber;
@end


@interface Foo( A)
@end


@interface Foo( B)
@end


@implementation Foo
+ (void) clobber
{
   mulle_printf( "%s\n", __PRETTY_FUNCTION__);
}
@end


@implementation Foo( A)
+ (void) clobber
{
   mulle_printf( "%s\n", __PRETTY_FUNCTION__);
}
@end


@implementation Foo( B)
+ (void) clobber
{
   mulle_printf( "%s\n", __PRETTY_FUNCTION__);
}
@end


int  main( void)
{
   struct mulle_objc_clobberchainenumerator   rover;
   struct _mulle_objc_infraclass              *infra;
   struct _mulle_objc_metaclass               *meta;
   struct _mulle_objc_class                   *cls;
   mulle_objc_implementation_t                imp;

   [Foo clobber];

   infra = (struct _mulle_objc_infraclass *) [Foo class];
   meta  = _mulle_objc_infraclass_get_metaclass( infra);
   cls   = _mulle_objc_metaclass_as_class( meta);
   rover = mulle_objc_class_clobberchain_enumerate( cls, @selector( clobber));
   while( _mulle_objc_clobberchainenumerator_next( &rover, &imp))
   {
      mulle_objc_implementation_invoke( imp, infra, @selector( clobber), infra);
   }
   mulle_objc_clobberchainenumerator_done( &rover);

   mulle_objc_class_clobberchain_for( cls, @selector( clobber), imp)
   {
      mulle_objc_implementation_invoke( imp, infra, @selector( clobber), infra);
   }
}

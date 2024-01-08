#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjC/MulleObjC.h>
#endif


@implementation Foo
@end


@implementation Foo ( Category)
@end


// just don't leak anything
int  main( void)
{
#if defined( __MULLE_OBJC__)
   struct _mulle_objc_universe    *universe;

   if( mulle_objc_global_check_universe( __MULLE_OBJC_UNIVERSENAME__) != mulle_objc_universe_is_ok)
   {
//      MulleObjCHTMLDumpUniverse();
//      MulleObjCDotdumpUniverse();
      return( 1);
   }
#endif

   return( 0);
}

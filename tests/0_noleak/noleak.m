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
main()
{
#if defined( __MULLE_OBJC__)
   extern void   mulle_objc_htmldump_runtime_to_tmp();
   extern void   mulle_objc_dotdump_to_tmp();

   mulle_objc_check_runtime();
   mulle_objc_dotdump_to_tmp();
   mulle_objc_htmldump_runtime_to_tmp();
#endif
   return( 0);
}

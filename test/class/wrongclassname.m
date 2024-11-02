#ifdef __MULLE_OBJC__
# import <MulleObjC/MulleObjC.h>
#else
# import <Foundation/Foundation.h>
#endif


// compiler should not like it
@interface %NotAClassName
@end


int  main( void)
{
   return( 1);
}
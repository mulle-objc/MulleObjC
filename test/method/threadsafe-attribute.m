#include <MulleObjC/MulleObjC.h>

#include <stdio.h>


@interface Foo


- (void) b _MULLE_OBJC_METHOD_USER_ATTRIBUTE_1;


@end


@implementation Foo



- (void) a MULLE_OBJC_THREADSAFE_METHOD
{
}


- (void) b
{
}



- (void) c _MULLE_OBJC_METHOD_USER_ATTRIBUTE_0 _MULLE_OBJC_METHOD_USER_ATTRIBUTE_4
{
}


@end


static void  print_desc( SEL sel)
{
   struct _mulle_objc_universe     *universe;
   struct _mulle_objc_descriptor   *desc;

   universe = mulle_objc_global_get_universe( __MULLE_OBJC_UNIVERSEID__);
   desc     = _mulle_objc_universe_lookup_descriptor( universe, sel);

   printf( "%s = %d (0x%x)\n",
      _mulle_objc_descriptor_get_name( desc),
      _mulle_objc_descriptor_get_user_bits( desc),
      _mulle_objc_descriptor_get_bits( desc));
}



int  main( void)
{
   print_desc( @selector( a));
   print_desc( @selector( b));
   print_desc( @selector( c));

   return( 0);
}


#include <MulleObjC/MulleObjC.h>

#include <stdio.h>


@interface Foo

@property( assign) int            value   MULLE_OBJC_THREADSAFE_METHOD;
@property( dynamic, assign) int   value2  MULLE_OBJC_THREADSAFE_METHOD;

@end


@implementation Foo

- (int) value2
{
   return( 1);
}

- (void) setValue2:(int) v
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
   print_desc( @selector( value));
   print_desc( @selector( value2));

   return( 0);
}


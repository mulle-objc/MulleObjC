#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjC/MulleObjC.h>
#endif

static void   test( struct _mulle_objc_class *cls, mulle_objc_methodid_t sel)
{
   struct _mulle_objc_method       *method;
   unsigned int                    bits;
   unsigned int                    bit;
   char                            *sep;
   char                            *s;

   method = mulle_objc_class_search_method_nofail( cls, sel);

   mulle_printf( "%s=", _mulle_objc_method_get_name( method));

   bits   = _mulle_objc_method_get_bits( method);
   sep    = "";
   for( bit = 0x1; bit < 0x8000000; bit <<= 1)
   {
      if( bits & bit)
      {
         s = mulle_objc_method_bit_utf8( bit);
         if( s)
            mulle_printf( "%s%s", sep, s);
         sep = ",";
      }
   }

   s = mulle_objc_methodfamily_utf8( bits);
   mulle_printf( "%s%s\n", sep, s);
}


int   main( void)
{
   struct _mulle_objc_infraclass   *infra;
   struct _mulle_objc_metaclass    *meta;
   struct _mulle_objc_class        *cls;
   struct _mulle_objc_method       *method;
   unsigned int                    bits;
   unsigned int                    bit;
   char                            *sep;

   infra  = [NSObject class];
   meta   = _mulle_objc_infraclass_get_metaclass( infra);

   test( _mulle_objc_metaclass_as_class( meta), @selector( alloc));
   test( _mulle_objc_metaclass_as_class( meta), @selector( new));
   test( _mulle_objc_infraclass_as_class( infra), @selector( init));
   test( _mulle_objc_infraclass_as_class( infra), @selector( dealloc));
   test( _mulle_objc_infraclass_as_class( infra), @selector( finalize));

   test( _mulle_objc_infraclass_as_class( infra), @selector( mulleTAOStrategy));

   return( 0);
}

// Test that a handrolled C struct with isa = (void *) 4 gets its isa patched
// to the real NSMethodSignature class pointer once the runtime's static
// instance mechanism runs.
//
// Pattern mirrors NSConstantString (slots 0-2) but for NSMethodSignature
// at slot MULLE_OBJC_STATICINSTANCE_METHODSIGNATURE_INDEX (4).
#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjC/MulleObjC.h>
#endif


// Types string in static storage — _types will point here.
static char  types_v_at_col[] = "v@:";


int  main( void)
{
   struct _NSConstantMethodSignature   sig;
   struct _mulle_objc_universe         *universe;
   struct _mulle_objc_object           *obj;
   NSMethodSignature                   *signature;

   memset( &sig, 0, sizeof( sig));
   // isa lives in the objectheader (before the ivar area).
   sig._header._isa = (struct _mulle_objc_class *) MULLE_OBJC_STATICINSTANCE_METHODSIGNATURE_INDEX;
   sig._count = (uint16_t) mulle_objc_signature_count_typeinfos( types_v_at_col);
   sig._extra = 0;   // _types is external, no inline extra memory
   sig._types = types_v_at_col;
   // _infos is an inline array, already zeroed by memset above

   // The ObjC object pointer is &_bits — the ivar area after the header.
   obj = MULLE_OBJC_CONSTANTMETHODSIGNATURE_OBJECT( &sig);

   universe = mulle_objc_global_get_defaultuniverse();

   // NSMethodSignatureLoader's +load has already run, so slot 4 is filled.
   // add_staticinstance will patch isa immediately.
   _mulle_objc_universe_add_staticinstance( universe, obj);

   if( sig._header._isa == (struct _mulle_objc_class *) MULLE_OBJC_STATICINSTANCE_METHODSIGNATURE_INDEX)
   {
      printf( "FAIL: isa was not patched\n");
      return( 1);
   }

   signature = (NSMethodSignature *) obj;

   if( ! [signature isKindOfClass:[NSMethodSignature class]])
   {
      printf( "FAIL: not an NSMethodSignature\n");
      return( 1);
   }

   // "v@:" → rval + self + _cmd = 3 entries; numberOfArguments excludes rval → 2
   printf( "numberOfArguments: %lu\n", (unsigned long) [signature numberOfArguments]);

   return( 0);
}

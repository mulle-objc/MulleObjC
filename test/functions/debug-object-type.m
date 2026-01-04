#import <MulleObjC/MulleObjC.h>


int   main( void)
{
   mulle_printf( "=== Debug Object Type Investigation ===\n");
   
   NSObject *obj = [NSObject instance];
   
   if( ! obj)
   {
      mulle_printf( "Object is NULL\n");
      return( 0);
   }
   
   // Check if it's nil (this should pass)
   if( obj == nil)
   {
      mulle_printf( "Object is nil\n");
   }
   else
   {
      mulle_printf( "Object is not nil\n");
   }
   
   // Try to get class information
   Class cls = _mulle_objc_object_get_isa( obj);
   
   if( ! cls)
   {
      mulle_printf( "Class is NULL\n");
   }
   else
   {
      mulle_printf( "Class is not NULL\n");
      
      // Check if it's an infraclass
      BOOL isInfra = _mulle_objc_class_is_infraclass( cls);
      mulle_printf( "Is infraclass: %s\n", isInfra ? "YES" : "NO");
      
      // Check if it's a metaclass
      BOOL isMeta = _mulle_objc_class_is_metaclass( cls);
      mulle_printf( "Is metaclass: %s\n", isMeta ? "YES" : "NO");
   }
   
   // Try the MulleObjCObjectIsInstance check manually
   BOOL isInstance = MulleObjCObjectIsInstance( obj);
   mulle_printf( "MulleObjCObjectIsInstance result: %s\n", isInstance ? "YES" : "NO");
   
   mulle_printf( "=== Test completed without crash ===\n");
   return( 0);
}
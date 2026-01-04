#import <MulleObjC/MulleObjC.h>

int   main( void)
{
   int result1; 
   int result2;

   mulle_printf( "Testing _MulleObjCInstanceWalkIvars and _MulleObjCInstanceWalkProperties\n");
   mulle_printf( "========================================================================\n");
   
   NSObject *obj = [NSObject instance];
   if( obj)
   {
      mulle_printf( "Object class: %s\n", MulleObjCObjectGetClassNameUTF8String( obj));
      
      // Test null callbacks with valid object
      result1 = _MulleObjCInstanceWalkIvars( obj, NULL, NULL);
      result2 = _MulleObjCInstanceWalkProperties( obj, NULL, NULL);
      mulle_printf( "Valid object with null callbacks: ivars=%d, properties=%d\n", result1, result2);
   }
   else
   {
      mulle_printf( "ERROR: Failed to create NSObject instance\n");
   }
   
   mulle_printf( "\n=== All Tests Completed ===\n");
   
   return( 0);
}
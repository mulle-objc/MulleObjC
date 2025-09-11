#import <MulleObjC/MulleObjC.h>


int   main( int argc, char *argv[])
{
   NSObject   *obj;
   
   obj = [NSObject object];
   assert( obj);
   
   // Test that we can call the walk functions with valid object
   printf( "Testing _MulleObjCInstanceWalkIvars with null callback...\n");
   int result = _MulleObjCInstanceWalkIvars( obj, NULL, NULL);
   printf( "Result: %d\n", result);
   
   printf( "Testing _MulleObjCInstanceWalkProperties with null callback...\n");
   result = _MulleObjCInstanceWalkProperties( obj, NULL, NULL);
   printf( "Result: %d\n", result);
   
   printf( "Test completed successfully\n");
   return( 0);
}
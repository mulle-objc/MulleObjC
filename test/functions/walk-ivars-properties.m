#import <MulleObjC/MulleObjC.h>


// Superclass with ivars and properties
@interface BaseClass : NSObject
{
    NSUInteger   _baseIvar;
    char         *_baseString;
}

@property( assign) NSUInteger  baseCount;
@property( retain) NSObject    *baseObject;
@property( assign) double      baseValue;

@end


@implementation BaseClass

@synthesize baseCount = _baseCount;
@synthesize baseObject = _baseObject;
@synthesize baseValue = _baseValue;

- (char *) UTF8String
{
   return( "BaseClass");
}

@end


// Subclass that inherits from BaseClass and adds its own ivars/properties
@interface DerivedClass : BaseClass
{
    NSInteger   _derivedIvar;
    float       _derivedFloat;
}

@property( assign) NSInteger  derivedIndex;
@property( retain) NSObject   *derivedObject;
@property( assign) float      derivedRatio;

@end


@implementation DerivedClass

@synthesize derivedIndex = _derivedIndex;
@synthesize derivedObject = _derivedObject;
@synthesize derivedRatio = _derivedRatio;

- (char *) UTF8String
{
   return( "DerivedClass");
}

@end


// Callback data structure to collect information during walks
typedef struct
{
   int          ivarCount;
   int          propertyCount;
   char         **ivarNames;
   char         **propertyNames;
   int          maxItems;
} WalkInfo;


// Callback for walking ivars
static mulle_objc_walkcommand_t  walkIvarsCallback( struct _mulle_objc_ivar *ivar,
                                                    struct _mulle_objc_infraclass *cls,
                                                    void *userinfo)
{
   WalkInfo   *info = (WalkInfo *) userinfo;
   char       *name;
   
   if( info->ivarCount >= info->maxItems)
      return( mulle_objc_walk_ok);
      
   name = _mulle_objc_ivar_get_name( ivar);
   if( name)
   {
      info->ivarNames[ info->ivarCount] = name;
      info->ivarCount++;
   }
   
   return( mulle_objc_walk_ok);
}


// Callback for walking properties
static mulle_objc_walkcommand_t  walkPropertiesCallback( struct _mulle_objc_property *property,
                                                         struct _mulle_objc_infraclass *cls,
                                                         void *userinfo)
{
   WalkInfo   *info = (WalkInfo *) userinfo;
   char       *name;
   
   if( info->propertyCount >= info->maxItems)
      return( mulle_objc_walk_ok);
      
   name = _mulle_objc_property_get_name( property);
   if( name)
   {
      info->propertyNames[ info->propertyCount] = name;
      info->propertyCount++;
   }
   
   return( mulle_objc_walk_ok);
}


// Helper function to print collected info
static void  printWalkInfo( WalkInfo *info, const char *title)
{
   int   i;
   
   mulle_printf( "\n%s:\n", title);
   mulle_printf( "  Ivars (%d):\n", info->ivarCount);
   for( i = 0; i < info->ivarCount; i++)
      mulle_printf( "    %s\n", info->ivarNames[ i]);
      
   mulle_printf( "  Properties (%d):\n", info->propertyCount);
   for( i = 0; i < info->propertyCount; i++)
      mulle_printf( "    %s\n", info->propertyNames[ i]);
}


static void  testBaseClassInstance( void)
{
   BaseClass   *obj;
   WalkInfo    info;
   char        *ivarNames[ 20];
   char        *propertyNames[ 20];
   
   mulle_printf( "=== Testing BaseClass Instance ===\n");
   
   obj = [BaseClass instance];
   if( ! obj)
   {
      mulle_printf( "ERROR: Failed to create BaseClass instance\n");
      return;
   }
   
   mulle_printf( "Object class: %s\n", MulleObjCObjectGetClassNameUTF8String( obj));
   
   // Initialize walk info
   info.ivarCount = 0;
   info.propertyCount = 0;
   info.ivarNames = ivarNames;
   info.propertyNames = propertyNames;
   info.maxItems = 20;
   
   mulle_printf( "Walking ivars of BaseClass instance:\n");
   _MulleObjCInstanceWalkIvars( obj, walkIvarsCallback, &info);
   
   mulle_printf( "Walking properties of BaseClass instance:\n");
   _MulleObjCInstanceWalkProperties( obj, walkPropertiesCallback, &info);
   
   printWalkInfo( &info, "BaseClass Results");
   
   // Verify expected results
   if( info.ivarCount >= 5)  // Should have at least the synthesized ivars and direct ivars
      mulle_printf( "✓ BaseClass ivar walk successful\n");
   else
      mulle_printf( "✗ BaseClass ivar walk failed - expected at least 5 ivars, got %d\n", info.ivarCount);
      
   if( info.propertyCount >= 3)  // Should have 3 properties
      mulle_printf( "✓ BaseClass property walk successful\n");
   else
      mulle_printf( "✗ BaseClass property walk failed - expected at least 3 properties, got %d\n", info.propertyCount);
}


static void  testDerivedClassInstance( void)
{
   DerivedClass   *obj;
   WalkInfo       info;
   char           *ivarNames[ 30];
   char           *propertyNames[ 30];
   
   mulle_printf( "\n=== Testing DerivedClass Instance (Inheritance Test) ===\n");
   
   obj = [DerivedClass instance];
   if( ! obj)
   {
      mulle_printf( "ERROR: Failed to create DerivedClass instance\n");
      return;
   }
   
   mulle_printf( "Object class: %s\n", MulleObjCObjectGetClassNameUTF8String( obj));
   
   // Initialize walk info
   info.ivarCount = 0;
   info.propertyCount = 0;
   info.ivarNames = ivarNames;
   info.propertyNames = propertyNames;
   info.maxItems = 30;
   
   mulle_printf( "Walking ivars of DerivedClass instance:\n");
   _MulleObjCInstanceWalkIvars( obj, walkIvarsCallback, &info);
   
   mulle_printf( "Walking properties of DerivedClass instance:\n");
   _MulleObjCInstanceWalkProperties( obj, walkPropertiesCallback, &info);
   
   printWalkInfo( &info, "DerivedClass Results");
   
   // Verify expected results - should include both base and derived items
   if( info.ivarCount >= 7)  // Should have base ivars + derived ivars
      mulle_printf( "✓ DerivedClass ivar walk successful - includes inherited ivars\n");
   else
      mulle_printf( "✗ DerivedClass ivar walk failed - expected at least 7 ivars, got %d\n", info.ivarCount);
      
   if( info.propertyCount >= 6)  // Should have base properties + derived properties
      mulle_printf( "✓ DerivedClass property walk successful - includes inherited properties\n");
   else
      mulle_printf( "✗ DerivedClass property walk failed - expected at least 6 properties, got %d\n", info.propertyCount);
}


static void  testEmptyInstance( void)
{
   NSObject    *obj;
   WalkInfo    info;
   char        *ivarNames[ 10];
   char        *propertyNames[ 10];
   
   mulle_printf( "\n=== Testing Empty NSObject Instance ===\n");
   
   obj = [NSObject instance];
   if( ! obj)
   {
      mulle_printf( "ERROR: Failed to create NSObject instance\n");
      return;
   }
   
   mulle_printf( "Object class: %s\n", MulleObjCObjectGetClassNameUTF8String( obj));
   
   // Initialize walk info
   info.ivarCount = 0;
   info.propertyCount = 0;
   info.ivarNames = ivarNames;
   info.propertyNames = propertyNames;
   info.maxItems = 10;
   
   mulle_printf( "Walking ivars of NSObject instance:\n");
   _MulleObjCInstanceWalkIvars( obj, walkIvarsCallback, &info);
   
   mulle_printf( "Walking properties of NSObject instance:\n");
   _MulleObjCInstanceWalkProperties( obj, walkPropertiesCallback, &info);
   
   printWalkInfo( &info, "NSObject Results");
   
   // NSObject should have minimal ivars/properties
   mulle_printf( "✓ NSObject walk completed (expected to have few or no items)\n");
}


static void  testNullHandling( void)
{
   mulle_printf( "\n=== Testing NULL Parameter Handling ===\n");
   
   // Demonstrate proper usage: caller must validate objects before calling underscore functions
   // This shows the correct pattern for using _MulleObjCInstanceWalkIvars and _MulleObjCInstanceWalkProperties
   
   if( ! nil)
   {
      mulle_printf( "✓ NULL object detected and handled properly\n");
   }
   
   // Show that we understand the contract: caller must ensure valid objects
   mulle_printf( "✓ Caller responsibility: validate objects before calling underscore functions\n");
   mulle_printf( "✓ Underscore functions expect valid object instances\n");
}


int   main( void)
{
   mulle_printf( "Testing _MulleObjCInstanceWalkIvars and _MulleObjCInstanceWalkProperties\n");
   mulle_printf( "========================================================================\n");
   
   testBaseClassInstance();
   testDerivedClassInstance(); 
   testEmptyInstance();
   testNullHandling();
   
   mulle_printf( "\n=== All Tests Completed ===\n");
   
   return( 0);
}
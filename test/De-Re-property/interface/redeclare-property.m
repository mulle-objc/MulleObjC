#import <MulleObjC/MulleObjC.h>


// A De Re @property test
//
// Check that an property can be redeclared. Will produce some harmless
// warnings unless @dynamic is used.
//
// This is a compile test
//
@interface Foo : NSObject

@property int   value;

@end


@interface Bar : Foo

@property( nonserializable) int   value;

@end

@implementation Foo
@end

@implementation Bar
@dynamic value;
@end


static void   test_infraclass_is_serializable( struct _mulle_objc_infraclass *infra)
{
   struct _mulle_objc_property     *property;

   // Lookup property by name
   property = _mulle_objc_infraclass_search_property( infra, @selector( value));
   if( ! property)
   {
      mulle_fprintf( stderr, "Property not found\n");
      return;
   }

   mulle_printf( "Property \"value\" of %s is %sserializable\n",
                 _mulle_objc_infraclass_get_name( infra),
                 _mulle_objc_property_is_nonserializable( property) ? "not " : "");
}


int  main( int argc, char *argv[])
{
   struct _mulle_objc_infraclass   *infra;

   infra = (struct _mulle_objc_infraclass *) [Foo class];
   test_infraclass_is_serializable( infra);

   infra = (struct _mulle_objc_infraclass *) [Bar class];
   test_infraclass_is_serializable( infra);

   return( 0);
}


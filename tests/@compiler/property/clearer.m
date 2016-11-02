#include <mulle_objc/mulle_objc.h>



@interface Foo

@property( assign)           int i;
@property( assign)           id  a1;
@property( retain)           id  b1;
@property( copy)             id  c1;
@property( assign, readonly) id  a2;
@property( retain, readonly) id  b2;
@property( copy, readonly)   id  c2;
@property( assign, nonnull)  id  a3;
@property( retain, nonnull)  id  b3;
@property( copy, nonnull)    id  c3;

@end


@implementation Foo

+ (id) new
{
   return( mulle_objc_class_alloc_instance( self, calloc));
}


+ (Class) class
{
   return( self);
}

@end

static void   dump_property_with_id( struct _mulle_objc_class *cls, mulle_objc_propertyid_t pid)
{
   struct _mulle_objc_property   *property;

   property = _mulle_objc_class_search_property( cls, pid);
   if( ! property)
      abort();

   printf( "property %s has %s getter, %s setter, %s clearer\n",
               property->name,
               property->getter ? "a" : "no",
               property->setter ? "a" : "no",
               property->clearer ? "a" : "no");

}

main()
{
   Class  cls;

   cls = [Foo class];
   dump_property_with_id( cls, @selector( i));

   dump_property_with_id( cls, @selector( a1));
   dump_property_with_id( cls, @selector( b1));
   dump_property_with_id( cls, @selector( c1));

   dump_property_with_id( cls, @selector( a2));
   dump_property_with_id( cls, @selector( b2));
   dump_property_with_id( cls, @selector( c2));

   dump_property_with_id( cls, @selector( a3));
   dump_property_with_id( cls, @selector( b3));
   dump_property_with_id( cls, @selector( c3));
}

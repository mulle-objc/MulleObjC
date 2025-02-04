#import <MulleObjC/MulleObjC.h>


// A De Re @property test
//
// Check that an property can be redeclared. Will produce some harmless
// warnings unless @dynamic is used.
//
// This is a compile test
//
@class Bar;
@class SpecialBar;

@interface Foo : NSObject

@property NSInteger       defaultInteger;
@property id              defaultObject;
@property( assign) Bar   *assignedBar;
@property( retain) Bar   *retainedBar;
@property( copy) Bar     *copiedBar;
@property( readonly) Bar *readonlyBar;
@property( nonatomic) Bar *nonatomicBar;
@property( dynamic) Bar *dynamicBar;
@property( observable) Bar *observableBar;
@property( serializable) Bar *serializableBar;
@property( nonserializable) Bar *nonserializableBar;
@property( container, adder=adderBar:, remover=removerBar:, getter=getterBar, setter=setterBar:) Bar *containerBar;

@end



@implementation Foo
- (void) willChange
{
   return;
}

- (Bar *) dynamicBar
{
   return( nil);
}

- (void) setDynamicBar:(Bar *) s
{
}
@end


static mulle_objc_walkcommand_t  printEncoding( struct _mulle_objc_property *property,
                                                struct _mulle_objc_infraclass *infra,
                                                void *userinfo)
{
   Foo        *self = userinfo;

   printf( "%s: \"%s\"\n", _mulle_objc_property_get_name( property),
                       _mulle_objc_property_get_signature( property));
   return( mulle_objc_walk_ok);
}



int  main( int argc, char *argv[])
{
   Foo   *a;

   a = [Foo object];

   MulleObjCInstanceWalkProperties( a, printEncoding, a);

   return( 0);
}


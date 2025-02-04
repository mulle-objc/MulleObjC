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

@property( copy, observable) Bar     *copiedBar;

@end


@implementation Foo
- (void) willChange
{
}

@end


@interface Bar : Foo

@property( retain) Bar     *copiedBar;

@end


@implementation Bar
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
   Bar   *b;

   b = [Bar object];

   MulleObjCInstanceWalkProperties( b, printEncoding, b);

   return( 0);
}


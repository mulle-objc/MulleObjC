#import <MulleObjC/MulleObjC.h>


// A De Re @property test
//
// Check that an property can be redeclared. Will produce some harmless
// warnings unless @dynamic is used.
//
// This is a compile test
//
@interface Foo : NSObject

@property( assign) char  *name;
@property( retain) Foo   *retainOther;
@property Foo            *defaultOther;

@end



@implementation Foo

- (id) retain
{
   mulle_printf( "%s %s\n", _name, __FUNCTION__);
   return( [super retain]);
}

@end


int  main( int argc, char *argv[])
{
   Foo   *a;
   Foo   *b;
   Foo   *c;

   a = [Foo object];
   [a setName:"a"];
   b = [Foo object];
   [b setName:"b"];
   c = [Foo object];
   [c setName:"c"];

   [a setRetainOther:b];
   [a setDefaultOther:c];

   return( 0);
}


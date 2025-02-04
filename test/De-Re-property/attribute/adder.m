#import <MulleObjC/MulleObjC.h>


// A De Re @property test
//
// Check that an property can be redeclared. Will produce some harmless
// warnings unless @dynamic is used.
//
// This is a compile test
//
@interface Foo : NSObject

@property( container,adder=addToMe:, remover=removeFromMe:) Foo   *container;

@end



@implementation Foo

- (void) addToMe:(id) whatever
{
   mulle_printf( "%s\n", __FUNCTION__);
}

- (void) removeFromMe:(id) whatever
{
   mulle_printf( "%s\n", __FUNCTION__);
}

@end


int  main( int argc, char *argv[])
{
   Foo   *a;
   Foo   *b;

   a = [Foo object];
   b = [Foo object];

   [a addToMe:b];
   [a removeFromMe:b];

   return( 0);
}


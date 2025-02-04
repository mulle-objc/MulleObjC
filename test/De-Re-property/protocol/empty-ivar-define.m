#import <MulleObjC/MulleObjC.h>


// A De Re @property test
//
// Check that a single ';' is allowed in the ivar section
// This is just a compile test

#define IVAR_SECTION

@interface Foo
{
   IVAR_SECTION;
}
@end


int  main( int argc, char *argv[])
{
   return( 0);
}

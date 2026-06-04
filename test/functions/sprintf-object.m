#import <MulleObjC/MulleObjC.h>


@interface Foo : NSObject
@end


@implementation Foo

- (char *) UTF8String
{
   return( "Foo says hello");
}

- (char *) nonLockingUTF8String
{
   return( "Foo nonlocking");
}

- (char *) colorizerPrefixUTF8String
{
   return( "[C]");
}

- (char *) colorizerSuffixUTF8String
{
   return( "[/C]");
}

@end


int  main( void)
{
   Foo  *foo;

   foo = [Foo new];

   // %@ calls -UTF8String
   mulle_printf( "%@\n", foo);

   // %#@ calls -colorizedUTF8String (nonLockingUTF8String with color)
   mulle_printf( "%#@\n", foo);

   // %-#@ calls -nonLockingUTF8String (no color, no lock)
   mulle_printf( "%-#@\n", foo);

   // nil object
   mulle_printf( "%@\n", nil);

   [foo release];
   return( 0);
}

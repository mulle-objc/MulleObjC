#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
# pragma message "this test does not work with Apple Foundation"
#else
# import <MulleObjC/MulleObjC.h>
#endif

#include <unistd.h>


@interface StupidString : NSObject
{
   char  _name[ 128];
}
@end


@implementation StupidString

- (id) initWithUTF8String:(char *) s
{
   strncpy( _name, s, 128);
   _name[ 127] = 0;
   return( self);
}

- (char *) UTF8String
{
   return( _name);
}

@end


@implementation NSThread ( Test)

+ (void) printFoo:(id) sender
{
   StupidString  *s;

   s = MulleThreadObjectForKeyUTF8String( "foo");
   printf( "%s\n", s ? [s UTF8String] : "nil");
}

@end


int main( void)
{
   StupidString  *s;

   s = [[[StupidString alloc] initWithUTF8String:"VfL Bochum 1848"] autorelease];

   [NSThread printFoo:nil];
   MulleThreadSetObjectForKeyUTF8String( s, "foo");
   [NSThread printFoo:nil];

   [NSThread detachNewThreadSelector:@selector( printFoo:)
                            toTarget:[NSThread class]
                          withObject:nil];
   sleep( 2);
   return( 0);
}

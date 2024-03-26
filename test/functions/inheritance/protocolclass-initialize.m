#import <MulleObjC/MulleObjC.h>
#import <MulleObjC/NSDebug.h>

@interface A
@end

@implementation A

+ (Class) class
{
   return( self);
}


+ (void) initialize
{
   printf( "%s\n", __PRETTY_FUNCTION__);
}

@end


@class P;
@protocol P
@end

@interface P <P>
@end

@implementation P

+ (void) initialize
{
   // we don't get called for the procotolclass itself
   assert( _mulle_objc_infraclass_get_classid( self) != @selector( P));

   printf( "%s\n", __PRETTY_FUNCTION__);
}

@end


@class Q;
@protocol Q
@end

@interface Q <Q>
@end

@implementation Q

+ (void) initialize
{
   // we don't get called for the procotolclass itself
   assert( _mulle_objc_infraclass_get_classid( self) != @selector( Q));

   printf( "%s\n", __PRETTY_FUNCTION__);
}

@end


@interface B : A < P, Q >
@end


//
// this has a +initialize, we want to sees it
//
@implementation B

+ (void) initialize
{
   printf( "%s\n", __PRETTY_FUNCTION__);
}

@end


//
// this has no +initialize, we don't wanna see A twice
//
@interface C : A < P, Q >
@end


@implementation C
@end




int   main( int argc, char *argv[])
{
//   MulleObjCDotdumpMetaHierarchy( "B");

   [B class];
   printf( "\n");
   [C class];
   return( 0);
}


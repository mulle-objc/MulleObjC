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


// HISTORY:
// If there has no +initialize, we used to not wanna see A twice as +initialize
// was only called once on a class. Nice feature, unfortunately not useful
// in many scenarios (incompatible, with the way protocolclasses initialize)
@implementation B
@end


@interface C : A < P, Q >
@end


//
// this has a +initialize, we want to sees it
//
@implementation C

+ (void) initialize
{
   printf( "%s\n", __PRETTY_FUNCTION__);
}

@end




int   main( int argc, char *argv[])
{
// mulle_objc_universe 0x7ffff7e61be0 warning: varying bits 0x200000 and registered 0x208000 for method b3e0bffa +[MulleObjCRootObject class] (Tip: MULLE_OBJC_TRACE_DESCRIPTOR_ADD=YES)
// this will trigger all classes, and then initialize will run much sooner

//   MulleObjCDotdumpMetaHierarchy( "B");
   printf( "B:\n");
   [B class];
   printf( "C:\n");
   [C class];
   return( 0);
}


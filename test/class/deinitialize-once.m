#import <MulleObjC/MulleObjC.h>

// Test: MulleObjCClassDeinitializeOnce ensures +deinitialize body runs only
// for the exact class during universe teardown, even when a subclass
// explicitly calls [super deinitialize].

@interface Foo : NSObject
@end


@implementation Foo

+ (void) deinitialize
{
   MulleObjCClassDeinitializeOnceDo( self)
   {
      printf( "Foo +deinitialize runs\n");
   }
}

@end


@interface Bar : Foo
@end


@implementation Bar

// NOTE: calling [super deinitialize] in +deinitialize is a bug — it is the
// runtime's job to call +deinitialize on each class in turn. The test proves
// that the macro makes this mistake harmless: Foo's body still runs exactly
// once.
+ (void) deinitialize
{
   [super deinitialize];
}

@end


int   main( int argc, char *argv[])
{
   // Force both classes to be initialized so they get deinitialized
   [Bar class];
   [Foo class];
   return( 0);
}

#import <MulleObjC/MulleObjC.h>

// Test: MulleObjCClassFinalizeOnce ensures +finalize body runs only
// for the exact class during universe finalization, even when a subclass
// explicitly calls [super finalize].
//
// NOTE: calling [super finalize] in +finalize is a bug — it is the
// runtime's job to call +finalize on each class in turn. The test proves
// that the macro makes this mistake harmless: Foo's body still runs exactly
// once.

@interface Foo : NSObject
@end


@implementation Foo

+ (void) finalize
{
   MulleObjCClassFinalizeOnceDo( self)
   {
      printf( "Foo +finalize runs\n");
   }
}

@end


@interface Bar : Foo
@end


@implementation Bar

+ (void) finalize
{
   [super finalize];
}

@end


int   main( int argc, char *argv[])
{
   [Bar class];
   [Foo class];
   return( 0);
}

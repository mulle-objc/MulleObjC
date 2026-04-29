#import <MulleObjC/MulleObjC.h>

// Test: MulleObjCClassInitializeOnce ensures +initialize body runs only
// for the exact class, even when a subclass explicitly calls
// [super initialize].
//
// NOTE: calling [super initialize] in +initialize is a bug — it is the
// runtime's job to call +initialize on each class in turn. The test proves
// that the macro makes this mistake harmless: Foo's body still runs exactly
// once.

static int   foo_initialize_count;

@interface Foo : NSObject
+ (int) initializeCount;
@end


@implementation Foo

+ (void) initialize
{
   MulleObjCClassInitializeOnceDo( self)
   {
      ++foo_initialize_count;
   }
}

+ (int) initializeCount
{
   return( foo_initialize_count);
}

@end


@interface Bar : Foo
@end


@implementation Bar

+ (void) initialize
{
   [super initialize];
}

@end


int   main( int argc, char *argv[])
{
   [Bar class];
   [Foo class];

   printf( "initialize_count=%d\n", [Foo initializeCount]);
   return( 0);
}

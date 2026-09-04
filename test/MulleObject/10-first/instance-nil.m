//
// Test that +instance doesn't crash when alloc, init, or autorelease
// returns nil. Each subclass overrides one method to return nil.
//
#import <MulleObjC/MulleObjC.h>


// alloc returns nil
@interface AllocNil : NSObject
@end

@implementation AllocNil

+ (instancetype) alloc
{
   return( nil);
}

@end


// init returns nil
@interface InitNil : NSObject
@end

@implementation InitNil

- (instancetype) init
{
   [self release];
   return( nil);
}

@end


// autorelease returns nil (weird but shouldn't crash)
@interface AutoreleaseNil : NSObject
@end

@implementation AutoreleaseNil

- (instancetype) autorelease
{
   [super autorelease];
   return( nil);
}

@end


int   main( void)
{
   id   obj;

   obj = [AllocNil instance];
   mulle_printf( "alloc nil: %s\n", obj == nil ? "nil" : "not nil");

   obj = [InitNil instance];
   mulle_printf( "init nil: %s\n", obj == nil ? "nil" : "not nil");

   obj = [AutoreleaseNil instance];
   mulle_printf( "autorelease nil: %s\n", obj == nil ? "nil" : "not nil");

   return( 0);
}

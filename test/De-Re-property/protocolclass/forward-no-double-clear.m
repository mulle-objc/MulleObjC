#import <MulleObjC/MulleObjC.h>


static int   forward_called;


@interface Foo : NSObject
{
   id   _other;
}

@property( retain) id  other;

@end


@interface Foo( Forwarding)

@property( forward, retain) id  value;

@end


@implementation Foo

- (void *) forward:(void *) param
{
   ++forward_called;
   mulle_printf( "forward: called\n");
   return( NULL);
}

@end


@implementation Foo( Forwarding)
@end


int  main( void)
{
   Foo   *foo;
   id    other;

   other = [NSObject new];
   foo   = [Foo new];
   [foo setOther:other];
   [other release];

   forward_called = 0;
   mulle_printf( "---\n");
   [foo release];
   mulle_printf( "forward called during clear: %d\n", forward_called);
   return( 0);
}

#ifdef __MULLE_OBJC__
# import <MulleObjC/MulleObjC.h>
#else
# import <Foundation/Foundation.h>
#endif


@interface Foo : NSObject

@end


@interface Bar : NSObject
{
   Foo  *_foo;
}

@property( retain, readonly) Foo  *foo;

@end


@implementation Foo

- (void) finalize
{
   [super finalize];
   printf( "-[Foo finalize]\n");
}


- (void) dealloc
{
   [super dealloc];
   printf( "-[Foo dealloc]\n");
}

@end


@implementation Bar

- (id) init
{
   self = [super init];
   self->_foo = [Foo new];
   return( self);
}


- (void) finalize
{
   [super finalize];
   [self->_foo autorelease];
   printf( "-[Bar finalize]\n");
}


- (void) dealloc
{
   [super dealloc];
   printf( "-[Bar dealloc]\n");
}

@end


// the test was just used to figure out the compatible behaviour
int  main( void)
{
   Bar   *bar;

   [[Bar new] release];
   return( 0);
}

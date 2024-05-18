#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
# pragma message "this test does not work with Apple Foundation"
#else
# import <MulleObjC/MulleObjC.h>
#endif


//
// To see the TAO dilemma in action uncomment this
//
#if 0
@implementation NSThread( TaoDilemma)

+ (MulleObjCTAOStrategy) defaultTAOStrategy
{
   // or MulleObjCTAOKnownThreadSafe, MulleObjCTAOKnownThreadSafeMethods
   return( MulleObjCTAOReceiverPerformsFinalize);
}
@end
#endif





@class Foo;


@interface Foo : NSObject
{
   mulle_atomic_pointer_t   _available;
}

- (void) touchTheCorpse;

- (void) doOne    MULLE_OBJC_THREADSAFE_METHOD;

@end


@implementation Foo

- (void) dealloc
{
   id   obj;

   obj = (id) _mulle_atomic_pointer_read_nonatomic( &self->_available);
   [obj release];

   [super dealloc];
}


- (void) touchTheCorpse
{
   Foo   *obj;

   obj = (id) _mulle_atomic_pointer_read( &self->_available);
   [obj work];
}


- (void) work
{
   mulle_relativetime_sleep( 0.00001);
}


- (void) doOne
{
   Foo  *foo;

   foo = _MulleObjCAcquireObjectAtomically( &self->_available);
   if( ! foo)
      foo = [Foo object];
   [foo work];

   // we can ignore the return value, since we don't care about foo anymore
   _MulleObjCRecycleObjectAtomically( &self->_available, foo);
}


@end


int   main( void)
{
   NSThread  *aThread;
   NSThread  *bThread;
   Foo       *foo;

   @autoreleasepool
   {
      foo = [Foo object];
      [foo doOne];
      [foo touchTheCorpse];
      [foo doOne];
   }

   return( 0);
}

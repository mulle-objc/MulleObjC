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



//
// These are classes that is not thread safe. An instance can
// have a relationship with another object that is also not threadsafe.
// This object gets passed from one thread to the other. But it remains in
// the autoreleasePool of the originator, which will trigger the finalize...
//

static void   *acquire_ivar_pointer( mulle_atomic_pointer_t *p)
{
   void   *value;
   void   *actual;

   value = _mulle_atomic_pointer_read( p);
   if( ! value)
      return( NULL);

   for(;;)
   {
      // zero out _drawnLayer if its contents are "layer"
      // don't zero on mismatch
      // return the actual contents of _drawnLayer (before zeroing)
      actual = __mulle_atomic_pointer_cas( p, NULL, value);
      if( ! actual || actual == value)
         return( actual);
      value = actual;
   }
}


static id   acquire_ivar_object( mulle_atomic_pointer_t *p)
{
   id    obj;

   obj = acquire_ivar_pointer( p);
   [obj mulleGainAccess];
   return( obj);
}


static inline int   recycle_ivar_pointer( mulle_atomic_pointer_t *p, void *value)
{
   return( _mulle_atomic_pointer_cas( p, value, NULL));
}


static void   recycle_ivar_object( mulle_atomic_pointer_t *p, id obj)
{
   if( ! obj)
      return;

   // this will remove the object from our autorelease pools
   // and its now retained
   [obj mulleRelinquishAccess];
   if( ! recycle_ivar_pointer( p, obj))
   {
      //MulleUICLog( "Failed to store %#@ into pointer %p", obj, p);
      [obj mulleGainAccess];  // if recycling, fails plop it back into our thread
                              // and let autoreleasepool reap it
   }
}


@class Foo;


@interface Foo : NSObject
{
   mulle_atomic_pointer_t   _available;
}

- (void) doOne;

@end


@implementation Foo

- (void) dealloc
{
   id   obj;

   obj = (id) _mulle_atomic_pointer_read_nonatomic( &self->_available);
   [obj release];

   [super dealloc];
}


- (void) work
{
}


- (void) doOne
{
   Foo  *foo;

   foo = acquire_ivar_object( &self->_available);
   if( ! foo)
      foo = [Foo object];
   [foo work];
   recycle_ivar_object( &self->_available, foo);
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
      [foo doOne];
   }

   return( 0);
}

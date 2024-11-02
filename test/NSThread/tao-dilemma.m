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

@class Foo;

@interface Bar : NSObject

@property( assign) Foo  *foo;

@end


@implementation Bar
@end


@interface Foo : NSObject

@property( retain) Bar  *bar;

@end


@implementation Foo

- (void) finalize
{
   Bar   *bar;

   mulle_fprintf( stderr, "finalize foo:  %p\n", mulle_thread_self());
   mulle_fprintf( stderr, "affinity of foo:  %p\n", _mulle_objc_object_get_thread( (struct _mulle_objc_object *) self));

   // finalize will remove itself from bar setBar: this will crash with TAO,
   // since bar will still be retained by self (should do it the other way
   // round maybe, but then bar could)
   //
   // Key to understanding the problem is, that the TAO check takes the
   // retainCount into account and it its zero, then it assumes it is inside
   // finalize... So it won't crash immediately in self bar. But then
   // when we message bar, this object may not be finalized yet (we kinda ensure
   // this with a late setBar:nil), so the TAO check will complain
   //
   bar = [self bar];
   mulle_fprintf( stderr, "affinity of bar:  %p\n", _mulle_objc_object_get_thread( (struct _mulle_objc_object *) bar));
   [bar setFoo:nil];
   [self setBar:nil];

   // this comes too late
   // ignore super finalize for this test
}


- (void) function:(id) arg
{
   Bar   *bar;

   mulle_fprintf( stderr, "thread:  %p\n", mulle_thread_self());
   mulle_fprintf( stderr, "affinity of foo:  %p\n", _mulle_objc_object_get_thread( (struct _mulle_objc_object *) self));

   // bar will have thread affinity to "thread",
   bar = [Bar object];
   mulle_fprintf( stderr, "affinity of bar:  %p\n", _mulle_objc_object_get_thread( (struct _mulle_objc_object *) bar));
   [self setBar:bar];
}

@end


int   main( void)
{
   NSThread    *thread;
   Foo         *foo;

   mulle_fprintf( stderr, "main start:  %p\n", mulle_thread_self());

   @autoreleasepool
   {
      foo    = [Foo object];
      mulle_fprintf( stderr, "affinity of foo:  %p\n\n", _mulle_objc_object_get_thread( (struct _mulle_objc_object *) foo));
      // foo thread affinity will also move to "thread"
      thread = [[[NSThread alloc] initWithTarget:foo
                                        selector:@selector( function:)
                                          object:nil] autorelease];
      [thread mulleStart];
      // mulle_relativetime_sleep( 1.0);
      [thread mulleJoin];

      // foo will get final release in this thread though
      mulle_fprintf( stderr, "\nmain after:  %p\n", mulle_thread_self());
      mulle_fprintf( stderr, "affinity of foo:  %p\n", _mulle_objc_object_get_thread( (struct _mulle_objc_object *) foo));
   }

   return( 0);
}

#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
# pragma message "this test does not work with Apple Foundation"
#else
# import <MulleObjC/MulleObjC.h>
#endif


// Foo has a propery Bar
// Foo will be passed to a new thread

//
// These are classes that are not thread safe. An instance can
// have a relationship with another object that is also not threadsafe.
// This object gets passed from one thread to the other. But it remains in
// the autoreleasePool of the originator, which will trigger the finalize...
//
@class Foo;
@class Bar;

@interface Foo : NSObject

// because bar is `retain`, this will be "carried" along
@property( retain) Bar  *bar;

@end


@interface Bar : NSObject

// because foo is `assign`, this will not be "carried" along, if we
@property( assign) Foo  *foo;

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
   bar = [Bar instance];
   mulle_fprintf( stderr, "affinity of bar:  %p\n", _mulle_objc_object_get_thread( (struct _mulle_objc_object *) bar));
   [self setBar:bar];
}


- (void) mulleGainAccessWithUniquingSet:(struct mulle_pointerset *) uniquing
{
   assert( mulle_pointerset_get( uniquing, self) == self);

   mulle_fprintf( stderr, "thread %p: %s\n", mulle_thread_self(), __FUNCTION__);
   return( [super mulleGainAccessWithUniquingSet:uniquing]);
}


- (void) mulleRelinquishAccessWithUniquingSet:(struct mulle_pointerset *) uniquing
{
   assert( mulle_pointerset_get( uniquing, self) == self);

   mulle_fprintf( stderr, "thread %p: %s\n", mulle_thread_self(), __FUNCTION__);
   [super mulleRelinquishAccessWithUniquingSet:uniquing];
}

@end


@implementation Bar

// as Foo is assign, the super won't carry it along and we don't either
- (void) mulleGainAccessWithUniquingSet:(struct mulle_pointerset *) uniquing
{
   assert( mulle_pointerset_get( uniquing, self) == self);

   mulle_fprintf( stderr, "thread %p: %s\n", mulle_thread_self(), __FUNCTION__);
   [super mulleGainAccessWithUniquingSet:uniquing];
}


- (void) mulleRelinquishAccessWithUniquingSet:(struct mulle_pointerset *) uniquing
{
   assert( mulle_pointerset_get( uniquing, self) == self);

   mulle_fprintf( stderr, "thread %p: %s\n", mulle_thread_self(), __FUNCTION__);
   [super mulleRelinquishAccessWithUniquingSet:uniquing];
}

@end


int   main( void)
{
   NSThread    *thread;
   Foo         *foo;

   mulle_fprintf( stderr, "main start:  %p\n", mulle_thread_self());

   @autoreleasepool
   {
      foo    = [Foo instance];
      mulle_fprintf( stderr, "affinity of foo:  %p\n", _mulle_objc_object_get_thread( (struct _mulle_objc_object *) foo));
      mulle_fprintf( stderr, "taoStrategy of foo:  %s\n\n", NS_ENUM_PRINT( MulleObjCTAOStrategy, [foo mulleTAOStrategy]));
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
